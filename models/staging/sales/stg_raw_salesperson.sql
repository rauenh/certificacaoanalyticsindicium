with
    salesperson as (
        select
            /* Primary Key*/
            businessentityid
            /*FK*/
            , territoryid
            /*Sales by sales person*/
            , salesquota
            , bonus
            , commissionpct
            , salesytd
            , saleslastyear
            , rowguid
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesperson_hashid
        from {{source('raw', 'salesperson')}}
    )
select *
from salesperson