FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia el binario
COPY --from=builder /app/notely /app/notely

# Copia la carpeta static completa
COPY --from=builder /app/static /app/static

# Copia los archivos estáticos a la raíz de /app por si el FileServer apunta a "."
COPY --from=builder /app/static/* /app/

RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
