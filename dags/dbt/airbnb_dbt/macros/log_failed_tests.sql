{% macro log_failed_tests(test_name, status, error_message, warning_message) %}
    {% if test_name is none or test_name == '' %}
        {% set test_name = 'Unknown Test' %}
    {% endif %}

    {% if error_message is none or error_message == '' %}
        {% set error_message = 'No error message provided' %}
    {% endif %}

    {% if warning_message is none or warning_message == '' %}
        {% set warning_message = 'No warning provided' %}
    {% endif %}

    {% if status == 'fail' %}
        -- Log the failed test result into Snowflake
        INSERT INTO RAW.AIRBNB.failed_tests (test_name, error_message, warning_message, result, created_at)
        VALUES ('{{ test_name }}', '{{ error_message }}', '{{ warning_message }}', 'fail', current_timestamp());
    {% elif status == 'WARN' %}
        -- Log the warning test result into Snowflake
        INSERT INTO RAW.AIRBNB.failed_tests (test_name, error_message, warning_message, result, created_at)
        VALUES ('{{ test_name }}', 'No error', '{{ warning_message }}', 'warn', current_timestamp());
    {% else %}
        -- Log a successful test result (optional)
        INSERT INTO RAW.AIRBNB.failed_tests (test_name, error_message, warning_message, result, created_at)
        VALUES ('{{ test_name }}', 'No error', 'No warning', 'pass', current_timestamp());
    {% endif %}
{% endmacro %}
