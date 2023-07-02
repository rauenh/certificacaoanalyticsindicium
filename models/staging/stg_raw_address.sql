with
    address as (
        select
            addressid
            , city
            , stateprovinceid
            , rowguid
            , spatiallocation
            from {{source('raw', 'address')}}
    )
select *
from address

	
