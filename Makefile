APP:=emailai
PKG:=github.com/blind3dd/emailai
CMD:=./cmd/emailai
EXTRACT:=./cmd/extract
PROTO_DIR:=proto
GEN_DIR:=gen
PROTO_FILES:=$(shell find $(PROTO_DIR) -name '*.proto')

.PHONY: all proto build build-extract extract test race lint tidy docker docker-run

all: proto build

# Generate Go from .proto (requires: nix develop — provides protoc + protoc-gen-go)
proto:
	protoc -I $(PROTO_DIR) \
		--go_out=. --go_opt=module=$(PKG) \
		$(PROTO_FILES)

build: proto
	GO111MODULE=on go build -o bin/emailai $(CMD)

build-extract: proto
	GO111MODULE=on go build -o bin/extract $(EXTRACT)

extract: build-extract
	./bin/extract

test: proto
	GO111MODULE=on go test ./...

race: proto
	CGO_ENABLED=1 go test -race -count=1 -timeout=5m -p 4 -parallel 8 ./...

lint:
	golangci-lint run --timeout=5m

tidy:
	go mod tidy

docker:
	docker build -t $(APP):local .

docker-run:
	docker run --rm -e TZ=UTC $(APP):local
