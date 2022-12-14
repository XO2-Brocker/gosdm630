PWD := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
BIN := $(PWD)/bin
BUILD := GOBIN=$(BIN) go install ./...
GOPATH := $(shell go env GOPATH)

all: build

build: assets binaries

binaries:
	@echo "Building for host platform"
	$(BUILD)
	@echo "Created binaries:"
	@ls -1 bin

assets:
	@echo "Generating embedded assets"
	$(GOPATH)/pkg/mod/github.com/aprice/embed@v0.0.0-20181126214606-b9ceb1f6d22d/cmd/embed/embed http.go

release: test clean assets
	./build.sh

test:
	@echo "Running testsuite"
	env GO111MODULE=on go test

clean:
	rm -rf bin/ pkg/ *.zip

dep:
	@echo "Installing vendor dependencies"
	dep ensure

	@echo "Installing embed tool"
	env GO111MODULE=on go get github.com/aprice/embed/cmd/embed
	env GO111MODULE=on go install github.com/aprice/embed/cmd/embed

.PHONY: all build binaries assets release test clean dep
