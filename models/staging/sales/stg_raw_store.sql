with
    store as (
        select
            /* Primary Key*/
            businessentityid
            /* FK */
            , salespersonid
            /*Stores (resellers) of ADW products*/
            , name as name_store
            , demographics
            , rowguid
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_store_hashid
        from {{source('raw', 'store')}}
    )
select *
from store

