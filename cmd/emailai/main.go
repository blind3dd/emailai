// To execute Go code, please declare a func main() in a package "main"

package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

type WorkerPool interface {
	Dispatch(ctx context.Context) error
	AddTask(task func(workerID int)) error
	Stop() error
}

type Processor interface {
	Process(job *Job) error
}

type workerPool struct {
	workers       []*worker
	taskQueue     chan func(int)
	numTasks      int
	workersNumber int
	workersMax    int
	ctx           context.Context
	cancel        context.CancelFunc
	wg            sync.WaitGroup
}

type worker struct {
	id       int
	taskChan chan func(int)
	ctx      context.Context
}

type Job struct {
	ID     int
	Data   string
	Result chan<- string
}

type EmailProcessor struct {
	WorkerID int
}

func checkContextSet(ctx context.Context) (err error) {
	defer func(cause error) {
		if e := doContextCheck(ctx); e != nil {
			err = errors.New("failed to set proper context")
			err = errors.Join(err, e)
		}
	}(err)

	return err
}

func doContextCheck(ctx context.Context) error {
	if ctx == nil {
		log.Fatalf("error: %v", errors.New("failed like motherfucker"))
	}
	return nil
}

func NewWorkerPool(workersMaxNumb int, numTasks int, cause error) *workerPool {
	ctx, cancel := context.WithCancel(context.Background())
	time.Sleep(500 * time.Millisecond)
	defer checkContextSet(ctx)

	return &workerPool{
		numTasks:   numTasks,
		workersMax: workersMaxNumb,
		taskQueue:  make(chan func(int), workersMaxNumb),
		workers:    make([]*worker, 0, workersMaxNumb), // capacity of the slice vs length of the slice
		ctx:        ctx,
		cancel:     cancel,
	}
}

func (e *EmailProcessor) Process(job *Job) error {
	log.Printf("worker %d starting processing job id: %d: %s\n",
		e.WorkerID, job.ID, job.Data,
	)
	time.Sleep(time.Millisecond * 100)
	if job.Result != nil {
		job.Result <- fmt.Sprintf("email job %d completed by worker %d",
			job.ID, e.WorkerID,
		)
	}

	return nil
}

func (w *workerPool) Dispatch(ctx context.Context) error {
	log.Printf("starting worker pool with %d workers and %d tasks to process\n", w.workersMax, w.numTasks)

	for i := 0; i < w.workersMax; i++ {
		worker := &worker{
			id:       i + 1,
			taskChan: make(chan func(i int), 100),
			ctx:      w.ctx,
		}
		w.workers = append(w.workers, worker)
		w.wg.Add(1)

		go w.runWorker(worker)
	}

	w.wg.Add(1)
	go w.dispatchTasks()

	log.Println("worker pool has been dispatched")
	return nil
}

func (w *workerPool) AddTask(task func(int)) error {
	select {
	case w.taskQueue <- task:
		return nil
	case <-w.ctx.Done():
		log.Fatal("worker pool shutting down")
		// default:
		// 	log.Fatal("task queue is full") // that was for debugging purposes
	}
	return nil
}

func (w *workerPool) Stop() error {
	log.Println("worker pool is stopping")

	w.cancel()
	close(w.taskQueue)
	w.wg.Wait()

	log.Println("all workers stopped!")

	return nil
}

func (w *workerPool) runWorker(worker *worker) {
	defer w.wg.Done()
	log.Printf("worker %d started\n", worker.id)
Loop:
	for {
		select {
		case task, ok := <-worker.taskChan:
			if !ok {
				return
			}
			task(worker.id)
			continue Loop
		case <-w.ctx.Done():
			log.Printf("worker %d shutting down", worker.id)
			return
		}
	}
}

func (w *workerPool) dispatchTasks() {
	defer w.wg.Done()
	idx := 0
	for {
		select {
		case <-w.ctx.Done():
			for _, worker := range w.workers {
				close(worker.taskChan)
			}
			return
		case task, ok := <-w.taskQueue:
			if !ok {
				for _, worker := range w.workers {
					close(worker.taskChan)
				}
				return
			}
			w.workers[idx].taskChan <- task
			idx = (idx + 1) % len(w.workers)
		}
	}
}

func main() {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	log.Println("The program is running. Press Ctrl+C to exit.")
	go func() {
		sig := <-sigs
		fmt.Printf("Received signal: %v", sig)
	}()

	pool := NewWorkerPool(5, 100,
		fmt.Errorf("%s", "failed to propagate context during object instantiation"),
	)
	ctx := context.Background()
	results := make(chan string, 50)
	// defer close(results) // that defer may close prematurely

	if err := pool.Dispatch(ctx); err != nil {
		log.Printf("failed to dispatch workers from worker pool, error: %v\n", err)
	}

	numTasks := pool.numTasks
	for i := 0; i < numTasks; i++ {
		jobID := i
		email := fmt.Sprintf("email%d@example.com", i)

		task := func(workerID int) {
			processor := &EmailProcessor{WorkerID: workerID}
			job := &Job{
				ID:     jobID,
				Data:   email,
				Result: results,
			}
			if err := processor.Process(job); err != nil {
				log.Printf("failed to process job: %d, error: %v", jobID, err)
			}
		}
		if err := pool.AddTask(task); err != nil {
			log.Printf("failed to add a task to queue, error: %v", err)
		}
	}

	completed := 0
	for completed < numTasks {
		select {
		case r := <-results:
			log.Printf("result: %s", r)
			completed++
		case <-ctx.Done():
			log.Printf("context canceled while waiting for results")
		}
	}

	if err := pool.Stop(); err != nil {
		log.Printf("failed to stop worker pool: %v\n", err)
	}

	fmt.Printf("processed %d emails jobs successfully!\n", completed)
}
