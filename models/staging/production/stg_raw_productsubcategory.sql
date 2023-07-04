with
    productsubcategory as (
        select
            /* Primary Key */
            productsubcategoryid
            /* FK*/
            , productcategoryid	
            /* Product Caracteristics*/
            , name as name_productsubcategory
            /* Business info*/
            , modifieddate	
            , rowguid				
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_productsubcategory_hashid

        from {{source('raw', 'productsubcategory')}}
    )
select *
from productsubcategory