# Part 1: Database Design and ETL Pipeline

## Overview

This part implements a complete ETL pipeline that extracts, transforms, and loads customer, product, and sales data from CSV files into a MySQL database. It handles various data quality issues and generates comprehensive business insights.

## Files

- **`etl_pipeline.py`**: Complete ETL script with data quality handling
- **`schema_documentation.md`**: Database schema documentation with ER diagrams and normalization explanation
- **`business_queries.sql`**: Three complex SQL queries answering business questions
- **`data_quality_report.txt`**: Generated report (created after running ETL)

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Update database credentials in `etl_pipeline.py`

3. Run ETL pipeline:
   ```bash
   python etl_pipeline.py
   ```

4. Execute business queries:
   ```bash
   mysql -u root -p fleximart < business_queries.sql
   ```

## Data Quality Issues Handled

- Duplicate records removal
- Missing value handling (emails, prices, stock, dates)
- Phone format standardization (+91-XXXXXXXXXX)
- Category name standardization (Electronics, Clothing, etc.)
- Date format standardization (YYYY-MM-DD)

