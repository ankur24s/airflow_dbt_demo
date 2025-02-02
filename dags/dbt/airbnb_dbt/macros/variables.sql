{% macro learn_variables() %}

    {% set name = "ankur" %}

    {{log('Call ' ~  name ~ ' to fix it',      info = True)}}

    {{log('Hello! ' ~ var("user_name", "dbt_user"), info = True)}}

{% endmacro %}