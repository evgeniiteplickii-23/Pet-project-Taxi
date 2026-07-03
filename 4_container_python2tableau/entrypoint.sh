#!/bin/bash
echo "Waiting for ClickHouse marts to be ready..."
until python -c "from clickhouse_driver import Client; c = Client(host='clickhouse', port=9000, user='admin', password='admin'); c.execute('SELECT 1 FROM taxi_marts.mart_operations LIMIT 1')" 2>/dev/null; do
    echo "Marts not ready yet, waiting 10 seconds..."
    sleep 10
done
echo "Marts ready, exporting to CSV..."
python export_to_csv.py
