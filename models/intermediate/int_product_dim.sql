with

    product as (
        select
            productid
            , product_name
            , productsubcategoryid
            from {{ref('stg_raw_product')}}
    ),
    
     productsubcategory as (
        select
            productsubcategoryid
            , name_subcategory
            from {{ref('stg_raw_productsubcategory')}}
    ),

        join_product as (
        select
            product.productid,
            product.productsubcategoryid,
            product.product_name,
            productsubcategory.name_subcategory
        from product
        left join productsubcategory on (product.productsubcategoryid = productsubcategory.productsubcategoryid)
        order by product.productid asc
    )
select *
from join_product