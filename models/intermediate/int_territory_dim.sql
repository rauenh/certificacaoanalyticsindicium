with
    salesorderheader as (
        select
            salesorderid
            , customerid
            , shiptoaddressid
            , territoryid
        from {{ ref('int_salesorderheader') }}
    ),
    address as (
        select
            addressid
            , city
            , stateprovinceid
        from {{ref('stg_raw_address')}}
    ),
    stateprovince as (
        select
            stateprovinceid
            , name as name_state
            , countryregioncode
            from {{ref('stg_raw_stateprovince')}}
    ),
    salesterritory as (
        select
            territoryid
            , costlastyear
            , costytd
            , name_sales_territory
            , salesytd
            , saleslastyear
            , countryregioncode
            , group
            from {{ref('stg_raw_salesterritory')}}
    ),
    countryregion as (
        select
            countryregioncode
            , name_country
            from {{source('stg_raw_countryregion')}}
    )
    join_territory as (
        select
            salesorderheader.salesorderid
            , salesorderheader.shiptoaddressid
            , salesorderheader.territoryid
            , salesorderheader.customerid
            , address.addressid
            , address.city
            , stateprovince.stateprovinceid
            , stateprovince.name_state
            , stateprovince.countryregioncode
            , countryregion.name_country
        from salesorderheader
        left join address on (salesorderheader.shiptoaddressid = address.addressid)
        left join salesterritory on ( salesorderheader.territoryid = salesterritory.territoryid)
        left join stateprovince on ( stateprovince.countryregioncode = countryregion.countryregioncode)
        order by salesorderheader.salesorderid asc
    )
select *
from join_territory