with
    businessentitycontact as (
        select
            /* Primary Key & FK*/
            businessentityid
            , contacttypeid
            , personid

            , modifieddate
            , rowguid

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_businessentitycontact_hashid

        from {{source('raw', 'businessentitycontact')}}
    )

select *
from businessentitycontact
