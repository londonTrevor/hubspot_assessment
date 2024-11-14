with listings as (
  select * from {{ ref('stg_rentals_listings') }}
),

updates as (
  select * from {{ ref('stg_rentals_amenities_changelog') }}
),

amenities_keys as (
  select
    listings.listing_id,
    amenities.value::string as amenity_name
  from listings,
    lateral flatten (input => parse_json(amenities)) as amenities
),

amenities_cleaned as (
  select 
    listing_id,
    replace(
      REGEXP_REPLACE(amenity_name, '[’/,.-/:]', ''
      ), ' ', '_'
    ) as amenity_name
  from amenities_keys
),

get_update_date as (
  select 
    listing_id,
    max(change_at) as last_updated_at
  from updates
  group by 1
),

final as (
  select
    {{ dbt_utils.generate_surrogate_key(
      [
        'amenities.amenity_name',
        'amenities.listing_id'
      ]) 
    }} as listing_amenity_id,
    amenities.listing_id,
    lower(amenities.amenity_name) as amenity_name,
    updated.last_updated_at
  from amenities_cleaned as amenities
  left join get_update_date as updated 
    on amenities.listing_id = updated.listing_id
)

select * from final
