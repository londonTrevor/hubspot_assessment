with source as (
  select * from {{ source('rentals_listings', 'listings') }}
),

final as (
  select
    id as listing_id,
    host_id,
    name as listing_name,
    host_name,
    host_since::date as host_since,
    host_location,
    host_verifications,
    neighborhood,
    property_type,
    room_type,
    accommodates,
    bathrooms_text,
    bedrooms,
    beds,
    amenities,
    price,
    number_of_reviews,
    first_review,
    last_review,
    review_scores_rating,
    from source as source
)

select * from final