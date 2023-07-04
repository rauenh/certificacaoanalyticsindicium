with
    product as (
        select
            /* Primary Key */
            productid
            /* FK*/
            , productsubcategoryid	
            /* Product Caracteristics*/
            , productnumber			
            , name_product
            , rowguid				
        from {{ref('stg_raw_product')}}
    ),
    productsubcategory as (
        select
            /* Primary Key */
            productsubcategoryid
            /* Product Caracteristics*/
            , name_productsubcategory
        from {{ref('stg_raw_productsubcategory')}}
    ),
    join_dim_product as (
        select
            {{ dbt_utils.generate_surrogate_key(['productid', 'product.productsubcategoryid', 'rowguid']) }} as dim_product_sk
            , product.productid
            , COALESCE(product.productsubcategoryid, 0) as productsubcategoryid
            , product.name_product
            , COALESCE(productsubcategory.name_productsubcategory, 'not informed') as name_productsubcategory
            from product
            left join productsubcategory on (product.productsubcategoryid = productsubcategory.productsubcategoryid)
            order by product.productid asc
    )
    select *
    from join_dim_product

