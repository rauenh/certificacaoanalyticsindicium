with
    salesorderdetail as (
        select
            /* Primary Key*/
            salesorderid
            , salesorderdetailid					
            /*Foreign Key */
            , productid	
            , specialofferid					
            /* sales order detail */
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
            , rowguid
            , modifieddate
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_salesorderdetail_hashid

        from {{source('raw', 'salesorderdetail')}}
    )
select *
from salesorderdetail
