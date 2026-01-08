# FlexiMart Data Warehouse - Star Schema Design Documentation

## Part 3.1: Star Schema Design Documentation (10 marks)

### Section 1: Schema Overview (4 marks)

#### FACT TABLE: fact_sales

**Grain:** One row per product per order line item (transaction line-item level)

**Business Process:** Sales transactions - captures individual product sales within orders

**Measures (Numeric Facts):**
- `quantity_sold`: Number of units sold for this product in this order item (INT, NOT NULL)
- `unit_price`: Price per unit at the time of sale (DECIMAL(10,2), NOT NULL) - Historical price snapshot
- `discount_amount`: Discount applied to this order item (DECIMAL(10,2), DEFAULT 0) - Can be negative for markups
- `total_amount`: Final amount for this order item (DECIMAL(10,2), NOT NULL) - Calculated as (quantity × unit_price - discount_amount)

**Foreign Keys:**
- `date_key`: Surrogate key linking to dim_date (INT, NOT NULL) - Enables time-based analysis
- `product_key`: Surrogate key linking to dim_product (INT, NOT NULL) - Enables product analysis
- `customer_key`: Surrogate key linking to dim_customer (INT, NOT NULL) - Enables customer analysis

**Primary Key:** `sale_key` (INT, AUTO_INCREMENT) - Unique identifier for each fact row

**Type of Fact Table:** Transaction fact table - captures atomic-level sales events

---

#### DIMENSION TABLE: dim_date

**Purpose:** Date dimension for time-based analysis - enables drill-down from year to quarter to month to day

**Type:** Conformed dimension - can be shared across multiple fact tables

**Attributes:**
- `date_key` (PK): Surrogate key (INTEGER, format: YYYYMMDD, e.g., 20240115) - Primary key for efficient joins
- `full_date`: Actual date value (DATE, NOT NULL) - Used for date calculations
- `day_of_week`: Day name (VARCHAR(10), e.g., "Monday", "Tuesday") - Used for day-of-week analysis
- `day_of_month`: Day number within month (INT, 1-31) - Used for monthly patterns
- `month`: Month number (INT, 1-12) - Used for month comparisons
- `month_name`: Month name (VARCHAR(10), e.g., "January", "February") - Used for reporting
- `quarter`: Quarter identifier (VARCHAR(2), e.g., "Q1", "Q2", "Q3", "Q4") - Used for quarterly analysis
- `year`: Year value (INT, e.g., 2023, 2024) - Used for year-over-year analysis
- `is_weekend`: Boolean flag (BOOLEAN, TRUE/FALSE) - Used for weekend vs weekday analysis

**Additional Attributes for Enhanced Analysis:**
- Week number (1-52/53)
- Fiscal year and quarter (if applicable)
- Holiday flags
- Season indicators

---

#### DIMENSION TABLE: dim_product

**Purpose:** Product dimension containing product attributes - enables product-based analysis and filtering

**Type:** Slowly Changing Dimension (SCD) Type 2 - Historical tracking of product changes

**Attributes:**
- `product_key` (PK): Surrogate key (INT, AUTO_INCREMENT) - Primary key for efficient joins
- `product_id`: Natural key from source system (VARCHAR(20)) - Links to operational product ID
- `product_name`: Name of the product (VARCHAR(100)) - Used for product identification
- `category`: Product category classification (VARCHAR(50)) - Used for category-level analysis
- `subcategory`: Product subcategory (VARCHAR(50), Optional) - Enables drill-down within categories
- `unit_price`: Current standard unit price (DECIMAL(10,2)) - Reference price (actual sale price in fact table)

**Additional Attributes for Enhanced Analysis:**
- Product brand
- Supplier information
- Product lifecycle status (Active/Discontinued)
- Launch date
- Product attributes specific to category

---

#### DIMENSION TABLE: dim_customer

**Purpose:** Customer dimension containing customer attributes - enables customer segmentation and analysis

**Type:** Slowly Changing Dimension (SCD) Type 1 - Current customer information only

**Attributes:**
- `customer_key` (PK): Surrogate key (INT, AUTO_INCREMENT) - Primary key for efficient joins
- `customer_id`: Natural key from source system (VARCHAR(20)) - Links to operational customer ID
- `customer_name`: Full name of customer (VARCHAR(100)) - Concatenated from first_name and last_name
- `city`: City where customer is located (VARCHAR(50), Optional) - Used for geographic analysis
- `state`: State/region where customer is located (VARCHAR(50), Optional) - Used for regional analysis
- `customer_segment`: Customer segmentation classification (VARCHAR(20), Optional) - Values like "High Value", "Medium Value", "Low Value" - Used for segmentation analysis

**Additional Attributes for Enhanced Analysis:**
- Registration date
- Customer type (Individual/Corporate)
- Demographic information
- Lifetime value tier

---

### Section 2: Design Decisions (3 marks - 150 words)

The star schema design uses **transaction line-item level granularity** (one row per product per order) to enable maximum analytical flexibility. This granularity allows drill-down to individual product sales while supporting roll-up aggregations to order level, customer level, product level, or time level. By storing individual line items rather than aggregated order totals, we preserve the ability to analyze product performance within orders, identify cross-selling patterns, and calculate product-level metrics.

**Surrogate keys** are used instead of natural keys (like customer_id, product_id, date) for several reasons: (1) Performance - integer keys enable faster joins and indexing compared to string-based natural keys, (2) Independence - changes to source system identifiers don't break data warehouse relationships, (3) Historical tracking - surrogate keys combined with SCD Type 2 dimensions preserve historical product and customer attributes, (4) Integration - when combining data from multiple source systems, surrogate keys provide a common integration point without conflicts.

This design supports **drill-down and roll-up operations** through the hierarchical nature of dimensions. For example, date dimension allows drilling from Year → Quarter → Month → Day. Product dimension enables rolling up from individual products to subcategories to categories. Customer dimension supports geographic roll-ups from individual customers to cities to states. The fact table's granularity ensures that aggregations at any level are possible without losing detail.

---

### Section 3: Sample Data Flow (3 marks)

**Source Transaction:**
```
Order #101, Customer "John Doe" (ID: C001), Product "Laptop Pro 15" (ID: P001), 
Quantity: 2, Unit Price: ₹50,000, Order Date: 2024-01-15
```

**Becomes in Data Warehouse:**

**fact_sales:**
```
{
  sale_key: 1001,
  date_key: 20240115,
  product_key: 5,
  customer_key: 12,
  quantity_sold: 2,
  unit_price: 50000.00,
  discount_amount: 0.00,
  total_amount: 100000.00
}
```

**dim_date:**
```
{
  date_key: 20240115,
  full_date: '2024-01-15',
  day_of_week: 'Monday',
  day_of_month: 15,
  month: 1,
  month_name: 'January',
  quarter: 'Q1',
  year: 2024,
  is_weekend: FALSE
}
```

**dim_product:**
```
{
  product_key: 5,
  product_id: 'P001',
  product_name: 'Laptop Pro 15',
  category: 'Electronics',
  subcategory: 'Computers',
  unit_price: 50000.00
}
```

**dim_customer:**
```
{
  customer_key: 12,
  customer_id: 'C001',
  customer_name: 'John Doe',
  city: 'Mumbai',
  state: 'Maharashtra',
  customer_segment: 'High Value'
}
```

**Transformation Process:**
1. Source system provides order #101 with customer ID "C001", product ID "P001", and date "2024-01-15"
2. ETL process looks up or creates dimension records:
   - `dim_date`: Finds existing date_key 20240115 for 2024-01-15
   - `dim_product`: Finds product_key 5 for product_id "P001"
   - `dim_customer`: Finds customer_key 12 for customer_id "C001"
3. ETL process creates fact record with surrogate keys instead of natural keys
4. Fact record stores measures (quantity, price, amount) at the transaction line-item level
5. Analytical queries can now join fact table to dimensions using surrogate keys for efficient analysis

**Benefits of This Structure:**
- Fast queries: Integer surrogate keys enable efficient joins
- Flexible analysis: Can aggregate by any dimension attribute (year, quarter, category, city, etc.)
- Historical preservation: Product price changes don't affect historical sales records
- Scalability: Star schema handles large fact tables with many dimension attributes efficiently

