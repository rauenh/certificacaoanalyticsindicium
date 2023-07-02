with

    creditcard as (
        select
            creditcardid
            , cardtype
        from {{ ref('int_creditcard') }}
),
        salesorderheader as (
    select
      salesorderid
      , creditcardid
    from {{ ref('int_salesorderheader') }}
        ),

        join_creditcard_dim as (
        select
            salesorderheader.salesorderid,
            salesorderheader.creditcardid,
            creditcard.cardtype,
        from creditcard
        left join salesorderheader on (creditcard.creditcardid = salesorderheader.creditcardid)
        order by salesorderheader.salesorderid asc
    )
select *
from join_creditcard_dim