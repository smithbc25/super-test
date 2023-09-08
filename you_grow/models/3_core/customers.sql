with customers as (
    select *
    from {{ ref('stg_richtree__customers') }}
),

first_order as (
    select *
    from {{ ref('int_richtree__customer__first_order_cohort') }}
),

life_time as (
    select *
    from {{ ref('int_richtree__customer__lifetime') }}
),

build as (
    select
        first_order.cohort,
        customers.country,
        customers.customer_created_at,
        customers.customer_id,
        customers.customer_name,
        customers.email,
        first_order.first_order_basket_size,
        first_order.first_order_product_categories,
        first_order.first_order_products,
        first_order.first_order_timestamp,
        first_order.first_order_value,
        customers.gender,
        life_time.lifetime_value,
        life_time.lifetime_orders,
        life_time.lifetime_product_categories,
        life_time.lifetime_products,
        customers.state
    from customers
    left join first_order
        on customers.customer_id = first_order.customer_id
    left join life_time
        on customers.customer_id = life_time.customer_id
)

select *
from build
