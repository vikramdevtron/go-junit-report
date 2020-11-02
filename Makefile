#!make

all: build

TAG?=$(shell bash -c 'git log --pretty=format:'%h' -n 1')
FLAGS=
ENVVAR=
GOOS?=darwin
REGISTRY?=686244538589.dkr.ecr.us-east-2.amazonaws.com
BASEIMAGE?=alpine:3.9
#BUILD_NUMBER=$$(date +'%Y%m%d-%H%M%S')
BUILD_NUMBER := $(shell bash -c 'echo $$(date +'%Y%m%d-%H%M%S')')
export

build: clean wire
	$(ENVVAR) GOOS=$(GOOS) go build -o go-junit-report

wire:
	wire

clean:
	rm -f go-junit-report

run: build
	./go-junit-report

.PHONY: build
docker-build-image:  build
	 docker build -t go-junit-report:$(TAG) .

.PHONY: build, all, wire, clean, run, set-docker-build-env, docker-build-push, go-junit-report,
docker-build-push: docker-build-image
	docker tag go-junit-report:${TAG}  ${REGISTRY}/go-junit-report:${TAG}
	docker push ${REGISTRY}/go-junit-report:${TAG}




