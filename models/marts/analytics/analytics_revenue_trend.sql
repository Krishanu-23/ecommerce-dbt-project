{{config(materialized='table')}}
select
    year,
    month,
    total_revenue,
    -- running total revenue for trend analysis
    sum(total_revenue) over (order by year, month) as cumulative_revenue,
    total_revenue - lag(total_revenue) over (order by year, month) as revenue_growth
    from {{ ref('mart_revenue_by_month') }}
order by year, month