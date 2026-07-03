FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install pandas clickhouse-driver
CMD ["bash", "entrypoint.sh"]
