with daily_listings as (
  select * from {{ ref('fct_listings_daily') }}
),

hosts as (
  select * from {{ ref('dim_hosts') }}
),

listings_properties as (
  select * from {{ ref('dim_listings_properties') }}
),

listings_amenities as (
  select * from {{ ref('dim_listings_amenities') }}
),

final as (
  select
    dl.listing_id,
    dl.reservation_id,
    h.host_id,
    dl.day_date,
    dl.is_available,
    dl.price,
    dl.minimum_nights,
    dl.maximum_nights,
    dl.vacancy_day,
    dl.total_consecutive_vacancy_days,
    h.host_name,
    h.host_location,
    h.host_since,
    pr.listing_name,
    pr.neighborhood,
    pr.property_type,
    pr.room_type,
    pr.accommodates,
    pr.first_review,
    pr.last_review,
    pr.beds,
    pr.bedrooms,
    pr.bathrooms_count,
    pr.bathrooms_type,
    pr.number_of_reviews,
    pr.review_score_average,
    iff(
      la.listing_id is not null, 1, 0
    ) as listing_has_air_conditioning
  from daily_listings as dl 
  left join listings_properties as pr
    on dl.listing_id = pr.listing_id 
  left join hosts as h
    on pr.host_id = h.host_id
  left join listings_amenities as la 
    on dl.listing_id = la.listing_id
    and la.amenity_name = 'air_conditioning'
)

select * from final
