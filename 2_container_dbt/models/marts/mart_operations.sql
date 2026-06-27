with trips as (
    select * from {{ ref('fact_trips') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

zones as (
    select * from {{ ref('dim_zone') }}
)

select
    t.pickup_date_id,
    d.hour,
    d.day_of_week,
    d.day_name,
    d.is_weekend,
    z_pickup.borough as pickup_borough,
    z_pickup.zone_name as pickup_zone,
    z_dropoff.borough as dropoff_borough,
    z_dropoff.zone_name as dropoff_zone,
    count(*) as trip_count,
    avg(t.trip_distance) as avg_trip_distance,
    avg(t.trip_duration_minutes) as avg_trip_duration_minutes
from trips t
left join dates d on t.pickup_date_id = d.date_id
left join zones z_pickup on t.pickup_zone_id = z_pickup.zone_id
left join zones z_dropoff on t.dropoff_zone_id = z_dropoff.zone_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9