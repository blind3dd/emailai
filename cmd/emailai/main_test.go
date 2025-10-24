package main

import (
	"context"
	"fmt"
	"sync/atomic"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("WorkerPool", func() {
	It("dispatches tasks round-robin and completes all", func() {
		pool := NewWorkerPool(5, 20, fmt.Errorf("ctx propagation test"))
		ctx := context.Background()
		results := make(chan string, 100)

		Expect(pool.Dispatch(ctx)).To(Succeed())

		var completed int32
		numTasks := pool.numTasks
		for i := 0; i < numTasks; i++ {
			i := i
			email := fmt.Sprintf("email%d@example.com", i)
			task := func(workerID int) {
				processor := &EmailProcessor{WorkerID: workerID}
				job := &Job{ID: i, Data: email, Result: results}
				_ = processor.Process(job)
				atomic.AddInt32(&completed, 1)
			}
			Expect(pool.AddTask(task)).To(Succeed())
		}

		// Wait for results
		eventuallyCount := func() int32 { return atomic.LoadInt32(&completed) }
		Eventually(eventuallyCount, 5*time.Second, 50*time.Millisecond).Should(BeEquivalentTo(numTasks))

		// Drain results
		drained := 0
		for drained < numTasks {
			select {
			case <-results:
				drained++
			case <-time.After(2 * time.Second):
				Fail("timed out draining results")
			}
		}

		Expect(pool.Stop()).To(Succeed())
	})

	It("stops gracefully when context canceled", func() {
		pool := NewWorkerPool(3, 5, fmt.Errorf("ctx propagation test"))
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()
		results := make(chan string, 10)

		Expect(pool.Dispatch(ctx)).To(Succeed())

		for i := 0; i < pool.numTasks; i++ {
			i := i
			email := fmt.Sprintf("email%d@example.com", i)
			task := func(workerID int) {
				processor := &EmailProcessor{WorkerID: workerID}
				_ = processor.Process(&Job{ID: i, Data: email, Result: results})
			}
			_ = pool.AddTask(task)
		}

		// Cancel early and ensure Stop completes
		cancel()
		Expect(pool.Stop()).To(Succeed())
	})
})
