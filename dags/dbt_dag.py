import os
from datetime import datetime
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
import subprocess

# Profile configuration for Snowflake
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_conn",
        profile_args={"database": "raw", "schema": "airbnb"},
    )
)

# Function to run the Python script that logs failed tests
def log_failed_tests():
    subprocess.run(["python", "/usr/local/airflow/dags/python_scripts/log_failed_tests.py"])

# Define the Airflow DAG using Cosmos' DbtDag
dbt_snowflake_dag = DbtDag(
    project_config=ProjectConfig("/usr/local/airflow/dags/dbt/airbnb_dbt",),
    operator_args={"install_deps": True},
    profile_config=profile_config,
    execution_config=ExecutionConfig(dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",),
    schedule_interval="@daily",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    dag_id="dbt_dag",
)

# Task to run DBT tests
dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command="dbt test",
    dag=dbt_snowflake_dag,
)

# Task to run the Python script to log failed tests
log_failed_tests_task = PythonOperator(
    task_id='log_failed_tests',
    python_callable=log_failed_tests,
    dag=dbt_snowflake_dag,
)

# Set task dependencies (DBT test first, then log failed tests)
dbt_test >> log_failed_tests_task
