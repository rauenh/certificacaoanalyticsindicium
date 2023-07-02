with
    customer as (
        select
            customerid,
            personid,
            territoryid
        from {{ref('stg_raw_customer')}}
    ),
    businessentitycontact as (
        select
            businessentityid,
            personid
        from {{ref('stg_raw_businessentitycontact')}}
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
    join_customer as (
        select
            customer.customerid,
            customer.personid,
            businessentitycontact.businessentityid,
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
        from customer
        left join person on (customer.personid = person.businessentityid)
        order by customer.customerid asc
    )
select *
from join_customer