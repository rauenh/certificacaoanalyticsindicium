with
  creditcard as (
    select
      creditcardid
    , cardtype
    , expmonth
    , expyear
    , modifieddate
    , cardnumber
    from {{ source('raw', 'creditcard') }}
)

select *
from creditcard