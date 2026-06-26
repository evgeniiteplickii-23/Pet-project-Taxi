#!/bin/bash
echo "Waiting for data in staging..."
until psql postgresql://$DB_USER:$DB_PASSWORD@postgres:5432/taxi_db -c "SELECT 1 FROM staging.load_complete" 2>/dev/null; do
    echo "No data yet, waiting 10 seconds..."
    sleep 10
done
echo "Data found, running dbt..."
dbt run