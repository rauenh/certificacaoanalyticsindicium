with
    salesreason as (
        select
            /* Primary Key*/
            salesreasonid
            /*Other information*/
            , name as name_salesreason
            , reasontype
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesreason_hashid
        from {{source('raw', 'salesreason')}}
    )
select *
from salesreason

	
