with order_lines as (
    select *
    from {{ ref('order_lines') }}
    where is_refunded = false
),

customers as (
    select *
    from {{ ref('customers') }}
),

monthly_metrics_sliced as (
    select
        order_lines.order_year,
        order_lines.order_month,
--dimensions 
-- PICK WHICHEVER DIMENSIONS DESIRED AND UPDATE GROUP BY AS NECESSARY --
        order_lines.product_category,
        --order_lines.product_id,
        --order_lines.product_name,
        --customers.customer_id,
        customers.customer_name,
        --customers.country,
        --customers.gender,
        customers.state,
        --gmv
        sum(order_lines.line_revenue) as gross_merchandise_value,
        sum(order_lines.line_revenue)
        / count(distinct order_lines.order_id) as average_order_value,
        sum(order_lines.quantity)
        / count(distinct order_lines.order_id) as average_basket_size,
        count(distinct order_lines.customer_id) as active_customers
    from order_lines
    left join customers
        on order_lines.customer_id = customers.customer_id
-- UPDATE GROUP BY TO MATCH NUMBER OF CHOSEN DIMENSIONS --
    group by 1, 2, 3, 4, 5
)

select *
from monthly_metrics_sliced
