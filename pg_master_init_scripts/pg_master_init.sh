#!/bin/bash

cat /docker-entrypoint-initdb.d/custom_pg_hba.conf > /var/lib/postgresql/data/pg_hba.conf
cat /docker-entrypoint-initdb.d/master_postgresql.conf > /var/lib/postgresql/data/postgresql.conf