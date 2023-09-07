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
        customers.customer_id,
        DATE_TRUNC('month', order_lines.order_created_at) as cohort,
        order_lines.order_created_at as first_order_timestamp,
        SUM(order_lines.line_revenue) as first_order_value,
        SUM(order_lines.line_quantity) as first_order_basket_size,
        COUNT(distinct order_lines.product_category)
            as first_order_product_categories,
        COUNT(distinct order_lines.product_id) as first_order_products
    from customers
    left join order_lines
        on customers.customer_id = order_lines.customer_id
    group by 1
    qualify
        RANK()
            over (
                partition by customers.customer_id
                order by first_order_timestamp
            )
        = 1
),

life_time as (
    select
        customers.customer_id,
        customers.gender,
        customers.state,
        customers.country,
        SUM(order_lines.line_revenue) as lifetime_value,
        COUNT(distinct order_lines.order_id) as lifetime_orders,
        COUNT(distinct order_lines.product_category)
            as lifetime_product_categories,
        COUNT(distinct order_lines.product_id) as lifetime_products
    from customers
    left join order_lines
        on customers.customer_id = order_lines.customer_id
    group by 1, 2, 3, 4
),

customer_detail as (
    select
        life_time.customer_id,
        life_time.gender,
        life_time.state,
        life_time.country,
        life_time.lifetime_value,
        life_time.lifetime_orders,
        life_time.lifetime_product_categories,
        life_time.lifetime_products,
        first_order.cohort,
        first_order.first_order_timestamp,
        first_order.first_order_value,
        first_order.first_order_basket_size,
        first_order.first_order_product_categories,
        first_order.first_order_products
    from life_time
    left join first_order
        on life_time.customer_id = first_order.customer_id
)

select *
from customer_detail
