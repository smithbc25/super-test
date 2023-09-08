with customers as (
    select *
    from {{ ref('customers') }}
),

order_lines as (
    select *
    from {{ ref('order_lines') }}
    where is_refunded = false
),

first_order as (
    select
        DATE_TRUNC('month', order_lines.order_created_at) as cohort,
        customers.customer_id,
        SUM(order_lines.line_quantity) as first_order_basket_size,
        COUNT(distinct order_lines.product_category)
            as first_order_product_categories,
        COUNT(distinct order_lines.product_id) as first_order_products,
        order_lines.order_created_at as first_order_timestamp,
        SUM(order_lines.line_revenue) as first_order_value
    from customers
    left join order_lines
        on customers.customer_id = order_lines.customer_id
    group by cohort, customers.customer_id, first_order_timestamp
    qualify
        RANK()
            over (
                partition by customers.customer_id
                order by first_order_timestamp
            )
        = 1
)

select *
from first_order
