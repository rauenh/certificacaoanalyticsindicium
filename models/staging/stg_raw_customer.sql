with
    customer as (
        select
            customerid
            , personid
            , territoryid
            from {{source('raw', 'customer')}}
        
    )
select *
from customer