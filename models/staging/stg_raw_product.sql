with
    product as (
        productid
        , name as product_name
        , productsubcategoryid
        from {{source('raw','product')}}
    )
select *
from product