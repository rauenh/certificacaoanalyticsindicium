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
	        , cast(salesorderheader.orderdate as timestamp) as orderdate
            , shipdate	
            , duedate		
            /*Order pricing*/
            , subtotal
            , taxamt					
            , freight		
            , totaldue					
            /*Business Rule*/
            , (salesorderheader.taxamt/ count(*) over (partition by salesorderheader.salesorderid)) as tax_per_order
            , (salesorderheader.freight/ count(*) over (partition by salesorderheader.salesorderid)) as freight_per_order
            , (salesorderheader.totaldue/ count(*) over (partition by salesorderheader.salesorderid)) as totaldue_per_order

            /*Other informations*/      
            , rowguid					
            , modifieddate					
            , revisionnumber					
            , comment				
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesorderheader_hashid

        from {{source('raw', 'salesorderheader')}}
    )
select *
from salesorderheader