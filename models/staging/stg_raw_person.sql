with
    person as (
        select
            businessentityid
            , persontype
            , firstname
            , middlename
            , lastname
            from {{source('raw', 'person')}}
    )
select *
from person