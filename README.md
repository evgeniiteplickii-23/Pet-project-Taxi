# NYC Yellow Taxi Data Pipeline

End-to-end data pipeline built with Docker, PostgreSQL, dbt, ClickHouse, and Tableau Public.

## Architecture

```
NYC TLC Parquet → PostgreSQL (Staging + DWH) → ClickHouse (Data Marts) → Tableau Public
```

| Step | Tool | Description |
|------|------|-------------|
| Extraction | Python + Pandas | Load Parquet file into PostgreSQL staging |
| Transformation | dbt | Build Star Schema DWH and Data Marts |
| Analytics Store | ClickHouse | Columnar DB for fast analytical queries |
| Export | Python | Export Data Marts to CSV |
| Visualization | Tableau Public | Interactive dashboards |

## Data

Source: [NYC TLC Yellow Taxi Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) — January 2026, 100k rows sample.

## Data Model

### DWH (Star Schema)
- `fact_trips` — trip facts
- `dim_date` — date and time dimensions
- `dim_zone` — pickup/dropoff zones (NYC boroughs)
- `dim_vendor` — taxi vendors
- `dim_payment` — payment types
- `dim_ratecode` — rate codes

### Data Marts
- `mart_operations` — trip volume by zone, hour, day of week
- `mart_finance` — revenue, fares, tips by vendor and payment type
- `mart_service_quality` — tip rate, passenger count, trip distance by zone

## How to Run

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- 4GB RAM available
- [Tableau Public](https://public.tableau.com/en-us/s/download) (free) — to explore dashboards locally

### 1. Clone the repository

```bash
git clone https://github.com/evgeniiteplickii-23/Pet-project-Taxi.git
cd Pet-project-Taxi
```

### 2. Download the source data

Download the NYC Yellow Taxi trip file for January 2026 from the [NYC TLC website](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) and place it into the `data/` folder:

```
data/yellow_tripdata_2026-01.parquet
```

### 3. Run the pipeline

```bash
docker-compose up --build
```

The pipeline runs automatically in sequence:
1. PostgreSQL initializes schemas
2. Python extracts Parquet data into staging
3. dbt builds DWH tables and mart views
4. Python loads marts into ClickHouse
5. Python exports marts to CSV files in `data/tableau/`

Wait until all containers finish — takes ~3-5 minutes.

### 4. Explore the data in Tableau

Open Tableau Public → **Connect to Data** → **Text file** → select any CSV from `data/tableau/`:

| File | Contents |
|------|----------|
| `mart_operations.csv` | Trip volume by zone, hour, day of week |
| `mart_finance.csv` | Revenue, fares, tips by vendor and payment type |
| `mart_service_quality.csv` | Tip rate, distance, passenger count by zone |

Or view the published dashboard directly: [Taxi Operations Analysis →](https://public.tableau.com/views/mart_operations/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### Verify ClickHouse data (optional)

Open `http://localhost:8123/play` (user: `admin`, password: `admin`):

```sql
SELECT * FROM taxi_marts.mart_operations LIMIT 10;
```

## Project Structure

```
├── 1_container_extraction/    # Python: Parquet → PostgreSQL
├── 2_container_dbt/           # dbt: Staging → DWH → Marts
├── 3_container_python2clickhouse/  # Python: PostgreSQL → ClickHouse
├── 4_container_python2tableau/     # Python: ClickHouse → CSV
├── data/
│   ├── tableau/               # Exported CSV files for Tableau
│   └── yellow_tripdata_2026-01.parquet
└── docker-compose.yml
```

## Tech Stack

- **Python** — data extraction and loading
- **PostgreSQL 16** — staging and DWH
- **dbt** — data transformation
- **ClickHouse 24.3** — analytical data store
- **Docker / Docker Compose** — containerization
- **Tableau Public** — visualization

## Dashboard

[Taxi Operations Analysis](https://public.tableau.com/views/mart_operations/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) — interactive dashboard on Tableau Public
