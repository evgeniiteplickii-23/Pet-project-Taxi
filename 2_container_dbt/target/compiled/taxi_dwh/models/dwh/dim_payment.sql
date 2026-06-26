with source as (
    select distinct
        payment_type as payment_id
    from staging.yellow_trips
)

select
    payment_id,
    case payment_id
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
        else 'Unknown'
    end as payment_name
from source