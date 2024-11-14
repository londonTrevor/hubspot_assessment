with calendar_listings as (
  select * from {{ ref('stg_rentals_calendar') }}
),

days_since_last as (
  select 
    listing_id,
    reservation_id,
    date as day_date,
    is_available,
    datediff(
      'day', lag(day_date) over (partition by listing_id order by day_date), day_date
    ) as days_since_last
  from calendar_listings
  where is_available = true 
),

days_spanned_groupings as (
  select
    listing_id,
    reservation_id,
    day_date,
    is_available,
    sum(
      case 
        when days_since_last > 1 or days_since_last is null then 1 else 0 end
      ) over (
        partition by listing_id order by day_date
    ) as span_group_id
  from days_since_last
),

span_groupings_lengths as (
  select
    listing_id,
    span_group_id,
    min(day_date) as span_start_date,
    max(day_date) as span_end_date,
    datediff(
      'day', min(day_date), max(day_date)) + 1 
    as days_in_span_group
  from days_spanned_groupings
  group by 1,2
),

running_days_count as (
  select
    listing_id,
    day_date,
    span_group_id,
    row_number() over (
      partition by listing_id, span_group_id order by day_date
    ) as vacancy_day 
  from days_spanned_groupings
), 

final as (
  select 
    vacancies.listing_id,
    vacancies.day_date,
    vacancies.vacancy_day,
    lengths.span_start_date,
    lengths.span_end_date,
    lengths.days_in_span_group
  from running_days_count as vacancies 
  inner join span_groupings_lengths as lengths
    on vacancies.listing_id = lengths.listing_id
    and vacancies.span_group_id = lengths.span_group_id
)

select * from final
