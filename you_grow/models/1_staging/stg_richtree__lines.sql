with source as (
    select *
    from {{ source('richtree', 'order_line_data') }}
),

stage as (
    select
        id as line_item_id,
        quantity as line_quantity,
        total_price as line_revenue, --renamed for clarity
        order_id,
        product_id
    from source
)

select *
from stage
