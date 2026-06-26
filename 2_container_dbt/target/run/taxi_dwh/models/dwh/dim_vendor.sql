
  
    

  create  table "taxi_db"."dwh_dwh"."dim_vendor__dbt_tmp"
  
  
    as
  
  (
    with source as (
    select distinct
        "VendorID" as vendor_id
    from staging.yellow_trips
)

select
    vendor_id,
    case vendor_id
        when 1 then 'Creative Mobile Technologies'
        when 2 then 'Curb Mobility'
        when 6 then 'Myle Technologies Inc'
        when 7 then 'Helix'
        else 'Unknown'
    end as vendor_name
from source
  );
  