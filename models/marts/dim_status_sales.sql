with
    salesorderheader as (
        select
            /*PK*/
            salesorderid
            /* FK*/
            , shiptoaddressid
            , creditcardid
            , customerid
            , salespersonid
            , territoryid
            /* Order information for customer*/
            , status
            , rowguid
            , modifieddate
        from {{ref('stg_raw_salesorderheader')}}
    ),
    join_dim_status_sales as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderid', 'rowguid', 'modifieddate']) }} as dim_status_sales_sk
            , salesorderheader.salesorderid
            , salesorderheader.customerid		
            , salesorderheader.salespersonid	
            , salesorderheader.territoryid	
            , salesorderheader.shiptoaddressid
            , case 
                when salesorderheader.status = 1 then 'In Process'
                when salesorderheader.status = 2 then 'Approved'
                when salesorderheader.status = 3 then 'Backordered'
                when salesorderheader.status = 4 then 'Rejected'
                when salesorderheader.status = 5 then 'Shipped'
                when salesorderheader.status = 6 then 'Cancelled'
            end as status
        from salesorderheader
        order by salesorderheader.salesorderid asc
    )
    select *
    from join_dim_status_sales