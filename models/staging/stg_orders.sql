{{ config(materialized='table') }}

SELECT
    order_id,
    user_id,
    order_date,
    updated_at
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_id
               ORDER BY updated_at DESC, ingestion_ts DESC
           ) AS rn
    FROM {{ source('raw', 'raw_orders') }}
) t
WHERE rn = 1