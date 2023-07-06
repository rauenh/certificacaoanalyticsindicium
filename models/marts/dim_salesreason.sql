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
             salesorderheadersalesreason.salesreasonid
            , salesreason.name_salesreason
            , salesreason.reasontype
            , row_number() over (partition by salesorderheadersalesreason.salesreasonid order by salesorderheadersalesreason.salesreasonid
) as remove_duplicates_index

            from salesorderheadersalesreason
            left join salesreason on (salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid)
        union all
        select
            null as salesreasonid
            , null as name_salesreason
            , null as reasontype
            , 1 as remove_duplicates_index
    ),
    join_dim_salesreason_remove_duplicates as (
        select
            *
            , {{ dbt_utils.generate_surrogate_key(['salesreasonid']) }} as dim_salesreason_sk
        from join_dim_salesreason
        where remove_duplicates_index = 1

    )
    select *
    from join_dim_salesreason_remove_duplicates
