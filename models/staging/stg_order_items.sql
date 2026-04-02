{{ config(materialized='table') }}

SELECT
order_item_id, 
order_id,
product_id,
quantity,
unit_price,
updated_at
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_item_id
               ORDER BY updated_at DESC, ingestion_ts DESC
           ) AS rn
    FROM {{ source('raw', 'raw_order_items') }}
) t
WHERE rn = 1