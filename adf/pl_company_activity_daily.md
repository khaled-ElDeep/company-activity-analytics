# ADF Pipeline – pl_company_activity_daily

## Pipeline Purpose

Orchestrates ingestion and transformation of Company Activity data.

---

## Activities (Execution Order)

1. Copy CRM CSV  
   Source: Azure Blob  
   Sink: stg_crm_company_daily  

2. Web Activity – Call Product API  
   Calls Azure Function or REST endpoint  
   Saves raw JSON to Blob (raw layer)

3. Copy Raw JSON to Staging  
   Source: Raw Blob  
   Sink: stg_product_usage_daily  

4. Execute Stored Procedure  
   sp_load_fact_company_activity_daily  

---

## Failure Handling

- Each activity configured with OnFailure path
- Sends alert via Logic App / Email
- Logs execution metadata

---

## Parameterization

Pipeline parameters:
- start_date
- end_date

Used in:
- API call
- Incremental loading logic (future enhancement)

---

## Naming Convention

pl_ → pipeline  
stg_ → staging table  
fact_ → analytics table  
raw/ → blob raw storage  

---

## Monitoring Strategy

- ADF built-in monitoring
- Activity-level logging
- Retry policy (3 retries recommended)