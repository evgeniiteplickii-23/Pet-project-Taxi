CREATE DATABASE IF NOT EXISTS taxi_marts;

CREATE TABLE IF NOT EXISTS taxi_marts.mart_operations (
    pickup_date_id   Int32,
    hour             Int32,
    day_of_week      Int32,
    day_name         String,
    is_weekend       UInt8,
    pickup_borough   String,
    pickup_zone      String,
    dropoff_borough  String,
    dropoff_zone     String,
    trip_count       Int64,
    avg_trip_distance        Float64,
    avg_trip_duration_minutes Float64
) ENGINE = MergeTree()
ORDER BY (pickup_date_id, hour, pickup_borough);

CREATE TABLE IF NOT EXISTS taxi_marts.mart_finance (
    pickup_date_id  Int32,
    year            Int32,
    month           Int32,
    month_name      String,
    day             Int32,
    vendor_name     String,
    payment_name    String,
    trip_count      Int64,
    total_revenue   Float64,
    avg_fare        Float64,
    total_tips      Float64,
    total_tolls     Float64,
    total_congestion Float64
) ENGINE = MergeTree()
ORDER BY (pickup_date_id, vendor_name, payment_name);

CREATE TABLE IF NOT EXISTS taxi_marts.mart_service_quality (
    pickup_date_id          Int32,
    hour                    Int32,
    day_of_week             Int32,
    day_name                String,
    is_weekend              UInt8,
    pickup_borough          String,
    pickup_zone             String,
    payment_name            String,
    ratecode_name           String,
    passenger_count         Float64,
    trip_count              Int64,
    avg_tip_amount          Float64,
    avg_trip_distance       Float64,
    avg_trip_duration_minutes Float64,
    tip_rate                Float64
) ENGINE = MergeTree()
ORDER BY (pickup_date_id, hour, pickup_borough);