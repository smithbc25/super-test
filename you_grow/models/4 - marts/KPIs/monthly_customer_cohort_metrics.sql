with order_lines as (
    select *
    from {{ ref('order_lines') }}
),

customer_details as (
    select *
    from {{ ref('customer_details') }}
),

cohort_monthly_metrics as (
    select
        customer_details.cohort,
        customer_details.gender,
        customer_details.state,
        customer_details.country,
        round(customer_details.first_order_value, -1)
            as first_order_value_bucket,
        round(customer_details.first_order_basket_size, -1)
            as first_order_basket_size_bucket,
        date_trunc('month', order_lines.order_created_at) as fiscal_month,
        count(distinct order_lines.customer_id)
            over (
                partition by
                    customer_details.cohort,
                    customer_details.gender,
                    customer_details.state,
                    customer_details.country,
                    first_order_value_bucket,
                    first_order_basket_size_bucket
            )
            as cohort_size,
        count(distinct order_lines.customer_id)
        / cohort_size as customer_retention_rate,
        sum(order_lines.line_revenue) as gross_merchandise_value
    from order_lines
    left join customer_details
        on order_lines.customer_id = customer_details.customer_id
    group by 1, 2, 3, 4, 5, 6, 7
)

select *
from cohort_monthly_metrics
