
SELECT
id AS host_id,
NAME AS host_name, 
is_superhost, 
created_at, 
updated_at
FROM 
{{source('raw_airbnb','hosts')}}