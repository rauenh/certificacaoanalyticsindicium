with

    salesorderheadersalesreason as (
        select
            salesorderid 
            , salesreasonid 
        from {{ source('stg_raw_salesorderheadersalesreason') }}
),
    salesreason as (
        select
            salesreasonid
            , salesreason_name
        from {{ source('stg_raw_salesreason') }}
)
    join_salesreason as (
        select
            salesorderheadersalesreason.salesorderid
            , salesorderheadersalesreason.salesreasonid
            , salesreason.salesreason_name
        from salesorderheadersalesreason
        left join salesreason on (salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid)
        order by salesorderheadersalesreason.salesorderid asc
    )
select *
from join_salesreason