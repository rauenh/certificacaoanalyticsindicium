with new_row as (
  select 0 as creditcardid, 'other payment method' as cardtype
)

select creditcardid, cardtype
from {{ ref('stg_raw_creditcard') }}

-- Append the new row to the existing data
union all

-- Select the new row to be inserted
select creditcardid, cardtype
from new_row
