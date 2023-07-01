with
  salesreason as (
    select
      salesreasonid
    , name as salesreason_name
    from {{ source('raw', 'salesreason') }}
)

select *
from salesreason