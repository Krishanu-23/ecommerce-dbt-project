# 🛒 E-commerce Data Pipeline (dbt + BigQuery Ready)

## 📌 Overview

This project implements an end-to-end data pipeline for an **e-commerce analytics use case** using dbt.

It simulates a production-style workflow where raw transactional data is transformed into analytics-ready datasets through a layered modeling approach.

---

## 🏗 Architecture

Raw Data → Staging → Dimensions → Fact → Marts → Analytics

---

## 📂 Project Structure

models/ staging/ stg_orders.sql stg_order_items.sql schema.yml

marts/ dim/ dim_users.sql dim_products.sql dim_date.sql schema.yml

fact/
  fact_order_items.sql
  mart_orders.sql
  mart_revenue_by_month.sql
  mart_top_products.sql
  schema.yml

analytics/
  analytics_revenue_trend.sql

---

## 🔹 Staging Layer

The staging layer standardizes and cleans raw source data.

- Renames columns for consistency  
- Handles basic transformations  
- Serves as the foundation for downstream models  

Example:
- `stg_orders`
- `stg_order_items`

---

## ⚙️ Key Features

- Layered data modeling using dbt  
- Star schema design (fact + dimensions)  
- Aggregated marts for business use cases  
- Analytics layer using SQL window functions  
- Data quality testing (dbt tests)  
- Clean separation of concerns  

---

## 🧱 Data Model

### 🔹 Fact Table
- `fact_order_items`  
  - Grain: **1 row per order_item**  
  - Contains transactional data enriched with keys  

---

### 🔹 Dimension Tables
- `dim_users`  
- `dim_products`  
- `dim_date`  

---

### 🔹 Marts

#### `mart_orders`
- Grain: **1 row per order_item**  
- Fully enriched dataset (joins fact + dimensions)  
- Acts as the **core analytical table**  

#### `mart_revenue_by_month`
- Grain: **1 row per (year, month)**  
- Aggregated revenue metrics  

#### `mart_top_products`
- Grain: **1 row per product**  
- Product-level performance metrics  

---

### 🔹 Analytics Layer

#### `analytics_revenue_trend`
- Running (cumulative) revenue  
- Month-over-month growth using window functions  

---

## 🧠 Concepts Covered

- Dimensional modeling (star schema)  
- Grain definition and correctness  
- Aggregations and metric design  
- Window functions (`SUM OVER`, `LAG`)  
- Data quality testing (dbt tests)  
- Separation of concerns (model vs analytics)  

---

## 🚀 How to Run

```bash
dbt run
dbt test


---

🧪 Testing

The project includes:

not_null tests

unique tests

relationships tests (fact ↔ dimensions)



---

📊 Business Use Cases

Analyze revenue trends over time

Identify top-performing products

Track order volume and sales performance

Enable user-level analytics and segmentation



---

🚧 Work in Progress

BigQuery partitioning & clustering

Incremental models for large tables

Cost optimization strategies



---

🔮 Future Enhancements

Streaming pipeline (clickstream data)

Integration with Spark / Dataflow

Real-time analytics

Dashboarding layer (Looker / Tableau)



---

🧠 Key Learnings

This project demonstrates:

Building an end-to-end data pipeline

Designing scalable data models

Writing analytical SQL for business insights

Structuring dbt projects for production use



---

👨‍💻 Author

Krishanu Sengupta

