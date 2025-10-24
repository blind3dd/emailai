APP:=emailai
PKG:=github.com/blind3dd/emailai
CMD:=./cmd/emailai

.PHONY: all build test race lint tidy docker docker-run

all: build

build:
	GO111MODULE=on go build $(CMD)

test:
	GO111MODULE=on go test ./...

race:
	CGO_ENABLED=1 go test -race -count=1 -timeout=5m -p 4 -parallel 8 ./...

lint:
	golangci-lint run --timeout=5m

tidy:
	go mod tidy

docker:
	docker build -t $(APP):local .

docker-run:
	docker run --rm -e TZ=UTC $(APP):local
