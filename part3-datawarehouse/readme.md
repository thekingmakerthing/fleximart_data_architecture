# Part 3: Data Warehouse and Analytics

## Overview

This part implements a star schema data warehouse for FlexiMart's analytical reporting needs, including OLAP queries for business intelligence.

## Files

- **`star_schema_design.md`**: Complete star schema design documentation
- **`warehouse_schema.sql`**: Data warehouse schema (fact table + 3 dimension tables)
- **`warehouse_data.sql`**: Sample data (30 dates, 15 products, 12 customers, 40 sales)
- **`analytics_queries.sql`**: Three OLAP analytical queries

## Setup

1. Create data warehouse database:
   ```bash
   mysql -u root -p -e "CREATE DATABASE fleximart_dw;"
   ```

2. Create schema:
   ```bash
   mysql -u root -p fleximart_dw < warehouse_schema.sql
   ```

3. Load data:
   ```bash
   mysql -u root -p fleximart_dw < warehouse_data.sql
   ```

4. Run analytics queries:
   ```bash
   mysql -u root -p fleximart_dw < analytics_queries.sql
   ```

## Star Schema

- **Fact Table**: `fact_sales` (transaction line-item level)
- **Dimensions**: `dim_date`, `dim_product`, `dim_customer`

## Analytics Queries

1. **Monthly Sales Drill-Down**: Year → Quarter → Month analysis for 2024
2. **Product Performance**: Top 10 products by revenue with percentage contribution
3. **Customer Segmentation**: High/Medium/Low value customer analysis

