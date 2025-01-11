{# 
    Input: column name with payment_type ID
    Output: payment type name
 #}
{% macro get_payment_type_description(payment_type_id) %}
    case
        cast(cast({{ payment_type_id }} as numeric) as integer)
        when 1
        then 'Credit Card'
        when 2
        then 'Cash'
        when 3
        then 'No Charge'
        when 4
        then 'Dispute'
        when 5
        then 'Unknown'
        when 6
        then 'Voided Trip'
        else null
    end
{# {% set payment_type_names = {
        1: 'Credit Card',
        2: 'Cash',
        3: 'No Charge',
        4: 'Dispute',
        5: 'Unknown',
        6: 'Voided Trip'
    } %}
    {{ payment_type_names[payment_type_id] if payment_type_id in payment_type_names else 'Invalid Payment Type' }} #}
{% endmacro %}
