with
    salesorderheader as (
        select
            salesorderid
            , customerid
            , shiptoaddressid
            , territoryid
        from {{ ref('stg_raw_salesorderheader') }}
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
    countryregion as (
        select
            countryregioncode
            , name as name_country
            from {{ref('stg_raw_countryregion')}}
    ),
    customer as (
        select
            customerid
        from {{ref('stg_raw_customer')}}
    )
    join_territory as (
        select
            salesorderheader.salesorderid
            , customer.customerid
            , salesorderheader.customerid
            , salesorderheader.shiptoaddressid
            , salesorderheader.territoryid
            , address.addressid
            , address.stateprovinceid
            , address.city
            , stateprovince.stateprovinceid
            , stateprovince.name_state
            , stateprovince.countryregioncode
            , countryregion.countryregioncode
            , countryregion.name_country
        from salesorderheader
        left join customer on (salesorderheader.customerid = customer.customerid)
        left join address on (salesorderheader.shiptoaddressid = address.addressid)
        left join address on ( address.stateprovinceid = stateprovinceid.stateprovinceid)
        left join stateprovince on ( stateprovince.countryregioncode = countryregion.countryregioncode)
    )
select *
from join_territory