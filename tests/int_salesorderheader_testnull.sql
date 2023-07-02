-- tests/int_salesorderheader_testnull.sql

-- Test case for checking null values in the creditcardid column
{{ test('int_salesorderheader_testnull') }}
WITH null_creditcardid_count AS (
  SELECT COUNT(*) AS num_null_creditcardid
  FROM {{ ref('int_salesorderheader') }}
  WHERE creditcardid IS NULL
)
SELECT 1 AS dummy_value -- Any arbitrary value to generate a single row
FROM null_creditcardid_count
WHERE num_null_creditcardid > 0
{% if execute %}
  -- Assert condition to validate the expected result
  {% if not results[0].dummy_value %}
    {% set result_count = results[0].num_null_creditcardid %}
    {{ log('FAIL: Null values found in creditcardid column. Count: ' ~ result_count, 'error') }}
    {{ raise() }}
  {% else %}
    {{ log('PASS: No null values found in creditcardid column.', 'info') }}
  {% endif %}
{% endif %}
