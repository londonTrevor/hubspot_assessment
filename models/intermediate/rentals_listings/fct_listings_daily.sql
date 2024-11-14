with listings_calendar as (
  select * from {{ ref('stg_rentals_calendar') }}
),

empty_spans as (
  select * from {{ ref('int_availabilities_spans') }}
),

final as (
  select
    listings.listing_id,
    listings.reservation_id,
    listings.date as day_date, 
    listings.is_available,
    listings.minimum_nights,
    listings.maximum_nights,
    listings.price,
    spans.vacancy_day,
    spans.span_start_date as vacancy_start_date,
    spans.span_end_date as vacancy_end_date,
    spans.days_in_span_group as total_consecutive_vacancy_days
  from listings_calendar as listings
  left join empty_spans as spans 
    on listings.listing_id = spans.listing_id
    and listings.date = spans.day_date
)

select * from final
