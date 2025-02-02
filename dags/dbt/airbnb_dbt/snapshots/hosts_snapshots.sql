{% snapshot hosts_snapshot %}
{{
 config(
 target_schema='DEV',
 unique_key='id',
 strategy='timestamp',
 updated_at='updated_at',
 invalidate_hard_deletes=True
 )
}}
select * FROM {{ source('raw_airbnb', 'hosts') }}
{% endsnapshot %}