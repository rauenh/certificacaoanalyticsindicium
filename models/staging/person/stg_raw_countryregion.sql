with
    countryregion as (
        select
            /* Primary Key & FK*/
            countryregioncode
            , name as name_country

            , modifieddate

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_countryregion_hashid

        from {{source('raw', 'countryregion')}}
    )

select *
from countryregion
