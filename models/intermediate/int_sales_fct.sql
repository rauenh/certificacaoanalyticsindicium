with
    salesorderheader as (
        select
              salesorderid
            , subtotal
            , taxamt
            , freight
            , totaldue
            , orderdate
            , status_sales
            , customerid
            , shiptoaddressid
            , territoryid
            , case
                when creditcardid is null then cast ('0' as int)
                else creditcardid
            end as creditcardid,
        from
            {{ ref('int_salesorderheader') }}
    ),
    salesorderdetail as (
        select
          salesorderid
          , salesorderdetailid
          , orderqty
          , unitprice
          , productid
          , unitpricediscount
        from {{ ref('stg_raw_salesorderdetail') }}
    ),
    salesreason as (
        select
            salesreasonid
            , salesreason_name
        from {{ ref('stg_raw_salesreason') }}
    ),
    salesorderheadersalesreason as (
        select
            salesorderid 
            , salesreasonid 
        from {{ ref('stg_raw_salesorderheadersalesreason') }}
),
    join_sales_fct as (
        select
            salesorderdetail.salesorderdetailid,
            salesorderheader.salesorderid,
            salesorderheader.customerid,
            salesorderdetail.productid,
            salesorderheader.creditcardid,
            salesreason.salesreasonid,
            case 
                when salesorderheader.status_sales = 1 then 'In Process'
                when salesorderheader.status_sales = 2 then 'Approved'
                when salesorderheader.status_sales = 3 then 'Backordered'
                when salesorderheader.status_sales = 4 then 'Rejected'
                when salesorderheader.status_sales = 5 then 'Shipped'
                when salesorderheader.status_sales = 6 then 'Cancelled'
            end as status_sales,
            salesorderdetail.orderqty,
            salesorderdetail.unitprice,
            salesorderdetail.unitpricediscount,
            (salesorderdetail.unitprice * salesorderdetail.orderqty) as total_value,
	        (salesorderdetail.unitprice * salesorderdetail.orderqty) * (1-salesorderdetail.unitpricediscount) as liquid_total_value,
            salesorderheader.taxamt/(count(salesorderheader.taxamt) over (partition by salesorderheader.salesorderid)) as tax_per_order,
            salesorderheader.freight/(count(salesorderheader.freight) over (partition by salesorderheader.salesorderid)) as freight_per_order,
            salesorderheader.totaldue/(count(salesorderheader.totaldue) over (partition by salesorderheader.salesorderid)) as totaldue_per_order,
	        cast(salesorderheader.orderdate as timestamp) as orderdate,
        from salesorderheader
        left join salesorderdetail on salesorderheader.salesorderid = salesorderdetail.salesorderid
        left join salesorderheadersalesreason on (salesorderdetail.salesorderid = salesorderheadersalesreason.salesorderid)
        left join salesreason on (salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid)
    )
select *
from join_sales_fct