with
lines as (
    select *
    from {{ ref('stg_richtree__lines') }}
),

orders as (
    select *
    from {{ ref('stg_richtree__orders') }}
),

products as (
    select *
    from {{ ref('stg_richtree__products') }}
),

build as (
    select
        orders.is_refunded,
        lines.line_item_id,
        lines.line_quantity,
        lines.line_quantity * products.unit_price as line_revenue,
        orders.order_created_at,
        orders.order_id,
        orders.order_refunded_at,
        products.product_category,
        products.product_id,
        products.product_name,
        products.unit_cost,
        products.unit_price,
        products.vendor_id
    from lines
    left join orders
        on lines.order_id = orders.order_id
    left join products
        on lines.product_id = products.product_id
)

select *
from build
