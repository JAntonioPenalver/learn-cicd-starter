#!/bin/bash

# Usar DATABASE_URL o DB_URL
URL="${DATABASE_URL:-$DB_URL}"

if [ -z "$URL" ]; then
  echo "Error: DATABASE_URL is not set"
  exit 1
fi

# Eliminar comillas dobles o simples que hayan quedado en la variable
CLEAN_URL=$(echo "$URL" | tr -d '"' | tr -d "'")

# Navegar a la carpeta donde están los archivos .sql
cd sql/schema || exit 1

# Ejecutar las migraciones
goose turso "$CLEAN_URL" up
