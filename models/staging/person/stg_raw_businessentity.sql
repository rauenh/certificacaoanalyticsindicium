with
    businessentity as (
        select
            /* Primary Key*/
            businessentityid

            , modifieddate
            , rowguid

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_businessentity_hashid

        from {{source('raw', 'businessentity')}}
    )

select *
from businessentity