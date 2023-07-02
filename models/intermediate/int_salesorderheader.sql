with    
    salesorderheader as (
        select
              salesorderid
            , subtotal
            , taxamt
            , freight
            , totaldue
            , cast(orderdate as datetime) as orderdate
            , status as status_sales
            , customerid
            , shiptoaddressid
            , territoryid
            case
                when creditcardid is null then cast ('0' as int)
                else creditcardid
            end as creditcardid,
        from
            {{ ref('stg_raw_salesorderheader') }}
    )
select *
from salesorderheader
