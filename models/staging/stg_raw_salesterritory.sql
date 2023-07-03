with
    salesterritory as (
        select
            territoryid
            , costlastyear
            , costytd
            , name as name_sales_territory
            , salesytd
            , saleslastyear
            , countryregioncode
        from {{ source('raw', 'salesterritory') }}
    )
select *
from salesterritory

