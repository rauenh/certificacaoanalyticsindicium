with
    specialoffer as (
        select
            /* Primary Key*/
            specialofferid
            /*specialoffers information*/
            , description as description_discount
            , discountpct
            , type as type_discount
            , category
            , startdate
            , enddate
            , minqty
            , maxqty
            , rowguid
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_specialoffer_hashid
        from {{source('raw', 'specialoffer')}}
    )
select *
from specialoffer
