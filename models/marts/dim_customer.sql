with
    selected as (
        select
            customerid
            , personid
            , territoryid
            from {{ref('stg_raw_customer')}}
    )
    , transformed as (
        select
            row_number() over (order by customerid) as customer_sk
            , *
        from selected
    )
select *
from transformed