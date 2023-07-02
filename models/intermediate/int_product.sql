with    

    product as (
        select
            productid,
            product_name,
            case
                when productsubcategoryid is null then cast ('0' as int)
                else productsubcategoryid
            end as productsubcategoryid,
        from
            {{ ref('stg_raw_product') }}
    )
select *
from product
