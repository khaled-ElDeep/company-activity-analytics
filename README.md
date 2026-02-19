# Company Activity Analytics Pipeline

## Overview

This project implements a production-style data pipeline that integrates:

- CRM company data (CSV in Azure Blob)
- Product usage API (JSON)

The goal is to build an analytics-ready fact table to power a Company Activity dashboard and churn detection logic.

---

## Architecture Diagram

### High-Level Architecture

![Architecture Overview](architecture/architecture_overview.png)

### ADF Pipeline Flow

![ADF Pipeline](architecture/adf_pipeline_flow.png)

---

## Data Flow

CRM CSV → ADF Copy → Staging Table  
Product API → Raw JSON (Blob) → Staging Table  
Staging → SQL Transformation → Fact Table  

---

## Data Model

Table: fact_company_activity_daily  

Grain:
One row per company per date  

Primary Key:
(company_id, activity_date)

---

## Derived Metrics

- events_per_user  
- active_users_7d (rolling 7-day sum)  
- is_churn_risk (40% drop vs previous 7 days)  

---

## Repository Structure
