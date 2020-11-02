
all: build

TAG?=6bd516eacd6ee-10
FLAGS=
ENVVAR=
GOOS?=darwin
REGISTRY?=686244538589.dkr.ecr.us-east-2.amazonaws.com
BASEIMAGE?=alpine:3.9
include $(ENV_FILE)
export

build: clean
	$(ENVVAR) GOOS=$(GOOS) go build -o go-junit-report

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