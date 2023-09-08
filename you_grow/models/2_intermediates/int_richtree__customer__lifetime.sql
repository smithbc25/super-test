with customers as (
    select *
    from {{ ref('customers') }}
),

order_lines as (
    select *
    from {{ ref('order_lines') }}
    where is_refunded = false
),

life_time as (
    select
        customers.customer_id,
        COUNT(distinct order_lines.order_id) as lifetime_orders,
        COUNT(distinct order_lines.product_category)
            as lifetime_product_categories,
        COUNT(distinct order_lines.product_id) as lifetime_products,
        SUM(order_lines.line_revenue) as lifetime_value
    from customers
    left join order_lines
        on customers.customer_id = order_lines.customer_id
    group by customers.customer_id
)

select *
from life_time
