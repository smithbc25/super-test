with source as (
    select *
    from {{ source('richtree', 'vendor_data') }}
),

stage as (
    select
        id as vendor_id,
        created_at as vendor_id_created_at,
        title as vendor_name
    from source
)

select *
from stage
