with listings as (
  select * from {{ ref('stg_rentals_listings') }}
),

final as (
  select
    listing_id,
    host_id, 
    listing_name,
    neighborhood,
    property_type,
    room_type,
    accommodates,
    first_review,
    last_review,
    beds,
    bedrooms,
    regexp_substr(
      bathrooms_text, '[-+]?[0-9]*\.?[0-9]+', 1, 1
    ) as bathrooms_count,
    regexp_replace(
      bathrooms_text, '[0-9.]', ''
    ) as bathrooms_type,
    review_scores_rating as review_score_average,
    number_of_reviews
  from listings 
)

select * from final
