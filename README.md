Perfect — let’s reset and give you a **clean, consistent, interview-ready README** with **NO contradictions**.

This version strictly follows your final design:

```text
FACT = immutable (append-only)
NO updates
NO merge
ONLY insert new primary keys
```

---

# 📘 DATA ENGINEERING PIPELINE (DBT + SQL)

---

# 🏗️ ARCHITECTURE OVERVIEW

```text
SOURCE (OLTP) → RAW → STAGING → FACT → DIMENSIONS
```

---

# 🧠 DESIGN PRINCIPLES

```text
✔ Separation of concerns across layers
✔ Idempotent transformations
✔ Incremental processing where needed
✔ Fact tables are immutable (append-only)
✔ Dimensions handle attribute changes
```

---

# 📦 1. RAW LAYER

---

## 🎯 Purpose

```text
Capture data from source systems incrementally
```

---

## ⚙️ Logic

```text
✔ Use updated_at for change detection
✔ Load only new/updated records
✔ Append-only (no deletes/updates)
✔ Store ingestion metadata (optional)
```

---

## 🧠 Behavior

```text
✔ Maintains full history
✔ Multiple rows per primary key possible
```

---

## 🧠 Key Concept

```text
RAW = historical source of truth
```

---

# 🧼 2. STAGING LAYER (dbt models)

---

## 🎯 Purpose

```text
Clean, standardize, and deduplicate raw data
```

---

## ⚙️ Logic

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY primary_key
               ORDER BY updated_at DESC
           ) AS rn
    FROM raw_table
)
WHERE rn = 1
```

---

## 🧠 Behavior

```text
✔ One row per primary key
✔ Latest version only
✔ Clean dataset
✔ Full refresh (table materialization)
```

---

## 🧠 Key Concept

```text
STAGING = latest snapshot (not historical)
```

---

# 📊 3. FACT TABLE (IMMUTABLE)

---

## 🎯 Purpose

```text
Store business events and measurable metrics
```

---

## 🧠 Structure

```text
Fact = Grain + Foreign Keys + Metrics
```

Example:

```text
Grain: order_items_id
Keys: order_id, product_id, user_id
Metrics: quantity, revenue
```

---

## ⚙️ Logic

```text
✔ Join staging tables
✔ Compute metrics
✔ Insert only new records
✔ No updates to existing rows
```

---

## 🔁 Incremental Logic (IMPORTANT)

```sql
-- Insert only new primary keys
SELECT ...
FROM stg_order_items s
LEFT JOIN fact_order_items f
  ON s.order_items_id = f.order_items_id
WHERE f.order_items_id IS NULL
```

---

## 🧠 Behavior

```text
✔ Append-only
✔ Immutable
✔ Primary key driven
✔ No updates, no deletes
```

---

## 🧠 Why no updated_at here?

```text
✔ Deduplication already handled in staging
✔ Fact represents events, not changing attributes
✔ Incremental driven by primary key existence
```

---

## 🧠 Key Concept

```text
FACT = historical events (do not change)
```

---

# 📦 4. DIMENSIONS

---

# 🟢 SCD1 (Overwrite)

---

## 🎯 Purpose

```text
Store latest attribute values
```

---

## ⚙️ Logic

```sql
SELECT * FROM stg_table
```

---

## 🧠 Behavior

```text
✔ Latest state only
✔ Overwrites previous values
✔ No history tracking
```

---

# 🔵 SCD2 (History Tracking)

---

## 🎯 Purpose

```text
Track attribute changes over time
```

---

## ⚙️ Columns

```text
✔ valid_from
✔ valid_to
✔ is_current
```

---

## 🧠 Behavior

```text
✔ Insert new row when attribute changes
✔ Preserve old rows (history)
✔ Mark old rows as inactive
```

---

## 🧠 Example

| user_id | country | valid_from | valid_to | is_current |
| ------- | ------- | ---------- | -------- | ---------- |
| 1       | India   | t1         | t2       | false      |
| 1       | US      | t2         | NULL     | true       |

---

## 🧠 Key Concept

```text
DIMENSIONS = where updates and history are handled
```

---

# 🔁 INCREMENTAL STRATEGY SUMMARY

---

| Layer      | Strategy                      |
| ---------- | ----------------------------- |
| RAW        | updated_at based incremental  |
| STAGING    | full refresh (dedup)          |
| FACT       | primary key based incremental |
| DIM (SCD1) | full refresh                  |
| DIM (SCD2) | insert new versions           |

---

# 🧠 DBT CONCEPTS

---

# 🔹 source()

```sql
{{ source('raw', 'raw_orders') }}
```

```text
Refers to external/raw tables
```

---

# 🔹 ref()

```sql
{{ ref('stg_orders') }}
```

```text
Refers to dbt models and builds dependency graph
```

---

# 🔹 materializations

```text
table → full rebuild
view → logical view
incremental → partial load
```

---

# 🔹 is_incremental()

```sql
{% if is_incremental() %}
   -- incremental logic
{% endif %}
```

---

# 🔹 {{ this }}

```text
Refers to current model table
```

---

# ⚙️ DBT COMMANDS

---

## ▶️ Run pipeline

```bash
dbt run
```

---

## 🎯 Run specific model

```bash
dbt run --select model_name
```

---

## 🔍 Preview data

```bash
dbt show --select model_name
```

---

## 📋 List models

```bash
dbt ls
```

---

## 🔄 Full refresh

```bash
dbt run --full-refresh
```

---

# 🔄 DBT EXECUTION FLOW

```text
1. Read SQL models
2. Resolve source() and ref()
3. Build DAG (dependencies)
4. Execute in correct order
```

---

# 🧠 DAG EXAMPLE

```text
raw_orders
   ↓
stg_orders
   ↓
fact_order_items
   ↓
dim tables
```

---

# 🧠 FINAL MENTAL MODEL

```text
RAW → capture history
STAGING → clean + deduplicate
FACT → store immutable events
DIM → store attributes (handle changes)
```

---

# 🔥 ONE-LINE SUMMARY

```text
Facts are append-only events; dimensions handle change and history
```

---

# 🚀 PROJECT STATUS

```text
✔ RAW incremental ingestion
✔ STAGING deduplication
✔ FACT append-only incremental
✔ DBT pipeline setup
✔ DAG-based execution
```

---

If you want next, I can:

```text
✔ Add SCD2 implementation section (proper, complete version)
✔ Add dbt tests + documentation
✔ Help you structure this into a GitHub-ready repo
```

Just tell me 👍
