
  
    

  create  table "taxi_db"."dwh_dwh"."fact_trips__dbt_tmp"
  
  
    as
  
  (
    with trips as (
    select * from staging.yellow_trips
),

dates as (
    select * from "taxi_db"."dwh_dwh"."dim_date"
),

zones as (
    select * from "taxi_db"."dwh_dwh"."dim_zone"
)

select
    row_number() over () as trip_id,
    d_pickup.date_id as pickup_date_id,
    d_dropoff.date_id as dropoff_date_id,
    z_pickup.zone_id as pickup_zone_id,
    z_dropoff.zone_id as dropoff_zone_id,
    t."VendorID" as vendor_id,
    t.payment_type as payment_id,
    t."RatecodeID" as ratecode_id,
    t.passenger_count,
    t.trip_distance,
    extract(epoch from (t.tpep_dropoff_datetime - t.tpep_pickup_datetime)) / 60 as trip_duration_minutes,
    t.fare_amount,
    t.tip_amount,
    t.tolls_amount,
    t.total_amount,
    t.congestion_surcharge
from trips t
left join dates d_pickup
    on date_trunc('hour', t.tpep_pickup_datetime) = d_pickup.full_date
left join dates d_dropoff
    on date_trunc('hour', t.tpep_dropoff_datetime) = d_dropoff.full_date
left join zones z_pickup
    on t."PULocationID" = z_pickup.zone_id
left join zones z_dropoff
    on t."DOLocationID" = z_dropoff.zone_id
  );
  