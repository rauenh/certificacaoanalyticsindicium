with
    salesorderheadersalesreason as (
        select
            /* Primary Key & FK*/
            salesreasonid
            , salesorderid
            /*Other information*/
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesorderheadersalesreason_hashid
        from {{source('raw', 'salesorderheadersalesreason')}}
    )
select *
from salesorderheadersalesreason
