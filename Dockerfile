# build stage
FROM golang:latest AS build-env
RUN go get github.com/golang/dep/cmd/dep
WORKDIR /go/src/github.com/GoogleCloudPlatform/k8s-node-termination-handler
RUN git clone https://github.com/GoogleCloudPlatform/k8s-node-termination-handler.git
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -tags netgo -o node-termination-handler

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/GoogleCloudPlatform/k8s-node-termination-handler/node-termination-handler /app/
ENTRYPOINT ./node-termination-handler