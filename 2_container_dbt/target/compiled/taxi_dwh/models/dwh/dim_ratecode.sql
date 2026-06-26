with source as (
    select distinct
        "RatecodeID" as ratecode_id
    from staging.yellow_trips
)

select
    ratecode_id,
    case ratecode_id
        when 1 then 'Standard rate'
        when 2 then 'JFK'
        when 3 then 'Newark'
        when 4 then 'Nassau or Westchester'
        when 5 then 'Negotiated fare'
        when 6 then 'Group ride'
        else 'Unknown'
    end as ratecode_name
from source