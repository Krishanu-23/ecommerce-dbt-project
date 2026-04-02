{{config(materialized='table')}}

select 
    year,
    month,
    sum(revenue) as total_revenue,
    sum(units_sold) as total_units_sold,
    count(distinct order_id) as total_orders
from {{ ref('mart_orders') }}as orders
group by year,month