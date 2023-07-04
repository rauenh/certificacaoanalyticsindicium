with
    salesterritory as (
        select
            /* Primary Key*/
            territoryid
            /*FK*/
            , countryregioncode
            /*Sales by territory*/
            , name as name_salesterritory
            , `group`
            , salesytd
            , saleslastyear
            , costytd
            , costlastyear
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesterritory_hashid
        from {{source('raw', 'salesterritory')}}
    )
select *
from salesterritory