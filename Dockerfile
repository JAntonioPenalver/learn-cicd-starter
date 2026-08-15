FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compilamos el ejecutable
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copiamos el ejecutable y la carpeta static intacta dentro de /app/static
COPY --from=builder /app/notely /app/notely
COPY --from=builder /app/static /app/static

RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
