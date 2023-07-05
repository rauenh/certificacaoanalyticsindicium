with 
    salesorderheader as (
        select
            /*PK*/
            salesorderid
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
            , status
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
            , rowguid
            , modifieddate

        from {{ref('stg_raw_salesorderdetail')}}
    ),
    
    join_salesorderheader_salesorderdetail as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderheader.salesorderid', 'salesorderheader.purchaseordernumber', 'salesorderdetail.rowguid']) }} as int_sales_sk
            /*PK from salesorderheader*/
            , salesorderheader.salesorderid
            /*FK from salesorderheader*/
            , salesorderheader.customerid
            , salesorderheader.shiptoaddressid
            , salesorderheader.creditcardid				
            /*Order pricing*/
            , salesorderheader.subtotal
            , salesorderheader.taxamt					
            , salesorderheader.freight		
            , salesorderheader.totaldue
            /* Create Business Rule*/
            , (salesorderheader.taxamt/ count(*) over (partition by salesorderheader.salesorderid)) as tax_per_order
            , (salesorderheader.freight/ count(*) over (partition by salesorderheader.salesorderid)) as freight_per_order
            , (salesorderheader.totaldue/ count(*) over (partition by salesorderheader.salesorderid)) as totaldue_per_order
	        , salesorderheader.orderdate			
            /*Foreign Key from salesorderdetail */
            , salesorderdetail.productid
            , salesorderdetail.specialofferid					
            /* sales order detail */
            , salesorderdetail.orderqty
            , salesorderdetail.unitprice
            , salesorderdetail.unitpricediscount
            /* Create Business rule*/
            , (salesorderdetail.unitprice * salesorderdetail.orderqty) as gross_value
	        , ((salesorderdetail.unitprice * salesorderdetail.orderqty) * (1-salesorderdetail.unitpricediscount)) as net_value

        from salesorderheader
        left join salesorderdetail on (salesorderheader.salesorderid = salesorderdetail.salesorderid)
        order by salesorderheader.salesorderid asc
    ),
    join_int_sales_remove_duplicates as (
        select
            *,
            row_number() over (partition by salesorderid order by salesorderid) as remove_duplicates_index,
        from join_salesorderheader_salesorderdetail
    )
select *
from join_int_sales_remove_duplicates
where remove_duplicates_index = 1 
