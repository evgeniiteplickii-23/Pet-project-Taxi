import pandas as pd
import sqlalchemy
import os

#ожидание исполнения этого скрипта: только после старта Postgres
import time
time.sleep(10)

#выгрузка данных в переменные
dataset = pd.read_parquet("/data/yellow_tripdata_2026-01.parquet")
dataset = dataset.head(100000) #читаем только 100к строк, а не 3.7 млн из файла
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