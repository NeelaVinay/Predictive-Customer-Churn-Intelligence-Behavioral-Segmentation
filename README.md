# 💳 Credit Card Customer Churn Intelligence System
### Harbor Trust Bank | 10,127 Customers | Power BI · SQL · Python · Excel

> **Identified 809 high-risk customers with a 38.4% churn probability (2.4× the 16.1% baseline), enabling targeted retention campaigns estimated to recover ~$170K in annual fee revenue.**

---

## 📌 Project Summary

Harbor Trust Bank was losing credit card customers at a **16.1% annual churn rate** — directly eroding fee income, transaction volume, and cross-selling opportunities. This project builds a full churn-intelligence system that:

- Identifies **who** is churning and **why**
- Segments customers by **behavioral risk tier**
- Delivers actionable **Power BI dashboards** for retention teams

---

## 🎯 Business Problem

| Question | Answer (Data-Validated) |
|---|---|
| What is the churn rate? | **16.1%** (1,627 / 10,127 customers) |
| Which card tier churns most? | **Platinum at 25%**, Blue at 16.1% |
| What behavioral signals predict churn? | Low transaction count, high inactivity, low utilization |
| How large is the high-risk segment? | **809 customers** with 38.4% churn probability |
| What is the revenue exposure? | **~$170K** in annual fees at risk |

---

## 📊 Key Findings (All Validated Against Raw Data)

### Behavioral Delta — Churned vs Existing Customers

| Metric | Churned | Existing | Difference |
|---|---|---|---|
| Avg Transaction Count | 44.9 | 68.7 | **−35%** |
| Avg Transaction Amount | $3,095 | $4,655 | **−34%** |
| Avg Utilization Ratio | 0.162 | 0.296 | **−45%** |
| Avg Months Inactive | 2.69 | 2.27 | +19% |
| Avg Products Held | 3.28 | 3.91 | −16% |

### Churn Rate by Card Category

| Card Type | Total | Churned | Churn Rate |
|---|---|---|---|
| Platinum | 20 | 5 | **25.0%** |
| Gold | 116 | 21 | **18.1%** |
| Blue | 9,436 | 1,519 | **16.1%** |
| Silver | 555 | 82 | **14.8%** |

### High-Risk Segment Criteria
Customers flagged as **High-Risk** meet 3+ of the following conditions:
- Transaction count < 40 (last 12 months)
- Months inactive ≥ 3
- Utilization ratio < 0.10
- Contact frequency ≥ 4 (distress contacts)
- Products held ≤ 2

**Result: 809 customers, 38.4% churn rate — 2.4× baseline**

---

## 🛠️ Tech Stack

| Tool | Usage |
|---|---|
| **Power BI** | Interactive dashboards, DAX measures, churn KPIs, slicers |
| **SQL** | Churn segmentation queries, risk scoring, revenue impact |
| **Excel** | Data cleaning |

---

## 📁 Repository Structure

```
├── BankChurners.csv                        # Raw dataset (10,127 records)
├── Credit_Card_Customer_Churn_Intelligence_Report.pbix  # Power BI dashboard
├── Project_2_Credit_Card_Customer_Churn.docx            # Project brief
├── sql/
│   └── Customer_churn_SQL_Analysis.sql                 # 10 SQL queries: segmentation, risk scoring, revenue
└── README.md
```

---

## 🚀 How to Run

### Power BI
```
1. Download Credit_Card_Customer_Churn_Intelligence_Report.pbix
2. Open in Power BI Desktop (free download from Microsoft)
3. Use slicers to filter by Card Type, Income, Gender, Risk Tier
```

### SQL
```sql
-- SETUP (MySQL)
-- ─────────────────────────────────────────────
-- Note: Replace with your actual table creation or LOAD DATA syntax
-- LOAD DATA INFILE 'BankChurners.csv' INTO TABLE drivers FIELDS TERMINATED BY ',';

-- PostgreSQL
COPY bank_churners FROM 'BankChurners.csv' DELIMITER ',' CSV HEADER;
\i sql/churn_analysis.sql
```

```

---

## 📈 Dashboard Pages (Power BI)

1. **Churn Overview** — KPI cards, churn rate trend, active vs exited split
2. **Behavioral Insights** — Transaction trends, utilization patterns, inactivity bands
3. **Customer Segmentation** — Risk tiers by income, card type, age group
4. **Early Warning System** — Flagged high-risk existing customers for retention outreach

---

## 🧩 Business Impact

- **Reduced churn identification time** by moving from manual review to automated risk scoring
- **Prioritised 809 customers** for proactive retention outreach (vs. blanket campaigns)
- **Estimated $170K revenue protection** from annual fee recovery alone
- **Contacts paradox uncovered**: customers with 4+ contacts show higher churn — signals reactive (not proactive) service model

---

## 👤 Author

**Neela Vinay** — Data Analyst | Power BI Developer  
📧 [neelavinni9@gmail.com] | 🔗 [(https://www.linkedin.com/in/vinay-neela/)] 

---

*Dataset source: [Kaggle — Credit Card Customers](https://www.kaggle.com/datasets/sakshigoyal7/credit-card-customers) | MIT License*
