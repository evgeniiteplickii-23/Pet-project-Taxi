import pandas as pd
import sqlalchemy
import os
from clickhouse_driver import Client
import time

time.sleep(10)

# Подключение к PostgreSQL
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
pg_engine = sqlalchemy.create_engine(
    f"postgresql://{db_user}:{db_password}@postgres:5432/taxi_db"
)

# Подключение к ClickHouse
ch_client = Client(host='clickhouse', port=9000, user='admin', password='admin')

# Инициализация таблиц в ClickHouse
with open('init_clickhouse.sql', 'r') as f:
    sql = f.read()

for statement in sql.split(';'):
    statement = statement.strip()
    if statement:
        ch_client.execute(statement)

print("ClickHouse tables created")

# Загружаем каждую витрину
marts = ['mart_operations', 'mart_finance', 'mart_service_quality']

for mart in marts:
    print(f"Loading {mart}...")
    
    df = pd.read_sql(f"SELECT * FROM dwh_marts.{mart}", pg_engine)

    # Replace NaN in string columns with empty string
    str_cols = df.select_dtypes(include='object').columns
    df[str_cols] = df[str_cols].fillna('')

    data = df.values.tolist()
    columns = df.columns.tolist()
    
    ch_client.execute(
        f"INSERT INTO taxi_marts.{mart} ({', '.join(columns)}) VALUES",
        data
    )
    print(f"{mart} loaded: {len(df)} rows")

print("Done!")