FROM golang:1.12 as build
WORKDIR /app
ADD . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o grpc-json-proxy
RUN echo "nobody:x:100:101:/" > passwd

FROM scratch
COPY --from=build /app/passwd /etc/passwd
COPY --from=build --chown=100:101 /app/grpc-json-proxy .
USER nobody
ENTRYPOINT ["./grpc-json-proxy"]
