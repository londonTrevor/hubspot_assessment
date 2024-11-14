with source as (
    select * from {{ source('rentals_listings', 'calendar') }}
),

final as (
  select
    listing_id,
    date,
    try_to_boolean(
        case 
          when available = 't' then true
          when available = 'f' then false
          else null
          end
        ) as is_available,
    reservation_id,
    price,
    minimum_nights,
    maximum_nights
  from source
)

select * from final
