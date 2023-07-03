with
    customer as (
        select *
        from {{ ref('int_customer_dim') }}
    ),
    remove_duplicates as (
        select
            *,
            row_number() over (partition by  customerid order by customerid) as remove_duplicates_index,
        from customer
    ),
    customer_sk as (
        select
            MD5(cast(customerid as string)) as customer_sk,
            personid,
            businessentityid,
            firstname,
            lastname,
        from remove_duplicates
        where remove_duplicates_index = 1
    )
select *
from customer_sk