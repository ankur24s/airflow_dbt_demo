select 
    REVIEW_ID, r.LISTING_ID, REVIEW_DATE, REVIEWER_NAME, REVIEW_TEXT, REVIEW_SENTIMENT,
    LISTING_NAME, ROOM_TYPE, MINIMUM_NIGHTS, PRICE, HOST_ID, HOST_NAME, HOST_IS_SUPERHOST,
    lh.created_at as listing_date
from
{{ref('fct_reviews')}} r left join 
{{ref('dim_listings_w_hosts')}} lh on r.listing_id = lh.listing_id
