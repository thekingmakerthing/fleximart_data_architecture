# BITSOM_BA_25071004-fleximart-data-architecture
# FlexiMart Data Architecture Project

**Student Name:** Arbab Husain
**Student ID:** BITSOM_BA_25071004
**Email:** arbabhusain07@gmail.com
**Date:** 2026-01-08 

## Project Overview

This project implements a comprehensive data architecture solution for FlexiMart, an e-commerce company. The solution includes a complete ETL pipeline for ingesting raw CSV data into a relational database, NoSQL analysis for handling diverse product catalogs, and a data warehouse with star schema design for analytical reporting. The system addresses data quality issues, implements both relational and NoSQL database solutions, and provides OLAP capabilities for business intelligence.

## Repository Structure
```bash
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md
```

## Technologies Used

- **Python 3.x** - ETL pipeline implementation
- **pandas** - Data manipulation and transformation
- **mysql-connector-python** - MySQL database connectivity
- **MySQL 8.0** / **PostgreSQL 14** - Relational database management
- **MongoDB 6.0** - NoSQL database for flexible product catalog
- **SQL** - Data warehouse queries and analytics

## Setup Instructions

### Prerequisites

1. Python 3.8 or higher
2. MySQL 8.0 or PostgreSQL 14
3. MongoDB 6.0 (for Part 2)
4. Git (for version control)

### Database Setup

#### Create Databases

```bash
# Create MySQL databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"
```

#### Part 1 - ETL Pipeline

1. **Install Python dependencies:**
   ```bash
   cd part1-database-etl
   pip install -r requirements.txt
   # Or install globally:
   pip install pandas mysql-connector-python
   ```

2. **Update database configuration in `etl_pipeline.py`:**
   ```python
   DB_CONFIG = {
       'host': 'localhost',
       'database': 'fleximart',
       'user': 'root',
       'password': 'your_password'  # Update with your password
   }
   ```

3. **Run the ETL pipeline:**
   ```bash
   cd part1-database-etl
   python etl_pipeline.py
   ```
   
   This will:
   - Extract data from CSV files
   - Transform and clean the data
   - Load into the MySQL database
   - Generate `data_quality_report.txt`

4. **Run business queries:**
   ```bash
   mysql -u root -p fleximart < part1-database-etl/business_queries.sql
   ```

#### Part 2 - NoSQL (MongoDB)

1. **Start MongoDB service:**
   ```bash
   # On macOS with Homebrew:
   brew services start mongodb-community
   
   # On Linux:
   sudo systemctl start mongod
   ```

2. **Import product catalog (optional):**
   ```bash
   mongoimport --db fleximart --collection products --file part2-nosql/products_catalog.json --jsonArray
   ```

3. **Run MongoDB operations:**
   ```bash
   mongosh < part2-nosql/mongodb_operations.js
   ```

#### Part 3 - Data Warehouse

1. **Create data warehouse schema:**
   ```bash
   mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
   ```

2. **Load warehouse data:**
   ```bash
   mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
   ```

3. **Run analytics queries:**
   ```bash
   mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql
   ```

### Configuration

Update database credentials in:
- `part1-database-etl/etl_pipeline.py` - DB_CONFIG dictionary
- MongoDB connection (if using authentication in MongoDB scripts)

## Key Learnings

This project provided comprehensive exposure to modern data architecture practices:

1. **ETL Pipeline Design**: Learned to handle real-world data quality issues including duplicates, missing values, inconsistent formats, and date standardization. Implemented robust error handling and logging mechanisms.

2. **Database Design**: Understood the importance of normalization (3NF) for maintaining data integrity, and learned to document entity relationships and design decisions clearly.

3. **NoSQL vs RDBMS**: Gained insights into when to use MongoDB's flexible schema versus relational databases, understanding trade-offs in ACID properties, query capabilities, and scalability.

4. **Data Warehouse Design**: Learned star schema design principles, understanding the importance of grain selection, surrogate keys, and dimension hierarchies for enabling efficient OLAP queries.

5. **OLAP Analytics**: Implemented drill-down, roll-up, and segmentation queries using SQL window functions and aggregations, demonstrating understanding of analytical query patterns.

## Challenges Faced

1. **Data Quality Issues**: Handling inconsistent date formats, missing values, and duplicate records required careful transformation logic. Solution: Implemented multiple format parsers and intelligent default value assignment strategies.

2. **Schema Mapping**: Mapping raw sales data to normalized order/order_items structure required careful aggregation logic. Solution: Grouped sales by order_id and created separate order and order_item records.

3. **MongoDB Aggregation**: Calculating average ratings from nested review arrays required understanding MongoDB aggregation pipelines. Solution: Used $avg operator with array field notation.

4. **Star Schema Design**: Choosing appropriate grain and understanding when to use surrogate keys versus natural keys required research and analysis. Solution: Selected transaction line-item level grain for maximum flexibility and used integer surrogate keys for performance.

## File Descriptions

### Part 1 Files

- **`etl_pipeline.py`**: Complete ETL script with extraction, transformation, and loading logic. Handles all data quality issues specified in requirements.
- **`schema_documentation.md`**: Comprehensive database schema documentation with ER descriptions, normalization explanation, and sample data.
- **`business_queries.sql`**: Three complex SQL queries answering specific business questions with proper joins, aggregations, and window functions.
- **`data_quality_report.txt`**: Auto-generated report showing records processed, duplicates removed, missing values handled, and records loaded.

### Part 2 Files

- **`nosql_analysis.md`**: Complete analysis of RDBMS limitations, NoSQL benefits, and trade-offs for product catalog management.
- **`mongodb_operations.js`**: Five MongoDB operations demonstrating data loading, basic queries, aggregation, updates, and complex analysis.
- **`products_catalog.json`**: Sample product catalog with 10 products across Electronics and Clothing categories, including nested specs and reviews.

### Part 3 Files

- **`star_schema_design.md`**: Complete star schema documentation with fact table and dimension table descriptions, design decisions, and sample data flow.
- **`warehouse_schema.sql`**: SQL DDL for creating the star schema with proper foreign keys and indexes.
- **`warehouse_data.sql`**: Sample data with 30 dates, 15 products, 12 customers, and 40 sales transactions with realistic patterns.
- **`analytics_queries.sql`**: Three OLAP queries demonstrating drill-down analysis, product performance analysis, and customer segmentation.

