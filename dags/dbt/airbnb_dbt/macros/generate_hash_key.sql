{% macro generate_hash_key(column) %}
    md5(coalesce(cast({{column}} as varchar ), ''))
{% endmacro %}