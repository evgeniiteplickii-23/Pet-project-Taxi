with source as (
    select distinct
        date_trunc('hour', tpep_pickup_datetime) as full_date
    from staging.yellow_trips
)

select
    row_number() over (order by full_date) as date_id,
    full_date,
    extract(year from full_date)::integer as year,
    extract(month from full_date)::integer as month,
    to_char(full_date, 'Month') as month_name,
    extract(day from full_date)::integer as day,
    extract(dow from full_date)::integer as day_of_week,
    to_char(full_date, 'Day') as day_name,
    extract(hour from full_date)::integer as hour,
    case when extract(dow from full_date) in (0, 6) then true else false end as is_weekend
from source