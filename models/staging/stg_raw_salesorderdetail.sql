with
  salesorderdetail as (
    select
      salesorderid
      , salesorderdetailid
      , orderqty
      , unitprice
      , productid
      , unitpricediscount
    from {{ source('raw', 'salesorderdetail') }}
)

select *
from salesorderdetail