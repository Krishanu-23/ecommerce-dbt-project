{{ config(
    materialized='table'
) }}
select
    user_id,
    signup_date,
    country,
    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to
from {{ ref('users_snapshot') }}
where dbt_valid_to is Null