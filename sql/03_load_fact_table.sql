-- =============================================
-- 03_load_fact_table.sql
-- Loads fact table from staging
-- =============================================

-- For demo purposes: full reload
TRUNCATE TABLE fact_company_activity_daily;


INSERT INTO fact_company_activity_daily
SELECT
    u.activity_date,
    u.company_id,

    c.name AS company_name,
    c.country,
    c.industry_tag,
    c.last_contact_at,

    u.active_users,
    u.events,

    -- Derived Metric: events per user
    CASE 
        WHEN u.active_users > 0 
        THEN u.events * 1.0 / u.active_users
        ELSE 0
    END AS events_per_user,

    -- 7-day rolling sum
    SUM(u.active_users) OVER (
        PARTITION BY u.company_id
        ORDER BY u.activity_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS active_users_7d,

    -- Churn risk: 40% drop vs previous 7 days
    CASE
        WHEN
            SUM(u.active_users) OVER (
                PARTITION BY u.company_id
                ORDER BY u.activity_date
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            )
            <
            0.6 *
            SUM(u.active_users) OVER (
                PARTITION BY u.company_id
                ORDER BY u.activity_date
                ROWS BETWEEN 13 PRECEDING AND 7 PRECEDING
            )
        THEN 1
        ELSE 0
    END AS is_churn_risk,

    GETDATE()

FROM stg_product_usage_daily u
LEFT JOIN stg_crm_company_daily c
    ON u.company_id = c.company_id;