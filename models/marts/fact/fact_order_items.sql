{{ config(
    materialized='incremental',
    unique_key='order_item_id'
) }}

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.user_id,
    o.order_date,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS revenue

FROM {{ ref('stg_order_items') }} oi
JOIN {{ ref('stg_orders') }} o
    ON oi.order_id = o.order_id

{% if is_incremental() %}

-- Only insert new primary keys (append-only logic)
WHERE oi.order_item_id NOT IN (
    SELECT order_item_id FROM {{ this }}
)

{% endif %}
-- DESIGN DECISION:
-- This fact table is IMMUTABLE (append-only)
-- We only insert new records based on primary key
-- No updates are performed
-- updated_at is NOT used here because:
--   - staging already provides latest snapshot
--   - fact does not track changes, only events