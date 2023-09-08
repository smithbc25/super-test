with order_lines as (
    select *
    from {{ ref('order_lines') }}
    where is_refunded = false
),

customers as (
    select *
    from {{ ref('customers') }}
),

cohort_monthly_metrics as (
    select
--dimensions
        customers.cohort,
        customers.country,
        customers.gender,
        customers.state,
        round(customers.first_order_value, -1)
            as first_order_value_bucket,
        round(customers.first_order_basket_size, -1)
            as first_order_basket_size_bucket,
        date_trunc('month', order_lines.order_created_at) as fiscal_month,
--metrics
        count(distinct order_lines.customer_id)
            over (
                partition by
                    customers.cohort,
                    customers.gender,
                    customers.state,
                    customers.country,
                    first_order_value_bucket,
                    first_order_basket_size_bucket
            )
            as cohort_size,
        count(distinct order_lines.customer_id) as active_customers,
        sum(order_lines.line_revenue) as gross_merchandise_value
    from order_lines
    left join customers
        on order_lines.customer_id = customers.customer_id
    group by 1, 2, 3, 4, 5, 6, 7
)

select *
from cohort_monthly_metrics
