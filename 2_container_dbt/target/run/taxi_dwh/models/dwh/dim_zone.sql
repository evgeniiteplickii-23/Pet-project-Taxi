
  
    

  create  table "taxi_db"."dwh_dwh"."dim_zone__dbt_tmp"
  
  
    as
  
  (
    with source as (
    select
        "LocationID" as zone_id,
        "Borough" as borough,
        "Zone" as zone_name,
        service_zone
    from staging.taxi_zones
)

select * from source
  );
  