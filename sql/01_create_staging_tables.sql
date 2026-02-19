-- =============================================
-- 01_create_staging_tables.sql
-- Creates staging tables for CRM and Product API
-- =============================================

-- Drop if exists (for development only)
IF OBJECT_ID('stg_crm_company_daily') IS NOT NULL
    DROP TABLE stg_crm_company_daily;

IF OBJECT_ID('stg_product_usage_daily') IS NOT NULL
    DROP TABLE stg_product_usage_daily;


-- =============================================
-- CRM STAGING TABLE
-- =============================================
CREATE TABLE stg_crm_company_daily (
    company_id        VARCHAR(50),
    name              VARCHAR(255),
    country           VARCHAR(100),
    industry_tag      VARCHAR(100),
    last_contact_at   DATETIME,
    ingestion_date    DATETIME DEFAULT GETDATE()
);


-- =============================================
-- PRODUCT USAGE STAGING TABLE
-- =============================================
CREATE TABLE stg_product_usage_daily (
    company_id     VARCHAR(50),
    activity_date  DATE,
    active_users   INT,
    events         INT,
    ingestion_date DATETIME DEFAULT GETDATE()
);