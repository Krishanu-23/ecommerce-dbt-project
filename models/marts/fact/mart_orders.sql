{{ config(materialized='table') }}

with base as (
    -- start from fact_order_items
    select
        order_item_id,
        order_id,
        product_id,
        user_id,
        order_date,
        quantity,
        unit_price,
        revenue
    from {{ ref('fact_order_items') }}
),
--join dim_users for descriptive attributes
users as (
    select
    b.*,
    u.signup_date,
    u.country
    from base b
    left join {{ ref('dim_users') }} u
    on b.user_id = u.user_id
),
--join dim_products for descriptive attributes
products as (
    select
    u.*,
    p.product_name,
    p.category
    from users u
    left join {{ ref('dim_products') }} p
    on u.product_id = p.product_id
),
--join dim_date for date attributes
enriched as (
    select
    p.*,
    d.year,
    d.month,
    d.day,
    d.day_of_week,
    d.week_of_year,
    d.is_weekend
    from products p
    left join {{ ref('dim_date') }} d
    on p.order_date = d.date_day
)
-- final select: compute metrics and select final columns
select 
    order_item_id,
    order_id,
    product_id,
    user_id,
    order_date,
    signup_date,
    country,
    product_name,
    category,
    year,
    month,
    day,
    day_of_week,
    week_of_year,
    is_weekend,
    quantity as units_sold,
    revenue,
    1 as order_item_count
from enriched