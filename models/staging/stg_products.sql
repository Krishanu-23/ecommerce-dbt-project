{{ config(materialized='table') }}

SELECT
product_id,
product_name,
category,
price,
updated_at
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY product_id
               ORDER BY updated_at DESC, ingestion_ts DESC
           ) AS rn
    FROM {{ source('raw', 'raw_products') }}
) t
WHERE rn = 1