with
    person as (
        select
            /* Primary Key & FK*/
            businessentityid

            , namestyle
            , persontype
            , title
            , suffix
            , firstname
            , middlename
            , lastname
            , additionalcontactinfo
            , demographics
            , emailpromotion
            , rowguid
            , modifieddate

            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_person_hashid

        from {{source('raw', 'person')}}
    )

select *
from person

