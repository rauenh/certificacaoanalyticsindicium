SELECT
    MD5(CAST(creditcardid AS string)) AS creditcard_sk,
    card_type,
    card_number,
    expmonth,
    expyear,
    current_timestamp AS modified_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY creditcardid ORDER BY creditcardid) AS remove_duplicates_index
    FROM {{ ref('int_creditcard') }}
) AS creditcard
WHERE remove_duplicates_index = 1;
