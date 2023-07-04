with
    creditcard as (
        select
            /* Primary Key*/
            creditcardid
            /* CC Information */
            , cardtype
            , cardnumber
            , expmonth
            , expyear
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_creditcard_hashid

        from {{source('raw', 'creditcard')}}
    )
select *
from creditcard
