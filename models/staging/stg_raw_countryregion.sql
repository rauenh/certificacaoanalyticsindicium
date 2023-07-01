with
    countryregion as (
        select
            countryregioncode
            , name as name_country
            from {{source('raw','countryregion')}}
    )
select *
from countryregion