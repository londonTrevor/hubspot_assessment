{% macro rentals_mac() %}

{% set query %}
select 
  distinct amenity_name,
  count(*)
from {{ ref('dim_listings_amenities') }}
group by 1
order by 2 desc 
limit 10
{% endset %}

{% set results = run_query(query) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}