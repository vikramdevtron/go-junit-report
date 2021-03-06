
####--------------
FROM golang:1.12.6-alpine3.9  AS build-env
RUN echo $GOPATH

RUN apk add --no-cache git gcc musl-dev
RUN apk add --update make

WORKDIR /go/src/github.com/vikramdevtron/go-junit-report
ADD . /go/src/github.com/vikramdevtron/go-junit-report/
COPY . .
RUN pwd
RUN echo $GOPATH
# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/go-junit-report


FROM docker:18.09.7-dind
# All these steps will be cached
#RUN apk add --no-cache ca-certificates
RUN apk update
RUN apk add --no-cache --virtual .build-deps
RUN apk add bash
RUN apk add make && apk add curl && apk add openssh
RUN apk add git
RUN apk add zip
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*
COPY --from=docker/compose:latest /usr/local/bin/docker-compose /usr/bin/docker-compose

COPY --from=build-env /go/bin/go-junit-report .
ENTRYPOINT ["./go-junit-report"]