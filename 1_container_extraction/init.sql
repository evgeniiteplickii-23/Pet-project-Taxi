CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.yellow_trips (
    VendorID              INTEGER,
    tpep_pickup_datetime  TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count       FLOAT,
    trip_distance         FLOAT,
    RatecodeID            FLOAT,
    store_and_fwd_flag    VARCHAR(1),
    PULocationID          INTEGER,
    DOLocationID          INTEGER,
    payment_type          INTEGER,
    fare_amount           FLOAT,
    extra                 FLOAT,
    mta_tax               FLOAT,
    tip_amount            FLOAT,
    tolls_amount          FLOAT,
    improvement_surcharge FLOAT,
    total_amount          FLOAT,
    congestion_surcharge  FLOAT,
    Airport_fee           FLOAT,
    cbd_congestion_fee    FLOAT
);

CREATE TABLE IF NOT EXISTS staging.taxi_zones (
    LocationID    INTEGER,
    Borough       VARCHAR(50),
    Zone          VARCHAR(100),
    service_zone  VARCHAR(50)
);