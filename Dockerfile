FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY static /app/static
COPY notely /app/notely

RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
