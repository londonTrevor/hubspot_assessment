with listings as (
  select * from {{ ref('stg_rentals_listings') }}
),

final as (
  select
    host_id,
    host_name,
    host_since,
    host_verifications,
    host_location
  from listings
)

select * from final
