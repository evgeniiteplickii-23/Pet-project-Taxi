#!/bin/bash
echo "Waiting for DBT marts to be ready..."
until psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/taxi_db -c "SELECT 1 FROM dwh_marts.mart_operations LIMIT 1" 2>/dev/null; do
    echo "Marts not ready yet, waiting 10 seconds..."
    sleep 10
done
echo "Marts ready, loading to ClickHouse..."
python load_to_clickhouse.py