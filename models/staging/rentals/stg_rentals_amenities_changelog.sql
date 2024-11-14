with source as (
  select * from {{ source('rentals_listings', 'amenities_changelog') }}
),

amenities_cleaned as (
  select
    listing_id,
    change_at,
    replace(
    replace(
        amenities, '\n', ''), ' "', '"'
    ) as amenities
  from source
),

final as (
  select
    listing_id,
    to_date(change_at) as change_at,
    amenities
  from amenities_cleaned
)

select * from final
