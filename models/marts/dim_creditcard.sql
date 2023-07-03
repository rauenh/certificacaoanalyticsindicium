with
    creditcard as (
        select *
        from {{ ref('int_creditcard_dim') }}
    ),
    remove_duplicates as (
        select
            *,
            row_number() over (partition by  creditcardid order by creditcardid) as remove_duplicates_index,
        from creditcard
    ),
    creditcard_sk as (
        select
            MD5(cast(creditcardid as string)) as creditcard_sk,
            salesorderid,
            cardtype,
        from remove_duplicates
        where remove_duplicates_index = 1
    )
select *
from creditcard_sk