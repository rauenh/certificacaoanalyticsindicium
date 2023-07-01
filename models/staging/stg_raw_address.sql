with
    address as (
        select
            addressid
            , city
            , stateprovinceid
            from {{source('raw', 'address')}}
    )
select *
from address