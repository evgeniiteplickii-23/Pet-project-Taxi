FROM python:3.11-slim
RUN apt-get update && apt-get install -y postgresql-client
WORKDIR /dbt
COPY . .
RUN pip install dbt-postgres
CMD ["bash", "entrypoint.sh"]