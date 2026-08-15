FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia la carpeta de archivos estáticos y el binario
COPY static /app/static
COPY notely /app/notely

# LE DA PERMISOS DE EJECUCIÓN AL BINARIO (Crucial)
RUN chmod +x /app/notely

ENV PORT=8080

CMD ["/app/notely"]
