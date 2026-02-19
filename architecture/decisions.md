# Architectural Decisions

## 1. Why Separate RAW, STAGING, and FACT?

RAW Layer:
- Stores original data for replay
- Protects against transformation errors
- Enables auditing

STAGING Layer:
- Structured but not business-processed
- Mirrors source format
- Simplifies debugging

FACT Layer:
- Business-ready
- Pre-computed metrics
- Optimized for BI queries

---

## 2. Why Grain = One Row per Company per Date?

Because:
- API provides daily activity
- Rolling metrics require daily granularity
- Enables time-series analysis
- Supports churn detection

---

## 3. Why Calculate Rolling Metrics in SQL?

Reasons:
- Databases are optimized for window functions
- Avoid heavy BI recalculations
- Ensures consistent business logic
- Better performance at scale

---

## 4. Why Store Raw API JSON?

Because:
- API schema may change
- Business logic may evolve
- Allows reprocessing without recalling API
- Supports audit and traceability

---

## 5. Why Use Composite Primary Key?

(company_id, activity_date)

Ensures:
- No duplicate daily records
- Correct grain enforcement
- Clean incremental loads

---

## 6. What Was Deferred (Time Constraints)?

- Data quality checks
- Automated backfill
- Monitoring dashboard
- Partition strategy
- CI/CD deployment automation