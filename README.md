# 🛍️ E-Commerce Fashion Sales Analysis using PostgreSQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

**Author:** Priya Maurya

> Turning 31,000+ raw fashion e-commerce transactions into business insights using only SQL.

---

## 📌 Project Overview

This project analyzes an e-commerce fashion sales dataset using **PostgreSQL** to uncover business patterns across **sales channels, customer demographics, product categories, geography, order status and order types**.

Transaction-level data is converted into business-facing KPIs using SQL aggregations, `CASE` expressions, window functions, date functions and conditional aggregation. Each analysis ends with key insights and an actionable business recommendation.

---

## 🎯 Business Objectives

- Measure revenue and order contribution by **sales channel**
- Compare purchasing patterns by **gender and age group**
- Identify high-performing **states and broad regions**
- Find the strongest **product categories** and most ordered **sizes**
- Measure **cancellation and return** incidence by channel
- Understand **monthly sales trends**, **B2B vs B2C** contribution and **delivery-status** distribution

---

## 🛠️ Technical Skills Demonstrated

| Skill | Where it's used |
|---|---|
| SQL Aggregations | `COUNT`, `SUM`, `AVG`, `MAX` across every analysis |
| Window Functions | Channel revenue share % and order-status distribution (`SUM() OVER ()`) |
| `CASE WHEN` | Age groups, regions, B2B/B2C labelling |
| Conditional Aggregation | Cancellation / return rate by channel |
| Date & Time Functions | `EXTRACT`, `TO_CHAR` for monthly trends |
| Customer Segmentation | Gender × Age Group spending segments |
| Business KPI Analysis | Executive summary view |
| Data Interpretation | Insight + recommendation for each question |

---

## 📊 Executive Summary (Overall KPIs)

| KPI | Value |
|---|---|
| Total Orders | **31,047** |
| Unique Customers | **28,437** |
| Gross Revenue | **₹21,176,377** |
| Average Order Value (AOV) | **₹682.07** |
| Delivered | 28,641 (92.25%) |
| Cancelled | 844 (2.72%) |
| Returned | 1,045 (3.37%) |
| Refunded | 517 (1.67%) |
| Cancellation + Return Rate | **6.08%** |

---

## 🔍 Business Questions & Key Findings

| # | Analysis | Key Finding |
|---|---|---|
| 1 | **Channel performance** | Amazon leads with **35.48%** of revenue; Amazon + Flipkart together contribute **57.08%** |
| 2 | **Gender analysis** | Women drive ~**64%** of revenue through higher order volume (21,553 orders); Men have a higher AOV (**₹801.94** vs ₹629.28) |
| 3 | **Age groups** | 26–35 (7,850 orders) and 36–45 (7,793 orders) are the strongest volume segments, each generating ~₹5.3M |
| 4 | **State-wise sales** | Maharashtra (₹2.98M) and Karnataka (₹2.65M) together generate ~₹5.63M; Uttar Pradesh ranks third |
| 5 | **Product categories** | **Set** is #1 in orders and revenue (₹10.5M) — more than 2× Kurta (₹4.96M) |
| 6 | **Cancellation & returns** | Amazon 6.26%, Flipkart 6.22%, Myntra 5.87% among major channels |
| 7 | **Monthly trends** | March is the peak month (2,819 orders, ~₹1.93M); sales decline gradually through the year |
| 8 | **B2B vs B2C** | B2C makes up ~**99.4%** of orders; B2B is only 186 orders (₹126K) with a similar AOV |
| 9 | **Product sizes** | M (5,479), L (5,144) and XL (4,437) are the most ordered sizes |
| 10 | **Older customers** | Customers 35–54 and 55+ both prefer **Sets**, with Kurta second for 35–54 |
| 11 | **Order status** | 92.25% of orders are delivered successfully |
| 12 | **Top segments (Gender × Age)** | Women 26–35 are the top revenue segment (₹3.48M); Men 36–45 have a notably higher AOV (₹799.13) |
| 13 | **Regional performance** | South India leads (12,111 orders, ₹7.96M), ~34% more orders than North India (9,043) |

---

## 💡 Business Recommendations

1. **Channels:** Strengthen relationships with Amazon, Myntra and Flipkart while testing growth on smaller platforms.
2. **Customers:** Run separate campaigns for men and women — grow men's purchase frequency, retain women's engagement.
3. **Targeting:** Focus acquisition on the 26–45 age group; offer premium recommendations to men aged 36–45.
4. **Inventory:** Prioritize stock for Sets and Kurtas, and for sizes M, L and XL — but validate against product margins.
5. **Geography:** Prioritize inventory and regional marketing in Maharashtra and Karnataka; explore expansion in North and West India.
6. **Quality:** Investigate causes of returns and cancellations (product quality, delivery delays, sizing issues).
7. **Seasonality:** Plan promotions around months with declining sales.

---

## 🧾 Sample SQL Queries

<details>
<summary><b>1. Channel revenue share (window function)</b></summary>

```sql
SELECT
    channel,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_revenue,
    ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (), 2) AS revenue_share_pct
FROM dataset
GROUP BY channel
ORDER BY total_revenue DESC;
```
</details>

<details>
<summary><b>2. Age-group segmentation (CASE WHEN)</b></summary>

```sql
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS age_group,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM dataset
GROUP BY age_group
ORDER BY total_orders DESC;
```
</details>

<details>
<summary><b>3. Cancellation & return rate (conditional aggregation)</b></summary>

```sql
SELECT
    channel,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN status = 'Returned'  THEN 1 ELSE 0 END) AS returned,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','Returned') THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS cancel_return_rate_pct
FROM dataset
GROUP BY channel
ORDER BY cancel_return_rate_pct DESC;
```
</details>

<details>
<summary><b>4. Monthly sales trend (date functions)</b></summary>

```sql
SELECT
    EXTRACT(MONTH FROM date) AS month_num,
    TO_CHAR(date, 'Mon YYYY') AS month,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_revenue
FROM dataset
GROUP BY month_num, month
ORDER BY month_num;
```
</details>

<details>
<summary><b>5. Order status distribution (window function)</b></summary>

```sql
SELECT
    status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM dataset
GROUP BY status
ORDER BY total_orders DESC;
```
</details>

<details>
<summary><b>6. Executive summary KPIs</b></summary>

```sql
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT cust_id) AS unique_customers,
    SUM(amount) AS gross_revenue_inr,
    ROUND(AVG(amount), 2) AS avg_order_value,
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN status = 'Returned'  THEN 1 ELSE 0 END) AS returned,
    SUM(CASE WHEN status = 'Refunded'  THEN 1 ELSE 0 END) AS refunded,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','Returned') THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2) AS cancel_return_rate_pct
FROM dataset;
```
</details>


---

## 📁 Suggested Repository Structure

```
├── README.md
├── sql/
│   └── ecommerce_analysis.sql
├── data/
│   └── dataset.csv            # or a link to the source dataset
├── images/
│   └── query_outputs/         # screenshots of results
└── E-Commerce_Sales_Analysis_Report.pdf
```

---

## ▶️ How to Run

1. Install **PostgreSQL** and **pgAdmin**.
2. Create a database and import the dataset into a table named `dataset`.
3. Open `sql/ecommerce_analysis.sql` in the pgAdmin Query Tool.
4. Run each query to reproduce the results shown in the report.

---

## 🚀 Future Improvements

- Clean and standardize channel names
- Add profit / margin analysis
- Build a Power BI or Tableau dashboard on top of these queries
- Add customer-level analysis (repeat purchase rate, RFM segmentation)

---

## 👩‍💻 Author

**Priya Maurya**
 Data Analyst | SQL • PostgreSQL

🔗 LinkedIn: *[www.linkedin.com/in/priya-maurya-857563328]*
📂 GitHub: *[https://github.com/priyamaurya-web]*


