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
      , creditcardid
    from {{ source('raw', 'salesorderheader') }}
)

select *
from salesorderheader