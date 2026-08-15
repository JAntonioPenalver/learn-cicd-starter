#!/bin/bash
URL="${DATABASE_URL:-$DB_URL}"
if [ -z "$URL" ]; then
  echo "Error: DATABASE_URL is not set"
  exit 1
fi
CLEAN_URL=$(echo "$URL" | tr -d '"' | tr -d "'")
cd sql/schema || exit 1
goose turso "$CLEAN_URL" up
