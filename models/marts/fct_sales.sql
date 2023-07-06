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
    dim_territories as (
        select *
        from {{ref('dim_territories')}}
    ),
    int_sales as (
        select *
        from {{ref('int_sales')}}
    ),
    join_fct_sales_with_sk as (
        select
            /*PK*/
            int_sales.int_sales_sk as int_sales_fk
            , int_sales.salesorderid
            , int_sales.count_salesorderid
            /*FK*/
            , dim_client.dim_client_sk as dim_client_fk	
            , dim_territories.dim_territories_sk as dim_territories_fk	
            , dim_creditcard.dim_creditcard_sk as dim_creditcard_fk				
            , dim_salesreason.dim_salesreason_sk as dim_salesreason_fk
            /*Order pricing*/
            , int_sales.subtotal
            , int_sales.taxamt					
            , int_sales.freight		
            , int_sales.totaldue
            /* Create Business Rule*/
            , int_sales.tax_per_order
            , int_sales.freight_per_order
            , int_sales.totaldue_per_order
            , int_sales.gross_value
	        , int_sales.net_value
	        , int_sales.orderdate			
            /*Foreign Key from salesorderdetail */
            , dim_products.dim_product_sk as dim_product_fk
            , int_sales.specialofferid					
            /* sales order detail */
            , int_sales.orderqty
            , int_sales.unitprice
            , int_sales.unitpricediscount
        from {{ref('int_sales')}} as int_sales
        left join dim_client on (int_sales.customerid = dim_client.customerid)
        left join dim_territories on (int_sales.shiptoaddressid = dim_territories.addressid)
        left join dim_creditcard on (int_sales.creditcardid = dim_creditcard.creditcardid)
        left join dim_products on (int_sales.productid = dim_products.productid)
        left join dim_salesreason on (int_sales.salesorderid = dim_salesreason.salesorderid)
        order by int_sales.salesorderid asc
    ),
    join_fct_sales_with_sk_remove_duplicates as (
        select
            *,
            row_number() over (partition by salesorderid order by salesorderid) as remove_duplicates_index,
        from join_fct_sales_with_sk
    )
select *
from join_fct_sales_with_sk_remove_duplicates
where remove_duplicates_index = 1 

