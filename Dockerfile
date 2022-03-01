FROM golang:1.17-alpine as builder-base
RUN apk add build-base

FROM builder-base as builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN go mod download
RUN go mod verify
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="-w -s" -o dca

FROM alpine AS release
COPY --from=builder /build/dca /usr/bin/dca
WORKDIR /
ENTRYPOINT [ "dca" ]

