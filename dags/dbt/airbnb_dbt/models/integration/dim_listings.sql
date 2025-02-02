{{config(materialized = 'view')}}

SELECT
{{generate_hash_key('listing_id')}} as listing_hash_key, 
listing_id, 
listing_name, 
listing_url, 
room_type, 
  CASE WHEN minimum_nights = 0 THEN 1
    ELSE minimum_nights END AS minimum_nights,
  host_id,
  REPLACE( price_str, '$') :: NUMBER(10,2) AS price,
  created_at,
  updated_at
FROM {{ ref('src_listings') }}