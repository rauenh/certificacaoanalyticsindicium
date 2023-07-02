with new_row as (
  select 0 as productsubcategoryid, 'not specified' as name_subcategory
)

select productsubcategoryid, name_subcategory
from {{ ref('stg_raw_productsubcategory') }}

-- Append the new row to the existing data
union all

-- Select the new row to be inserted
select productsubcategoryid, name_subcategory
from new_row
