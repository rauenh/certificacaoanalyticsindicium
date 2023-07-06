with 
    salesorderheader as (
        select
            /*PK*/
            salesorderid
            , count(*) over (partition by salesorderid) as count_salesorderid
            /*FK*/
            , customerid		
            , salespersonid	
            , territoryid	
            , billtoaddressid	
            , shiptoaddressid	
            , creditcardid				
            , currencyrateid				
            , shipmethodid					
            /* Order information for customer*/
            , case 
                when status = 1 then 'In Process'
                when status = 2 then 'Approved'
                when status = 3 then 'Backordered'
                when status = 4 then 'Rejected'
                when status = 5 then 'Shipped'
                when status = 6 then 'Cancelled'
            end as status
            , purchaseordernumber
            , creditcardapprovalcode					
            , accountnumber					
            , onlineorderflag
	        , orderdate
            , shipdate	
            , duedate		
            /*Order pricing*/
            , subtotal
            , taxamt					
            , freight		
            , totaldue					
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
            , unitprice
            , unitpricediscount
        from {{ref('stg_raw_salesorderdetail')}}
    ),
    salesorderheadersalesreason as (
        select
            /* Primary Key & FK*/
            salesreasonid
            , salesorderid
        from {{ref('stg_raw_salesorderheadersalesreason')}}
    ),
  
    join_salesorderheader_salesorderdetail_salesreason as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderheader.salesorderid']) }} as int_sales_sk
            /*PK from salesorderheader, salesorderdetail ad salesorderheadersalesreason*/
            , salesorderheader.salesorderid
            , salesorderheader.count_salesorderid
            , salesorderheadersalesreason.salesreasonid
            /*FK from salesorderheader*/
            , salesorderheader.customerid
            , salesorderheader.shiptoaddressid
            , salesorderheader.territoryid
            , salesorderheader.creditcardid		
            , salesorderheader.salespersonid	
            , salesorderdetail.salesorderdetailid
            , salesorderdetail.productid
            , salesorderdetail.specialofferid	
            /*Order pricing*/
            , salesorderheader.status
            , salesorderheader.subtotal
            , salesorderheader.taxamt					
            , salesorderheader.freight		
            , salesorderheader.totaldue
            /* Create Business Rule*/
            , (salesorderheader.taxamt/ count(*) over (partition by salesorderheader.salesorderid)) as tax_per_order
            , (salesorderheader.freight/ count(*) over (partition by salesorderheader.salesorderid)) as freight_per_order
            , (salesorderheader.totaldue/ count(*) over (partition by salesorderheader.salesorderid)) as totaldue_per_order
	        , salesorderheader.orderdate	
            /* sales order detail */
            , salesorderdetail.orderqty
            , salesorderdetail.unitprice
            , salesorderdetail.unitpricediscount
            /* Create Business rule*/
            , (salesorderdetail.unitprice * salesorderdetail.orderqty) as gross_value
	        , ((salesorderdetail.unitprice * salesorderdetail.orderqty) * (1-salesorderdetail.unitpricediscount)) as net_value

        from salesorderdetail
        left join salesorderheader on (salesorderdetail.salesorderid = salesorderheader.salesorderid)
        left join salesorderheadersalesreason on (salesorderheader.salesorderid = salesorderheadersalesreason.salesorderid)
        order by salesorderheader.salesorderid asc
    ),
    join_int_sales_remove_duplicates as (
        select
            *,
            row_number() over (partition by salesorderid order by salesorderid) as remove_duplicates_index,
        from join_salesorderheader_salesorderdetail_salesreason
    )
select *
from join_int_sales_remove_duplicates
where remove_duplicates_index = 1 
