#!/bin/bash

# Set locale settings
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Start PostgreSQL server
service postgresql start

# Read .env file and export variables
export $(grep -v '^#' .env | xargs -d '\n')

# Create user and grant privileges
su - postgres -c "psql -c 'CREATE USER \"$POSTGRES_USERNAME\" WITH ENCRYPTED PASSWORD '\''$POSTGRES_PASSWORD'\'';'"
su - postgres -c "psql -c 'ALTER USER \"$POSTGRES_USERNAME\" WITH SUPERUSER;'"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE einstein;
EOSQL