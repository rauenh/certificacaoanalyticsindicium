with
  creditcard as (
    select
      creditcardid
    , cardtype
    from {{ source('raw', 'creditcard') }}
)

select *
from creditcard