with
    salesorderheader as (
        select
            /*PK*/
            salesorderid
            /*FK*/
            , customerid		
            , salespersonid	
            , creditcardid				
            /*Other informations*/      
            , rowguid					
        from {{ref('stg_raw_salesorderheader')}}
    ),
    creditcard as (
        select
            /* Primary Key*/
            creditcardid
            /* CC Information */
            , cardtype
        from {{ref('stg_raw_creditcard')}}
    ),
    join_dim_creditcard as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderid', 'salesorderheader.creditcardid', 'rowguid']) }} as dim_creditcard_sk
            , salesorderheader.salesorderid
            , salesorderheader.customerid
            , salesorderheader.salespersonid
            , COALESCE(salesorderheader.creditcardid, 0) as creditcardid
            , COALESCE(creditcard.cardtype, 'not informed') as cardtype
            from salesorderheader
            left join creditcard on (salesorderheader.creditcardid = creditcard.creditcardid)
            order by salesorderheader.salesorderid asc
    )
    select *
    from join_dim_creditcard