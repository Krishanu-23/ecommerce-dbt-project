# 🛒 E-commerce Data Pipeline (dbt + BigQuery Ready)

##   Overview

This project implements an end-to-end data pipeline for an **e-commerce analytics use case** using dbt.

It simulates a production-style workflow where raw transactional data is transformed into analytics-ready datasets through a layered modeling approach.

---

##   Architecture

Raw Data → Staging → Dimensions → Fact → Marts → Analytics

---

##   Project Structure
```text
models/ staging/ stg_orders.sql stg_order_items.sql schema.yml sources.yml

marts/ dim/ dim_users.sql dim_products.sql dim_date.sql schema.yml

fact/
  fact_order_items.sql
  mart_orders.sql
  mart_revenue_by_month.sql
  mart_top_products.sql
  schema.yml

analytics/
  analytics_revenue_trend.sql
```
---

## 📥 Data Sources

The project uses raw source tables representing transactional e-commerce data.  
These tables are treated as external sources and referenced in dbt using `source()`.

---

### `orders`

| column       | description                         |
|-------------|-------------------------------------|
| order_id    | Unique order identifier             |
| user_id     | Customer placing order              |
| order_date  | Date of the order                   |
| updated_at  | Last update timestamp for the order |

**Example:**

| order_id | user_id | order_date  | updated_at          |
|----------|--------|-------------|---------------------|
| 101      | 1      | 2024-01-01  | 2024-01-01 10:00:00 |

---

### `order_items`

| column         | description                             |
|---------------|-----------------------------------------|
| order_item_id | Unique item identifier                  |
| order_id      | Associated order                        |
| product_id    | Product purchased                       |
| quantity      | Number of units                         |
| unit_price    | Price per unit of the product           |
| updated_at    | Last update timestamp for the record    |

**Example:**

| order_item_id | order_id | product_id | quantity | unit_price | updated_at          |
|---------------|----------|------------|----------|------------|---------------------|
| 1             | 101      | 501        | 2        | 100.00     | 2024-01-01 10:05:00 |

---

### `users`

| column       | description                         |
|-------------|-------------------------------------|
| user_id     | Unique user identifier              |
| signup_date | User registration date              |
| country     | User location                       |
| updated_at  | Last profile update timestamp       |

**Example:**

| user_id | signup_date | country | updated_at          |
|--------|-------------|--------|---------------------|
| 1      | 2023-12-01  | India  | 2024-01-01 09:00:00 |

---

### `products`

| column        | description                         |
|--------------|-------------------------------------|
| product_id   | Unique product identifier           |
| product_name | Name of product                     |
| category     | Product category                    |
| price        | Default product price               |
| updated_at   | Last product update timestamp       |

**Example:**

| product_id | product_name | category | price | updated_at          |
|------------|-------------|----------|-------|---------------------|
| 501        | Shoes       | Fashion  | 100.00| 2024-01-01 08:00:00 |

---

## 🔄 Data Ingestion & Assumptions

This project focuses on the transformation layer using dbt.

The raw data layer is assumed to be populated by an upstream ingestion system (e.g., ETL pipelines, streaming jobs, or external data loaders).

- Raw tables (`orders`, `order_items`, `users`, `products`) are treated as source systems  
- Change data capture (CDC) logic (e.g., `updated_at` based filtering) is assumed to be handled upstream  
- dbt models operate on already available data and focus on transformations and analytics  

The `updated_at` field is included in the schema to support future enhancements such as incremental models.

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

##   Key Features

- Layered data modeling using dbt  
- Star schema design (fact + dimensions)  
- Aggregated marts for business use cases  
- Analytics layer using SQL window functions  
- Data quality testing (dbt tests)  
- Clean separation of concerns  

---

##   Data Model

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

##   Concepts Covered

- Dimensional modeling (star schema)  
- Grain definition and correctness  
- Aggregations and metric design  
- Window functions (`SUM OVER`, `LAG`)  
- Data quality testing (dbt tests)  
- Separation of concerns (model vs analytics)  

---
## 🔄 Slowly Changing Dimensions & Incremental Models

### SCD Type 2 (Snapshots)

The `users` dimension is modeled as a Slowly Changing Dimension Type 2 using dbt snapshots.

- Tracks historical changes in user attributes
- Maintains multiple records per user with validity periods
- Enables time-based analysis of user behavior

### SCD Type 1

Other dimensions such as `products` are treated as SCD Type 1, where only the latest state is maintained.

### Incremental Models

The `fact_order_items` model is designed with incremental loading in mind:

- Uses `updated_at` to identify new or changed records
- Avoids full table rebuilds for efficiency
- Supports scaling for larger datasets

This design aligns with production data engineering practices for handling large and evolving datasets.

##   How to Run

```bash
dbt run
dbt test
```


---

##   Testing

The project includes:

not_null tests

unique tests

relationships tests (fact ↔ dimensions)



---

##  Business Use Cases

Analyze revenue trends over time

Identify top-performing products

Track order volume and sales performance

Enable user-level analytics and segmentation



---

##  Work in Progress

BigQuery partitioning & clustering

Incremental models for large tables

Cost optimization strategies



---

##  Key Learnings

This project demonstrates:

Building an end-to-end data pipeline

Designing scalable data models

Writing analytical SQL for business insights

Structuring dbt projects for production use



---

##  Author

Krishanu Sengupta
