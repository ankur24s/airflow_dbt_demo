{{config(materialized = 'view')}} 

SELECT
    {{generate_hash_key_args(['host_id', 'host_name'])}} as host_hash_key,
    host_id,
    NVL(
        host_name,
        'Anonymous'
    ) AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    {{ ref('src_hosts') }}
