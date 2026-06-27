FROM python:3.11-slim
RUN apt-get update && apt-get install -y postgresql-client
WORKDIR /app
COPY . .
RUN pip install pandas sqlalchemy psycopg2-binary clickhouse-driver
CMD ["bash", "entrypoint.sh"]