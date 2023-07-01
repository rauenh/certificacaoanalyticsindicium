with
  salesorderheadersalesreason as (
    select
      salesorderid 
    , salesreasonid 
    from {{ source('raw', 'salesorderheadersalesreason') }}
)

select *
from salesorderheadersalesreason