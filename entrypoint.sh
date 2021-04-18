#!/bin/bash

# Wait for Postgres to become available.
echo "Waiting for ${DATABASE_HOST} to start..."
while ! pg_isready -h ${DATABASE_HOST} -p 5432 > /dev/null 2> /dev/null; do
  >&2 echo "${DATABASE_HOST} is unavailable - sleeping"
  sleep 1
done
echo "${DATABASE_HOST} is up"

mix ecto.setup

DEBUG=0 mix phx.server