with
    salesorderheadersalesreason as (
        select
            /* Primary Key & FK*/
            salesreasonid
            , salesorderid
        from {{ref('stg_raw_salesorderheadersalesreason')}}
    ),
    salesreason as (
        select
            /* Primary Key*/
            salesreasonid
            /*Other information*/
            , name_salesreason
            , reasontype
        from {{ref('stg_raw_salesreason')}}
    ),
    join_dim_salesreason as (
        select
            salesorderid
            , salesorderheadersalesreason.salesreasonid
            , salesreason.name_salesreason
            , salesreason.reasontype
            
            /*, row_number() over (partition by salesreason.reasontype order by salesreason.salesreasonid) as remove_duplicates_index*/

            from salesorderheadersalesreason
            left join salesreason on (salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid)
            order by reasontype asc
        /*union all
        select
            null as salesreasonid
            , null as name_salesreason
            , null as reasontype
            /*, 1 as remove_duplicates_index*/
    ), 
    aggregate_columns as (
        select
            salesorderid
            , string_agg(reasontype, ', ') as agg_reason_type
            , string_agg(name_salesreason , ', ') as agg_name_reason
        from join_dim_salesreason
        group by salesorderid
    ),
    
    replace_aggregate as (
	select 
		salesorderid
		, replace(
			replace(replace(agg_reason_type,'Other, Other', 'Other')
				, 'Other, Promotion', 'Promotion')
			, 'Marketing, Other','Marketing') as reasontype
		, replace(agg_name_reason,'Other, Other', 'Other') as name_salesreason
        --*, row_number() over (partition by reasontype order by reasontype) as remove_duplicates_index

	from aggregate_columns
	union all
	select
		null as salesorderid
		, null as reasontype
		, null as name_salesreason
        --, 1 as remove_duplicates_index

)
, join_dim_salesreason_remove_duplicates as (
        select
            reasontype
            , salesorderid
        , ifnull(reasontype,"Não definido") as reasontype_fixed

        from replace_aggregate
       

    )
select *
from join_dim_salesreason_remove_duplicates
