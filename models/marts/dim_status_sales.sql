with
    salesorderheader as (
        select
            /*PK*/
            salesorderid
            /* Order information for customer*/
            , status
        from {{ref('stg_raw_salesorderheader')}}
    ),
    salesorderdetail as (
        select
            /* Primary Key*/
            salesorderid
            , salesorderdetailid					
            /*Foreign Key */
            , productid	
            , specialofferid					
            /* sales order detail */
            , carriertrackingnumber
            , orderqty
        from {{ref('stg_raw_salesorderdetail')}}
    )
    stateprovince as (
        select
            /* Primary Key */
            stateprovinceid
            /* FK*/
            , territoryid
            , stateprovincecode
            , countryregioncode
            , name_state_province
            , rowguid
        from {{ref('stg_raw_stateprovince')}}
    ),
    join_dim_territories as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderid', 'shiptoaddressid', 'customerid']) }} as dim_territories_sk
            , salesorderheader.salesorderid
            , salesorderheader.customerid		
            , salesorderheader.salespersonid	
            , salesorderheader.territoryid	
            , salesorderheader.shiptoaddressid
            , address.stateprovinceid
            , address.spatiallocation
            , stateprovince.countryregioncode
            , stateprovince.stateprovincecode
            , address.city
            , address.postalcode
            , stateprovince.name_state_province
            from salesorderheader
            left join address on (salesorderheader.shiptoaddressid = address.addressid)
                left join stateprovince on (address.stateprovinceid = stateprovince.stateprovinceid)
            order by salesorderheader.salesorderid asc
    )
    select *
    from join_dim_territories