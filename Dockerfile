FROM golang:1.13-alpine as build
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -a -ldflags="-w -s" -o grpc-json-proxy
RUN echo "grpc-json-proxy:x:100:101:/" > passwd

FROM scratch
COPY --from=build /app/passwd /etc/passwd
COPY --from=build --chown=100:101 /app/grpc-json-proxy .
USER grpc-json-proxy
ENTRYPOINT ["./grpc-json-proxy"]