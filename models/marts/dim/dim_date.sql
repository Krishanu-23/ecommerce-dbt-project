{{config(materialized='table')}}
with date_series as (
    select
        generate_series('2023-01-01'::date, '2025-12-31'::date, interval '1 day') ::date 
        as date_day
)
select
    date_day,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(DOW from date_day) as day_of_week,
    extract(week from date_day) as week_of_year,
    case when extract(DOW from date_day) in (0, 6) then True else False end as is_weekend
from date_series