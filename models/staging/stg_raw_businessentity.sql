with
    businessentity as (
        select
            businessentityid
            , cast(modifieddate as datetime) as modifieddate
            , rowguid
            from {{source('raw', 'businessentity')}}
    )
select *
from businessentity
