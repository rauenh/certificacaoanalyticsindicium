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
    productcategory as (
        select
            /* Primary Key */
            productcategoryid
            /* Product Caracteristics*/
            , name_productcategory
        from {{ref('stg_raw_productcategory')}}
    ),
    productsubcategory as (
        select
            /* Primary Key */
            productsubcategoryid
            /* FK*/
            , productcategoryid	
            /* Product Caracteristics*/
            , name_productsubcategory
        from {{ref('stg_raw_productsubcategory')}}
    )
    ,
    remove_duplicates as (
        select
            *,
            row_number() over (partition by productid order by productid) as remove_duplicates_index,
        from product
    ),
    join_dim_product as (
        select
            {{ dbt_utils.generate_surrogate_key(['productid']) }} as dim_product_sk
            , COALESCE(remove_duplicates.productsubcategoryid, 0) as productsubcategoryid
            , remove_duplicates.name_product
            , productcategory.name_productcategory
            , COALESCE(productsubcategory.name_productsubcategory, 'not informed') as name_productsubcategory
            from remove_duplicates
            left join productsubcategory on (remove_duplicates.productsubcategoryid = productsubcategory.productsubcategoryid)
            left join productcategory on (productsubcategory.productcategoryid = productcategory.productcategoryid)
            where remove_duplicates_index = 1 

    )
    select *
    from join_dim_product

