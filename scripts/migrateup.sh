#!/bin/bash

# Si DATABASE_URL no está definida, intenta usar DB_URL
if [ -z "$DATABASE_URL" ]; then
  DATABASE_URL="$DB_URL"
fi

# Si aún no hay URL, lanza error
if [ -z "$DATABASE_URL" ]; then
  echo "Error: DATABASE_URL is not set"
  exit 1
fi

cd sql/schema || exit 1
goose turso "$DATABASE_URL" up
