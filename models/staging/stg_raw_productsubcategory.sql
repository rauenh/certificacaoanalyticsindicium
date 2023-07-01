with
    product as (
        select
            productsubcategoryid
            , name as name_subcategory
            from {{source('raw','productsubcategory')}}
    )
select *
from product