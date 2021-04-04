#!/bin/bash

help()
{
    echo "Invalid Arguments Supplied.."
    echo "############## Use one from below ##############"
    echo "'./run_db.sh --start' for starting Postgres server"
    echo "'./run_db.sh --stop' for stopping Postgres server"
    echo "'./run_db.sh --clean' for clean restart of Postgres server"
}

stop()
{
    echo "Stopping Postgres.."
    docker-compose -f docker-compose-slave.yml down
}

start()
{
    echo "Starting Postgres.."
    docker-compose -f docker-compose-slave.yml up -d
}

clean()
{
    echo "Cleaning Postgres data directory"
    rm -rf slave-data
    docker volume rm pg_replicate_ds_standby pg_replicate_scripts_standby
}

if [ "$1" == "--start" ]
then
    start
elif [ "$1" == "--stop" ]
then
    stop
elif [ "$1" == "--clean" ]
then
    stop
    clean
    start
else
    help
fi