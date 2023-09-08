with source as (
    select *
    from {{ source('richtree', 'product_data') }}
),

stage as (
    select
        category as product_category, --renamed for clarity
        product as product_id,
        created_at as product_id_created_at,
        title as product_title,
        cost as unit_cost, --renamed for clarity
        price as unit_price,
        vendor as vendor_id
    from source
)

select *
from stage
