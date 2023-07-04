with
    businessentityaddress as (
        select
            /* Primary Key & FK*/
            businessentityid
            , addresstypeid
            , addressid

            , modifieddate
            , rowguid

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_businessentityaddress_hashid

        from {{source('raw', 'businessentityaddress')}}
    )

select *
from businessentityaddress
