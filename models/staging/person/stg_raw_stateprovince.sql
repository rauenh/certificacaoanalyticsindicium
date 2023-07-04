with
    stateprovince as (
        select
            /* Primary Key */
            stateprovinceid
            /* FK*/
            , territoryid

            , stateprovincecode
            , countryregioncode
            , isonlystateprovinceflag
            , name as name_state_province
            , rowguid
            , modifieddate

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_stateprovince_hashid

        from {{source('raw', 'stateprovince')}}
    )

select *
from stateprovince
