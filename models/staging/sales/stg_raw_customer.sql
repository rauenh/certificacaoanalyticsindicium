with
    customer as (
        select
            /* Primary Key*/
            customerid
            /*Foreign Key */
            , personid
            , storeid
            , territoryid
            /* Customer information*/
            , modifieddate
            , rowguid
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_customer_hashid

        from {{source('raw', 'customer')}}
    )

select *
from customer