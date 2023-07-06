with
    address as (
        select
            /* Primary Key*/
            addressid
            /*Foreign Key */
            , stateprovinceid
            /* Other infos*/
            , city
        from {{ref('stg_raw_address')}}
    ),
    stateprovince as (
        select
            /* Primary Key */
            stateprovinceid
            /* FK*/
            , territoryid
            , stateprovincecode
            , countryregioncode
            , name_state_province
        from {{ref('stg_raw_stateprovince')}}
    ),
    salesterritory as (
        select
            /* Primary Key*/
            territoryid
            /*FK*/
            , countryregioncode
            /*Sales by territory*/
            , name_salesterritory
            , `group`
            , salesytd
            , saleslastyear
            , costytd
            , costlastyear
        from {{ref('stg_raw_salesterritory')}}
    ),
    join_dim_territories as (
        select
            {{ dbt_utils.generate_surrogate_key(['addressid']) }} as dim_territories_sk
            , address.addressid
            , address.stateprovinceid
            , stateprovince.countryregioncode
            , stateprovince.stateprovincecode
            , stateprovince.name_state_province
            , address.city
            from address
            left join stateprovince on (address.stateprovinceid = stateprovince.stateprovinceid)
                left join salesterritory on (stateprovince.territoryid = salesterritory.territoryid)
    ),
    join_dim_territories_remove_duplicates as (
        select
            *,
            row_number() over (partition by addressid order by addressid) as remove_duplicates_index,
        from join_dim_territories
    )
    select *
    from join_dim_territories_remove_duplicates
    where remove_duplicates_index = 1 
