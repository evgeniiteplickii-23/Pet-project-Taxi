import pandas as pd
import sqlalchemy
import os

#ожидание исполнения этого скрипта: только после старта Postgres
import time
time.sleep(10)

#выгрузка данных в переменные
dataset = pd.read_parquet("/data/yellow_tripdata_2026-01.parquet")
dataset = dataset.sample(n=100000, random_state=42) #случайная выборка из 3.7 млн строк
taxi_zones = pd.read_csv("/data/taxi_zone_lookup.csv")

#установка соединения с Postgres. Чтобы не раскрывать логин и пароль - берем их из env (виртуального окружения)
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST", "postgres")
db_name = os.getenv("DB_NAME")

engine = sqlalchemy.create_engine(
    f"postgresql://{db_user}:{db_password}@{db_host}:5432/{db_name}"
)

#загрузка данных в Postgres
dataset.to_sql(name="yellow_trips", schema="staging", con=engine, if_exists="replace", chunksize=10000)
taxi_zones.to_sql(name="taxi_zones", schema="staging", con=engine, if_exists="replace")

#метка завершения загрузки для DBT: dbt стартует только после завершения загрузки данных в staging area
with engine.connect() as conn:
    conn.execute(sqlalchemy.text("CREATE TABLE IF NOT EXISTS staging.load_complete (loaded_at timestamp)"))
    conn.execute(sqlalchemy.text("INSERT INTO staging.load_complete VALUES (NOW())"))
    conn.commit()