with
    customer as (
        select
            /* Primary Key*/
            customerid
            /*Foreign Key */
            , personid
            , storeid
            , territoryid
        from {{ref('stg_raw_customer')}}
    ),
    person as (
        select
            /* Primary Key & FK*/
            businessentityid
            /* Other information*/
            , persontype
            , firstname
            , lastname
            , demographics
            , rowguid
        from {{ref('stg_raw_person')}}
    ),
    store as (
        select
            /* Primary Key*/
            businessentityid
            /* FK */
            , salespersonid
            /*Stores (resellers) of ADW products*/
            , name_store
        from {{ref('stg_raw_store')}}
    ),
    join_dim_client as (
        select
            {{ dbt_utils.generate_surrogate_key(['customerid', 'personid', 'rowguid']) }} as dim_client_sk
            , customer.customerid
            , customer.personid
            , COALESCE(customer.storeid, 0) as storeid
            , COALESCE(store.name_store, 'not informed') as name_store
            , customer.territoryid
            , case
                when person.persontype = 'SC' then 'Store Contact'
                when person.persontype = 'IN' then 'Individual Customer'
                when person.persontype = 'SP' then 'Sales Person'
                when person.persontype = 'EM' then 'Employee'
                when person.persontype = 'VC' then 'Vendor'
                when person.persontype = 'GC' then 'General Contact'
            end as persontype
            , person.firstname
            , person.lastname
            , person.demographics
            from customer
            left join person on (customer.personid = person.businessentityid)
            left join store on (customer.storeid = store.businessentityid)
            where customer.personid is not null
            order by customer.customerid asc
    ),
    join_dim_client_remove_duplicates as (
        select
            *,
            row_number() over (partition by customerid order by customerid) as remove_duplicates_index,
        from join_dim_client
    )
    select *
    from join_dim_client_remove_duplicates
    where remove_duplicates_index = 1 
    /*select *
    from join_dim_client
    where personid is not null*/

