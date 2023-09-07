with source as (
    select *
    from {{ source('richtree', 'customer_data') }}
),

stage as (
    select
        country,
        created_at as customer_created_at,
        id as customer_id,
        name as customer_name,
        email,
        gender,
        state
    from source
)

select *
from stage
