with 
    salesorderheader as (
        select
            /*PK*/
            salesorderid
            /*FK*/
            , customerid		
            , salespersonid	
            , territoryid	
            , billtoaddressid	
            , shiptoaddressid	
            , creditcardid				
            , currencyrateid				
            , shipmethodid					
            /* Order information for customer*/
            , case 
                when status = 1 then 'In Process'
                when status = 2 then 'Approved'
                when status = 3 then 'Backordered'
                when status = 4 then 'Rejected'
                when status = 5 then 'Shipped'
                when status = 6 then 'Cancelled'
            end as status
            , purchaseordernumber
            , creditcardapprovalcode					
            , accountnumber					
            , onlineorderflag
	        , orderdate
            , shipdate	
            , duedate		
            /*Order pricing*/
            , subtotal
            , taxamt					
            , freight		
            , totaldue					
        from {{ref('stg_raw_salesorderheader')}}
    ),
    salesorderdetail as (
        select
            /* Primary Key*/
            salesorderid
            , salesorderdetailid					
            /*Foreign Key */
            , productid	
            , specialofferid					
            /* sales order detail */
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
        from {{ref('stg_raw_salesorderdetail')}}
    ),
    salesorderheadersalesreason as (
        select
            /* Primary Key & FK*/
            salesreasonid
            , salesorderid
        from {{ref('stg_raw_salesorderheadersalesreason')}}
    ),
     creditcard as (
	    select * 
	    from {{ ref('stg_raw_creditcard') }}	
    ),
    int_reason as (
        select *
        from {{ref('int_reason')}}
    ),

    union_credit_card as (
	    select 
	    	salesorderheader.*
	    	, cardtype
	    from salesorderheader 
	    left join creditcard on creditcard.creditcardid = salesorderheader.creditcardid
    ),

    union_header_detail as (
	    select 
		union_credit_card.*
		, salesorderdetailid
		, carriertrackingnumber
		, productid
		, orderqty
		, unitprice
		, case 
			when unitpricediscount != 0
				then unitpricediscount
			else null
		end as unitpricediscount
		, ((1 - COALESCE(unitpricediscount,0)) * unitprice * orderqty) as sub_total_fixed
	from salesorderdetail 
	left join union_credit_card
		on union_credit_card.salesorderid =  salesorderdetail.salesorderid
    ),

     count_orders as (
        select 
            salesorderid
            , count(salesorderid) as count_orders_rows
            from union_header_detail
            group by salesorderid
    ),

    join_fixing_columns as (
        select
            union_header_detail.*
            , count_orders_rows
            , freight / count_orders_rows as freight_fixed
            , taxamt / count_orders_rows as tax_fixed
            from union_header_detail
            left join count_orders
                on count_orders.salesorderid  = union_header_detail.salesorderid
)

, fixed_table as (
	select 
		 salesorderid
		, salesorderdetailid
		, customerid
		, orderdate
		, case 
			when purchaseordernumber is not null
				then "Loja física"
			else "Compra online"
		end as online_order
		, salespersonid
		, territoryid
		, billtoaddressid
		, shiptoaddressid
		, shipmethodid
		, case 
			when creditcardapprovalcode is not null
				then "CC Payment"
			else "Other payment method"
		end as paid_with_credit_card
        , creditcardid
		, cardtype
		, status
		, carriertrackingnumber
		, productid
		, orderqty
		, unitprice
		, unitpricediscount
		, sub_total_fixed
		, freight_fixed
		, tax_fixed
		, sub_total_fixed + freight_fixed + tax_fixed as total_due_fixed
		, unitprice * orderqty as total_gross
	from join_fixing_columns
)

, union_reason as (
	select
		fixed_table.*
		, reasontype
		from fixed_table
		left join int_reason on int_reason.salesorderid = fixed_table.salesorderid
        
)

select * 
from union_reason
