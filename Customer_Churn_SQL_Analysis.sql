-- ============================================================
-- Credit Card Customer Churn Analysis — SQL Script
-- Dataset: BankChurners (10,127 customers | Harbor Trust Bank)
-- ============================================================

use credit_card_customer_churn;

-- 1. CHURN OVERVIEW — Baseline Metrics

SELECT
    Attrition_Flag,
    COUNT(*)                                                          AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                AS pct_of_total
FROM bankchurners
GROUP BY Attrition_Flag;
-- Result: 16.07% churn rate (1,627 / 10,127)


-- 2. BEHAVIOURAL DELTA — Churned vs Existing

SELECT
    Attrition_Flag,
    ROUND(AVG(Total_Trans_Ct), 1)            AS avg_transaction_count,
    ROUND(AVG(Total_Trans_Amt), 0)           AS avg_transaction_amount,
    ROUND(AVG(Avg_Utilization_Ratio), 3)     AS avg_utilization_ratio,
    ROUND(AVG(Months_Inactive_12_mon), 2)    AS avg_inactive_months,
    ROUND(AVG(Contacts_Count_12_mon), 2)     AS avg_contacts,
    ROUND(AVG(Total_Relationship_Count), 2)  AS avg_products_held
FROM bankchurners
GROUP BY Attrition_Flag;
/*
Key Findings:
- Churned: 44.9 avg transactions vs 68.7 existing — 35% fewer
- Churned: $3,095 avg spend vs $4,655 existing — 34% lower
- Utilization: 0.162 churned vs 0.296 existing — 45% lower engagement
- Products held: 3.28 churned vs 3.91 existing
*/
 

-- 3. CHURN RATE BY CARD CATEGORY

SELECT
    Card_Category,
    COUNT(*)                                                          AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM bankchurners
GROUP BY Card_Category
ORDER BY churn_rate_pct DESC;
-- Platinum: 25.0% | Gold: 18.1% | Blue: 16.1% | Silver: 14.8% 

-- 4. HIGH-RISK CUSTOMER SEGMENT
--    Criteria: Low transactions + High inactivity

SELECT
    CASE
        WHEN Total_Trans_Ct < 40 AND Months_Inactive_12_mon >= 3 THEN 'High-Risk'
        WHEN Total_Trans_Ct < 60 AND Months_Inactive_12_mon >= 2 THEN 'Medium-Risk'
        ELSE 'Low-Risk'
    END                                                               AS risk_segment,
    COUNT(*)                                                          AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM bankchurners
GROUP BY risk_segment
ORDER BY churn_rate_pct DESC;
-- High-Risk: 809 customers, 38.4% churn rate (2.4x the overall baseline of 16.1%)


-- 5. CHURN BY INCOME CATEGORY

SELECT
    Income_Category,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM bankchurners
GROUP BY Income_Category
ORDER BY churn_rate_pct DESC;


-- 6. INACTIVITY BAND CHURN ANALYSIS

SELECT
    Months_Inactive_12_mon,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM bankchurners
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon;


-- 7. CONTACTS PARADOX
--    More contact = higher churn (distress signal)

SELECT
    Contacts_Count_12_mon,
    COUNT(*)                                                          AS total,
    ROUND(
        SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM bankchurners
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon;


-- 8. REVENUE AT RISK ESTIMATE

SELECT
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN Total_Trans_Amt ELSE 0 END)
        AS lost_transaction_volume,
    COUNT(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 END) * 95
        AS estimated_annual_fee_loss,
    ROUND(AVG(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN Total_Trans_Amt END), 0)
        AS avg_churned_customer_spend
FROM bankchurners;


-- 9. CHURN PREDICTION FLAG — Early Warning Score

SELECT
    CLIENTNUM,
    Card_Category,
    Total_Trans_Ct,
    Months_Inactive_12_mon,
    Contacts_Count_12_mon,
    Avg_Utilization_Ratio,
    (
        CASE WHEN Total_Trans_Ct           < 40  THEN 1 ELSE 0 END +
        CASE WHEN Months_Inactive_12_mon   >= 3  THEN 1 ELSE 0 END +
        CASE WHEN Avg_Utilization_Ratio    < 0.1 THEN 1 ELSE 0 END +
        CASE WHEN Contacts_Count_12_mon    >= 4  THEN 1 ELSE 0 END +
        CASE WHEN Total_Relationship_Count <= 2  THEN 1 ELSE 0 END
    )                                                                 AS churn_risk_score,
    CASE
        WHEN (
            CASE WHEN Total_Trans_Ct           < 40  THEN 1 ELSE 0 END +
            CASE WHEN Months_Inactive_12_mon   >= 3  THEN 1 ELSE 0 END +
            CASE WHEN Avg_Utilization_Ratio    < 0.1 THEN 1 ELSE 0 END +
            CASE WHEN Contacts_Count_12_mon    >= 4  THEN 1 ELSE 0 END +
            CASE WHEN Total_Relationship_Count <= 2  THEN 1 ELSE 0 END
        ) >= 3 THEN 'HIGH'
        WHEN (
            CASE WHEN Total_Trans_Ct           < 40  THEN 1 ELSE 0 END +
            CASE WHEN Months_Inactive_12_mon   >= 3  THEN 1 ELSE 0 END +
            CASE WHEN Avg_Utilization_Ratio    < 0.1 THEN 1 ELSE 0 END +
            CASE WHEN Contacts_Count_12_mon    >= 4  THEN 1 ELSE 0 END +
            CASE WHEN Total_Relationship_Count <= 2  THEN 1 ELSE 0 END
        ) = 2 THEN 'MEDIUM'
        ELSE 'LOW'
    END                                                               AS predicted_churn_risk
FROM bankchurners
WHERE Attrition_Flag = 'Existing Customer'
ORDER BY churn_risk_score DESC
LIMIT 100;
-- Export this list to feed retention campaign outreach