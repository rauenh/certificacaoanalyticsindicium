with
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
            , int_sales.status
            /*FK*/
            , {{ dbt_utils.generate_surrogate_key(['customerid']) }} as dim_client_fk
            , {{ dbt_utils.generate_surrogate_key(['shiptoaddressid']) }} as dim_territories_fk
            , {{ dbt_utils.generate_surrogate_key(['creditcardid']) }} as dim_creditcard_fk
            , {{ dbt_utils.generate_surrogate_key(['salesreasonid']) }} as dim_salesreason_fk
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
            , int_sales.average_ticket
	        , int_sales.orderdate			
            /*Foreign Key from salesorderdetail */
            ,{{ dbt_utils.generate_surrogate_key(['productid']) }} as dim_product_fk
            , int_sales.specialofferid					
            /* sales order detail */
            , int_sales.orderqty
            , int_sales.unitprice
            , int_sales.unitpricediscount
        from {{ref('int_sales')}} as int_sales
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

