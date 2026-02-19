# Company Activity Analytics – Data Flow Architecture

## 1. Overview

This pipeline integrates CRM company data and product usage data to produce a daily analytics-ready fact table for reporting and churn detection.

---

## 2. Source Systems

### CRM Source
- Format: Daily CSV
- Location: Azure Blob Storage
- Fields:
  - company_id
  - name
  - country
  - industry_tag
  - last_contact_at

### Product Usage API
- Format: REST API returning JSON
- Fields:
  - company_id
  - date
  - active_users
  - events

---

## 3. Architecture Layers

RAW → STAGING → FACT

---

## 4. Detailed Flow

Step 1 – CRM Ingestion  
Azure Data Factory (Copy Activity)  
Blob CSV → stg_crm_company_daily

Step 2 – Product API Ingestion  
ADF Web Activity / Azure Function  
API → Raw JSON stored in Blob

Step 3 – Load to Staging  
ADF Copy Activity  
Raw JSON → stg_product_usage_daily

Step 4 – Transformation  
Stored Procedure / SQL Script  
Join staging tables  
Calculate rolling metrics  
Load fact_company_activity_daily

Step 5 – Reporting Layer  
Power BI / Dashboard reads from fact_company_activity_daily

---

## 5. Data Model Grain

fact_company_activity_daily  
One row per company per date

Primary Key:
(company_id, activity_date)

---

## 6. Derived Metrics

- events_per_user = events / active_users
- active_users_7d = rolling 7-day sum
- is_churn_risk = 40% drop vs previous 7 days

---

## 7. Error Handling Strategy

- ADF activity-level failure alerts
- Raw layer ensures reprocessing capability
- Staging tables allow safe reload

---

## 8. Incremental Strategy (Future Enhancement)

- Parameterized date ingestion
- Partition fact table by activity_date
- Replace TRUNCATE with MERGE logic