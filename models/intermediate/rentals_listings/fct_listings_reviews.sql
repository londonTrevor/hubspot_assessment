with reviews as (
  select * from {{ ref('stg_rentals_generated_reviews') }}
),

listings as (
  select * from {{ ref('dim_listings_properties') }}
),

final as (
  select 
    reviews.listing_id,
    reviews.generated_reviews_id,
    reviews.review_date,
    reviews.review_score,
    listings.first_review,
    listings.last_review,
    row_number() over (
      partition by reviews.listing_id order by reviews.review_date
    ) as listing_reviews_ordered
  from reviews
  left join listings 
    on reviews.listing_id = listings.listing_id
    and reviews.review_date between listings.first_review and listings.last_review
)

select * from final
