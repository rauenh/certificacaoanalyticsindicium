with
    dim_salesreason as (
        select *
        ,row_number() over (partition by reasontype order by reasontype) as remove_duplicates_index
        
        from {{ ref('int_reason') }}
    ),

    dim_salesreason_sk as (
        select
        {{ dbt_utils.generate_surrogate_key(['reasontype']) }} as dim_salesreason_sk
        , reasontype_fixed
        from dim_salesreason
        where remove_duplicates_index = 1
    )

select *
from dim_salesreason_sk
