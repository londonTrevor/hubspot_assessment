{% test verify_vacancies(model, column_name) %}

with base as (
select *
from {{ model }}
where is_available = false 
and {{ column_name }} is not null 
)

select * from base 

{% endtest %}
