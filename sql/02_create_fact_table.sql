-- =============================================
-- 02_create_fact_table.sql
-- Creates analytics fact table
-- =============================================

IF OBJECT_ID('fact_company_activity_daily') IS NOT NULL
    DROP TABLE fact_company_activity_daily;

CREATE TABLE fact_company_activity_daily (
    activity_date      DATE NOT NULL,
    company_id         VARCHAR(50) NOT NULL,

    company_name       VARCHAR(255),
    country            VARCHAR(100),
    industry_tag       VARCHAR(100),
    last_contact_at    DATETIME,

    active_users       INT,
    events             INT,

    events_per_user    FLOAT,
    active_users_7d    INT,
    is_churn_risk      BIT,

    load_datetime      DATETIME DEFAULT GETDATE(),

    CONSTRAINT pk_fact_company_activity
        PRIMARY KEY (company_id, activity_date)
);