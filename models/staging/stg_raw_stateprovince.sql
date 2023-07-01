with
    stateprovince as (
        select
            stateprovinceid
            , name as name_state
            , countryregioncode
            from {{source('raw', 'stateprovince')}}
    )
select *
from stateprovince