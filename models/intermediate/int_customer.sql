with

    customer as (
        select
            customerid,
            personid,
            territoryid
        from {{ref('stg_raw_customer')}}
    ),
        salesorderheader as (
    select
      salesorderid
      , customerid
    from {{ source('raw', 'salesorderheader') }}
        ),

    person as (
        select
            businessentityid,
            persontype,
            firstname,
            middlename,
            lastname
        from {{ref('stg_raw_person')}}
    ),
    businessentitycontact as (
        select
            businessentityid
            , personid
        from {{ref('stg_raw_businessentitycontact')}}
    ),
    businessentity as (
        select
            businessentityid,
        from {{ref('stg_raw_businessentity')}}
    ),

        join_customer as (
        select
            customer.customerid,
            customer.personid,
            businessentity.businessentityid,
            CASE
                WHEN person.persontype = 'SC' THEN 'Store Contact'
                WHEN person.persontype = 'IN' THEN 'Individual Customer'
                WHEN person.persontype = 'SP' THEN 'Sales Person'
                WHEN person.persontype = 'EM' THEN 'Employee'
                WHEN person.persontype = 'VC' THEN 'Vendor'
                WHEN person.persontype = 'GC' THEN 'General Contact'
            end as persontype,
            person.firstname,
            person.middlename,
            person.lastname
        from person
        left join businessentity on (person.businessentityid = businessentity.businessentityid)
        left join businessentitycontact on (businessentity.businessentityid = businessentitycontact.businessentityid) 
        left join customer on (customer.personid = person.businessentityid)
        left join salesorderheader on (customer.customerid = salesorderheader.customerid)
        order by customer.customerid asc
    )
select *
from join_customer