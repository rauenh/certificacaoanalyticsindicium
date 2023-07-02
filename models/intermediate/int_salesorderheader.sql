with    
    salesorderheader as (
        select
            case
                when creditcardid is null then cast ('0' as int)
                else creditcardid
            end as creditcardid,
        from
            {{ ref('stg_raw_salesorderheader') }}
    )
select *
from salesorderheader