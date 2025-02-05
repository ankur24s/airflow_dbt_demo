import json
import snowflake.connector
from datetime import datetime

# Connect to Snowflake
conn = snowflake.connector.connect(
    user='<your_user>',
    password='<your_password>',
    account='<your_account>',
    warehouse='<your_warehouse>',
    database='<your_database>',
    schema='<your_schema>'
)

# Load the run_results.json file
with open('target/run_results.json') as f:
    run_results = json.load(f)

# Extract failed tests
failed_tests = []
for result in run_results['results']:
    if result['status'] == 'fail':
        failed_tests.append({
            'test_execution_time': result['timestamp'],
            'test_name': result['test_name'],
            'test_status': result['status'],
            'model_name': result.get('model_name', 'N/A'),
            'column_name': result.get('column_name', 'N/A'),
            'failure_reason': result.get('failure_reason', 'N/A')
        })

# Insert failed tests into the Snowflake table
for failed_test in failed_tests:
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO failed_dbt_tests_log (
            test_execution_time, test_name, test_status,
            model_name, column_name, failure_reason
        ) VALUES (%s, %s, %s, %s, %s, %s)
    """, (
        failed_test['test_execution_time'],
        failed_test['test_name'],
        failed_test['test_status'],
        failed_test['model_name'],
        failed_test['column_name'],
        failed_test['failure_reason']
    ))

# Close the connection
conn.close()

print(f"Inserted {len(failed_tests)} failed tests into failed_dbt_tests_log.")
