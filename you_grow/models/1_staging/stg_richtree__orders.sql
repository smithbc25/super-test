with source as (
    select *
    from {{ source('richtree', 'order_data') }}
),

stage as (
    select
        currency as currency_type,
        customer_id,
        coalesce(order_refunded_at is not null, false) as is_refunded,
        created_at as order_created_at,
        id as order_id,
        refunded_at as order_refunded_at,
        total_price as order_revenue --renamed for clarity
    from source
)

select *
from stage
