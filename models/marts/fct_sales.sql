with
    dim_client as (
        select *
        from {{ref('dim_client')}}
    ),
    dim_creditcard as (
        select *
        from {{ref('dim_creditcard')}}
    ),
    dim_date as (
        select *
        from {{ref('dim_date')}}
    ),
    dim_products as (
        select *
        from {{ref('dim_products')}}
    ),
    dim_salesreason as (
        select *
        from {{ref('dim_salesreason')}}
    ),
    dim_status_sales as (
        select *
        from {{ref('dim_status_sales')}}
    ),
    dim_territories as (
        select *
        from {{ref('dim_territories')}}
    ),
    salesorderheader_with_sk as (
        select
            /*PK*/
            salesorderheader.salesorderid
            /*FK*/
            , dim_client.dim_client_sk as dim_client_fk	
            , dim_territories.dim_territories_sk as dim_territories_fk	
            , dim_creditcard.dim_creditcard_sk as dim_creditcard_fk				
            , dim_status_sales.dim_status_sales_sk as dim_status_sales_fk
            /*Order pricing*/
            , salesorderheader.subtotal
            , salesorderheader.taxamt					
            , salesorderheader.freight		
            , salesorderheader.totaldue
            /*Business Rule*/
            , salesorderheader.taxamt/(count(salesorderheader.taxamt) over (partition by salesorderheader.salesorderid)) as tax_per_order
            , salesorderheader.freight/(count(salesorderheader.freight) over (partition by salesorderheader.salesorderid)) as freight_per_order
            , salesorderheader.totaldue/(count(salesorderheader.totaldue) over (partition by salesorderheader.salesorderid)) as totaldue_per_order
	        , cast(salesorderheader.orderdate as timestamp) as orderdate			

        from {{ref('stg_raw_salesorderheader')}} as salesorderheader
        left join dim_client on (salesorderheader.customerid = dim_client.customerid)
        left join dim_territories on (salesorderheader.territoryid = dim_territories.territoryid)
        left join dim_creditcard on (salesorderheader.creditcardid = dim_creditcard.creditcardid)
        left join dim_status_sales on (salesorderheader.salesorderid = dim_status_sales.salesorderid)
        order by salesorderheader.salesorderid asc

    ),
    salesorderdetail_with_sk as (
        select
            /* Primary Key*/
            salesorderdetail.salesorderid
            /*Foreign Key */
            , dim_products.dim_product_sk as dim_product_fk
            , salesorderdetail.specialofferid					
            /* sales order detail */
            , salesorderdetail.carriertrackingnumber
            , salesorderdetail.orderqty
            , salesorderdetail.unitprice
            , salesorderdetail.unitpricediscount
            /*Business Rule*/
            , (salesorderdetail.unitprice * salesorderdetail.orderqty) as gross_value
	        , (salesorderdetail.unitprice * salesorderdetail.orderqty) * (1-salesorderdetail.unitpricediscount) as net_value
        from {{ref('stg_raw_salesorderdetail')}} as salesorderdetail
        left join dim_products on (salesorderdetail.productid = dim_products.productid)
        order by salesorderdetail.salesorderid asc

    ),
    join_salesorderheader_salesorderdetail_with_sk as (
        select
            /*PK from salesorderheader*/
            salesorderheader_with_sk.salesorderid
            /*FK from salesorderheader*/
            , salesorderheader_with_sk.dim_client_fk	
            , salesorderheader_with_sk.dim_territories_fk	
            , salesorderheader_with_sk.dim_creditcard_fk				
            , salesorderheader_with_sk.dim_status_sales_fk
            /*Order pricing*/
            , salesorderheader_with_sk.subtotal
            , salesorderheader_with_sk.taxamt					
            , salesorderheader_with_sk.freight		
            , salesorderheader_with_sk.totaldue			
            /* Business rules*/
            , salesorderheader_with_sk.tax_per_order
            , salesorderheader_with_sk.freight_per_order
            , salesorderheader_with_sk.totaldue_per_order
	        , salesorderheader_with_sk.orderdate			
            /*Foreign Key from salesorderdetail */
            , salesorderdetail_with_sk.dim_product_fk
            , salesorderdetail_with_sk.specialofferid					
            /* sales order detail */
            , salesorderdetail_with_sk.orderqty
            , salesorderdetail_with_sk.unitprice
            , salesorderdetail_with_sk.unitpricediscount
            /*Business Rule*/
            , salesorderdetail_with_sk.gross_value
	        , salesorderdetail_with_sk.net_value
        from salesorderheader_with_sk
        left join salesorderdetail_with_sk on (salesorderheader_with_sk.salesorderid = salesorderdetail_with_sk.salesorderid)
        order by salesorderheader_with_sk.salesorderid asc

    ),
    join_salesorderheader_salesorderdetail_with_sk_remove_duplicates as (
        select
            *,
            row_number() over (partition by salesorderid order by salesorderid) as remove_duplicates_index,
        from join_salesorderheader_salesorderdetail_with_sk
    )
select *
from join_salesorderheader_salesorderdetail_with_sk_remove_duplicates
where remove_duplicates_index = 1 

