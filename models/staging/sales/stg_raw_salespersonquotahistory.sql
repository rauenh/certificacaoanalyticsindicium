with
    salespersonquotahistory as (
        select
            /* Primary Key*/
            businessentityid
            /*Sales by sales person*/
            , salesquota
            , quotadate
            , rowguid
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salespersonquotahistory_hashid
        from {{source('raw', 'salespersonquotahistory')}}
    )
select *
from salespersonquotahistory