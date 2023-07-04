with
    productcategory as (
        select
            /* Primary Key */
            productcategoryid
            /* Product Caracteristics*/
            , name as name_productcategory
            /* Business info*/
            , modifieddate	
            , rowguid				
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_productcategory_hashid

        from {{source('raw', 'productcategory')}}
    )
select *
from productcategory