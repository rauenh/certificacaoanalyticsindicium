with int_sales as (
    select * 
    from {{ ref('int_sales_v2') }}
)

, deduplication_data as (
    select
        *
        , row_number() over (partition by salesorderid, salesorderdetailid order by salesorderid) as dedup_index
    from int_sales
)

, sales_with_sk  as (
    select
        {{ dbt_utils.generate_surrogate_key(['salesorderid', 'salesorderdetailid']) }}  as sale_identifier_sk
        , {{ dbt_utils.generate_surrogate_key(['salesorderid']) }} as sales_order_fk
        , {{ dbt_utils.generate_surrogate_key(['productid']) }} as dim_product_fk
        , {{ dbt_utils.generate_surrogate_key(['customerid']) }} as dim_client_fk
        , {{ dbt_utils.generate_surrogate_key(['shiptoaddressid']) }} as dim_territories_fk
        , {{ dbt_utils.generate_surrogate_key(['creditcardid']) }} as dim_creditcard_fk
        , {{ dbt_utils.generate_surrogate_key(['reasontype']) }} as dim_salesreason_fk
        , orderdate
        , online_order
        , carriertrackingnumber
        , paid_with_credit_card
        , status
        , orderqty
        , unitprice
        , unitpricediscount
        , sub_total_fixed
        , total_gross
		, freight_fixed
		, tax_fixed
        , total_due_fixed
    from deduplication_data
    where dedup_index = 1
)

select *
from sales_with_sk