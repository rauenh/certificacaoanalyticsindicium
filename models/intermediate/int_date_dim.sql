with

    salesorderheader as (
        select
            salesorderid
            , DATE_PART('day', soh.orderdate) as day
            , DATE_PART('month', soh.orderdate) as month
            , DATE_PART('year', soh.orderdate) as year
        from {{ ref('int_salesorderheader') }} 
        
)

select *
from salesorderheader