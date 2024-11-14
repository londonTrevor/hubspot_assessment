with source as (
    select * from {{ source('rentals_listings', 'generated_reviews') }}
),

final as (
  select 
    id as generated_reviews_id,
    listing_id,
    review_score,
    review_date
  from source
)

select * from final
