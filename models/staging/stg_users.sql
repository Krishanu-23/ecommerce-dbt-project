{{ config(materialized='table') }}

SELECT
user_id,
signup_date,
country,
updated_at
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY updated_at DESC, ingestion_ts DESC
           ) AS rn
    FROM {{ source('raw', 'raw_users') }}
) t
WHERE rn = 1