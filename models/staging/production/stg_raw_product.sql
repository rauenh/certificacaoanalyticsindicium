with
    product as (
        select
            /* Primary Key */
            productid
            /* FK*/
            , productsubcategoryid	
            , productmodelid
            /* Product Caracteristics*/
            , productnumber			
            , name as name_product
            , productline					
            , color	
            , style				
            , size
            , sizeunitmeasurecode
            , weightunitmeasurecode	
            , weight		
            /* Price and manufacturing */            
            , listprice					
            , class					
            , standardcost					
            , daystomanufacture	
            /* Business info*/
            , reorderpoint					
            , safetystocklevel					
            , makeflag
            , finishedgoodsflag	
            , sellstartdate
            , sellenddate
            , discontinueddate					
            , modifieddate	
            , rowguid				
            /* airbyte extraction */
            , _airbyte_ab_id
            , _airbyte_emitted_at 
            , _airbyte_normalized_at as last_etl_run
            , _airbyte_product_hashid

        from {{source('raw', 'product')}}
    )
select *
from product