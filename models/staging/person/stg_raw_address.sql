with
    address as (
        select
            /* Primary Key*/
            addressid

            /*Foreign Key */
            , stateprovinceid

            , city
            , postalcode
            , spatiallocation
            , addressline2
            , modifieddate
            , addressline1
            , rowguid

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_address_hashid

        from {{source('raw', 'address')}}
    )

select *
from address
