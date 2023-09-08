with vendors as (
    select *
    from {{ ref('stg_richtree__vendors') }}
),

build as (
    select
        vendor_id,
        vendor_id_created_at,
        vendor_name
    from vendors
)

select *
from build
