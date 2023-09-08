with order_lines as (
    select *
    from {{ ref('order_lines') }}
    where is_refunded = false
),

monthly_metric_build as (
    select
        DATE_TRUNC('month', order_lines.order_created_at) as fiscal_month,
        COUNT(distinct order_lines.customer_id) as active_customers,
        SUM(order_lines.quantity)
        / COUNT(distinct order_lines.order_id) as average_basket_size,
        SUM(order_lines.line_revenue)
        / COUNT(distinct order_lines.order_id) as average_order_value,
        SUM(order_lines.line_revenue) as gross_merchandise_value
    from order_lines
    group by 1
    order by 1 desc
)

select *
from monthly_metric_build
