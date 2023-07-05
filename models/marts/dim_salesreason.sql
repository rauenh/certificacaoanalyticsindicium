with
    salesorderheadersalesreason as (
        select
            /* Primary Key & FK*/
            salesreasonid
            , salesorderid
        from {{ref('stg_raw_salesorderheadersalesreason')}}
    ),
    salesreason as (
        select
            /* Primary Key*/
            salesreasonid
            /*Other information*/
            , name_salesreason
            , reasontype
            , modifieddate
        from {{ref('stg_raw_salesreason')}}
    ),
    join_dim_salesreason as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderheadersalesreason.salesreasonid', 'salesorderheadersalesreason.salesorderid', 'salesreason.modifieddate']) }} as dim_salesreason_sk
            , salesorderheadersalesreason.salesorderid
            , salesorderheadersalesreason.salesreasonid
            , salesreason.name_salesreason
            , salesreason.reasontype
            from salesorderheadersalesreason
            left join salesreason on (salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid)
            order by salesorderheadersalesreason.salesorderid asc
    ),
    join_dim_salesreason_remove_duplicates as (
        select
            *,
            row_number() over (partition by salesorderid order by salesorderid) as remove_duplicates_index,
        from join_dim_salesreason
    )
    select *
    from join_dim_salesreason_remove_duplicates
    where remove_duplicates_index = 1 
