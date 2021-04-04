# Postgres Master-Slave Replication 

A simple setup of two dockers acting in master-slave replication.

### References

[Medium - postgres-12-setup-realtime-replication-between-two-databases](https://masubelele.medium.com/postgresql-12-setup-real-time-replication-between-two-databases-e23663cfc4eb)

[GitHub - codesenju - PostgreSQL Replication](https://github.com/codesenju/postgresql-replication)

[Medium - PostgreSQL Replication with Docker](https://medium.com/swlh/postgresql-replication-with-docker-c6a904becf77)

---

## Making it work


### **Step 0**: Save the default postgres config

    docker run -i --rm postgres:12.5 cat /usr/share/postgresql/postgresql.conf.sample > default-postgres.conf

### **Step 1**: Create a Docker Network

    docker network create pg_replicate

### **Step 2**: Start Master DB

    ./manage_master.sh --start

### **Step 3**: Check if correct config is loaded

    docker exec -ti pg_master bash -c "psql -U postgres -c 'SHOW hba_file;'"

    docker exec -ti pg_master bash -c "psql -U postgres -c 'SHOW wal_level;'"

    docker exec -ti pg_master bash -c "psql -U postgres -c 'SHOW hot_standby;'"

    docker exec -ti pg_master bash -c "psql -U postgres -c 'SHOW max_wal_senders;'"

    docker exec -ti pg_master bash -c "psql -U postgres -c 'SHOW promote_trigger_file;'"

### **Step 4**: Take pg_basebackup and copy to current directory

    docker exec -ti pg_master bash -c 'pg_basebackup -h pg_master -U replicator -p 5432 -D /tmp/slave-data -Fp -Xs -P -Rv'

    docker cp pg_master:/tmp/slave-data /$PWD/

### **Step 5**: Run Slave DB

    ./manage_slave.sh --start

### **Step 6**: Check Health

    docker exec -ti pg_master psql -U postgres -c 'SELECT * FROM pg_stat_replication;'


## Testing if this works

    docker exec -ti pg_master bash -c "psql -U postgres -c 'create database ricky;'"

    docker exec -ti pg_master bash -c "psql -U postgres -c '\list'"

    docker exec -ti pg_slave bash -c "psql -U postgres -c '\list'"