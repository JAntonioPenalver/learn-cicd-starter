FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY static /app/static
COPY notely /app/notely

# ESTA LÍNEA ES IMPRESCINDIBLE:
RUN chmod +x /app/notely

ENV PORT=8080

CMD ["/app/notely"]
