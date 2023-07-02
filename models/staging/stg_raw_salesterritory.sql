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
            , group
            from {{source('raw', 'salesterritory')}}
    )
select *
from salesterritory

