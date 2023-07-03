with 
    salesorderheader as (
        select
            salesorderid
            , orderdate
        from {{ ref('int_salesorderheader') }} 
)
select *
from salesorderheader
