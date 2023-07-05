{{
    config(
        severety = 'error'
    )
}}

with    
    sales_2011 as (
        select sum(gross_value) as total_sales
        from {{ ref('fact_sales') }}
        where orderdate between '2011-01-01' and '2011-12-31'
    )

select total_sales
from sales_2011
where total_sales not between 12646000.00 and 12647000.00