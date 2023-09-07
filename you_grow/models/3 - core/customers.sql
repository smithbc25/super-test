with customers as (
    select *
    from {{ ref('stg_richtree__customers') }}
),

build as (
    select
        country,
        customer_created_at,
        customer_id,
        customer_name,
        email,
        gender,
        state
    from customers
)

select *
from build
