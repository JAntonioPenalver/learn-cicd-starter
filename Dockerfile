FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia los archivos estáticos y el binario
COPY static /app/static
COPY notely /app/notely

# Otorga permisos de ejecución al binario de Go
RUN chmod +x /app/notely

ENV PORT=8080

CMD ["/app/notely"]
