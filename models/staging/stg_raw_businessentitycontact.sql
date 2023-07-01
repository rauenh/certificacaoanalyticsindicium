with
    businessentitycontact as (
        select
            businessentityid
            , personid
            from {{source('raw','businessentitycontact')}}
    )
select *
from businessentitycontact