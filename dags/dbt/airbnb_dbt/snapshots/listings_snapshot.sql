{% snapshot listings_snapshot %}
	{{
	config(
		database = 'int',
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'check',
		check_cols = ['listing_url','room_type','minimum_nights','price_str'],
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}