with trips as (
    select * from {{ ref('fact_trips') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

vendors as (
    select * from {{ ref('dim_vendor') }}
),

payments as (
    select * from {{ ref('dim_payment') }}
)

select
    t.pickup_date_id,
    d.year,
    d.month,
    d.month_name,
    d.day,
    v.vendor_name,
    p.payment_name,
    count(*) as trip_count,
    sum(t.total_amount) as total_revenue,
    avg(t.fare_amount) as avg_fare,
    sum(t.tip_amount) as total_tips,
    sum(t.tolls_amount) as total_tolls,
    sum(t.congestion_surcharge) as total_congestion
from trips t
left join dates d on t.pickup_date_id = d.date_id
left join vendors v on t.vendor_id = v.vendor_id
left join payments p on t.payment_id = p.payment_id
group by 1, 2, 3, 4, 5, 6, 7