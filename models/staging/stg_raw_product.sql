with
    product as (
        select
            productid
            , name as product_name
            , productsubcategoryid
            from {{source('raw','product')}}
    )
select *
from product