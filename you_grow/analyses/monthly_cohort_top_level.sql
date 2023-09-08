with cohort_metrics as (
    select *
    from {{ ref('month_customer_cohort_metrics') }}
),

top_level as (
    select
        cohort,
        fiscal_month,
        max(cohort_size) as cohort_size,
        sum(active_customers) as active_customers_top,
        sum(gross_merchandise_value) as gross_merchandise_value_top,
        sum(active_customers) / max(cohort_size) as customer_retention_rate,
        sum(gross_merchandise_value)
            over (partition by cohort order by fiscal_month asc)
            as cohort_lifetime_value
    from cohort_metrics
    group by 1, 2
)

select *
from top_level
