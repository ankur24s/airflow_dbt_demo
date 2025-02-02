{{
    config(
    materialized = 'incremental',
    on_schema_change='fail'
    )
}}
SELECT 
{{dbt_utils.generate_surrogate_key(['listing_id','review_date', 'reviewer_name', 'review_text','review_sentiment'])}} as review_id,
* FROM {{ ref('src_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
    {% if var("start_dt", False) and var("end_dt", False) %}
        AND review_date >= '{{var("start_dt")}}'
        and review_date <= '{{var("end_dt")}}'
    {% else %}
        AND review_date > (select max(review_date) from {{ this }})
    {% endif %}
{% endif %}