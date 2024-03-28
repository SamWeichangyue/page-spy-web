FROM golang:1.20-buster AS backend
WORKDIR /app
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/. .
RUN go build -ldflags "-linkmode external -extldflags -static"  -o main .

FROM debian:bullseye-slim
WORKDIR /app
RUN apt-get install gcc libc6-dev
COPY --from=backend /app/main /app/main
CMD ["/app/main"]
