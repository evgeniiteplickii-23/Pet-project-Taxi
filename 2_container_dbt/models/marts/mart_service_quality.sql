with trips as (
    select * from {{ ref('fact_trips') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

zones as (
    select * from {{ ref('dim_zone') }}
),

payments as (
    select * from {{ ref('dim_payment') }}
),

ratecodes as (
    select * from {{ ref('dim_ratecode') }}
)

select
    t.pickup_date_id,
    d.hour,
    d.day_of_week,
    d.day_name,
    d.is_weekend,
    z.borough as pickup_borough,
    z.zone_name as pickup_zone,
    p.payment_name,
    r.ratecode_name,
    t.passenger_count,
    count(*) as trip_count,
    avg(t.tip_amount) as avg_tip_amount,
    avg(t.trip_distance) as avg_trip_distance,
    avg(t.trip_duration_minutes) as avg_trip_duration_minutes,
    avg(t.tip_amount / nullif(t.fare_amount, 0)) as tip_rate
from trips t
left join dates d on t.pickup_date_id = d.date_id
left join zones z on t.pickup_zone_id = z.zone_id
left join payments p on t.payment_id = p.payment_id
left join ratecodes r on t.ratecode_id = r.ratecode_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10