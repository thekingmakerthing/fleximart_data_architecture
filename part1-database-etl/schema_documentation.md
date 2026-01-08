# FlexiMart Database Schema Documentation

## Entity-Relationship Description

### ENTITY: customers

**Purpose:** Stores customer information for FlexiMart e-commerce platform.

**Attributes:**
- `customer_id`: Unique identifier for each customer (Primary Key, Auto-increment, Integer)
- `first_name`: Customer's first name (VARCHAR(50), NOT NULL)
- `last_name`: Customer's last name (VARCHAR(50), NOT NULL)
- `email`: Customer's email address (VARCHAR(100), UNIQUE, NOT NULL) - Used for authentication and communication
- `phone`: Customer's contact phone number (VARCHAR(20), Optional) - Standardized format
- `city`: City where customer is located (VARCHAR(50), Optional) - Used for regional analysis
- `registration_date`: Date when customer registered with FlexiMart (DATE, Optional) - Used for customer acquisition analysis

**Relationships:**
- One customer can place **MANY orders** (1:M relationship with orders table)
- Connected via `customer_id` foreign key in orders table

**Business Rules:**
- Each customer must have a unique email address
- Email is mandatory for account creation
- Phone number is optional but standardized when provided

---

### ENTITY: products

**Purpose:** Stores product catalog information including pricing and inventory.

**Attributes:**
- `product_id`: Unique identifier for each product (Primary Key, Auto-increment, Integer)
- `product_name`: Name of the product (VARCHAR(100), NOT NULL)
- `category`: Product category classification (VARCHAR(50), NOT NULL) - Standardized values like "Electronics", "Clothing"
- `price`: Current selling price of the product (DECIMAL(10,2), NOT NULL) - Stored with 2 decimal places
- `stock_quantity`: Available inventory count (INT, DEFAULT 0) - Used for inventory management

**Relationships:**
- One product can be ordered in **MANY order items** (1:M relationship with order_items table)
- Connected via `product_id` foreign key in order_items table

**Business Rules:**
- Each product must have a price
- Stock quantity defaults to 0 if not specified
- Products can belong to different categories for organizational purposes

---

### ENTITY: orders

**Purpose:** Stores order header information for customer purchases.

**Attributes:**
- `order_id`: Unique identifier for each order (Primary Key, Auto-increment, Integer)
- `customer_id`: Reference to the customer who placed the order (INT, NOT NULL, Foreign Key → customers.customer_id)
- `order_date`: Date when the order was placed (DATE, NOT NULL) - Used for time-based analysis
- `total_amount`: Total value of the order in rupees (DECIMAL(10,2), NOT NULL) - Sum of all order items
- `status`: Current status of the order (VARCHAR(20), DEFAULT 'Pending') - Values like 'Pending', 'Completed', 'Cancelled'

**Relationships:**
- One order belongs to **ONE customer** (M:1 relationship with customers table)
- One order contains **MANY order items** (1:M relationship with order_items table)
- Connected via `order_id` foreign key in order_items table

**Business Rules:**
- Each order must be associated with a valid customer
- Order date is mandatory for tracking
- Total amount is calculated from order items

---

### ENTITY: order_items

**Purpose:** Stores individual line items within each order (details of products purchased).

**Attributes:**
- `order_item_id`: Unique identifier for each order line item (Primary Key, Auto-increment, Integer)
- `order_id`: Reference to the parent order (INT, NOT NULL, Foreign Key → orders.order_id)
- `product_id`: Reference to the product ordered (INT, NOT NULL, Foreign Key → products.product_id)
- `quantity`: Number of units ordered for this product (INT, NOT NULL) - Must be positive
- `unit_price`: Price per unit at time of purchase (DECIMAL(10,2), NOT NULL) - Historical price snapshot
- `subtotal`: Total amount for this line item (DECIMAL(10,2), NOT NULL) - Calculated as quantity × unit_price

**Relationships:**
- One order item belongs to **ONE order** (M:1 relationship with orders table)
- One order item references **ONE product** (M:1 relationship with products table)

**Business Rules:**
- Each order item must be part of a valid order
- Each order item must reference a valid product
- Unit price is stored to preserve historical pricing
- Subtotal should equal quantity × unit_price

---

## Normalization Explanation

The FlexiMart database design follows **Third Normal Form (3NF)**, which ensures data integrity and eliminates redundancy. This design is normalized to 3NF based on the following principles:

### Functional Dependencies Identified:

1. **customers table:**
   - `customer_id` → `first_name`, `last_name`, `email`, `phone`, `city`, `registration_date`
   - `email` → `customer_id` (unique constraint)

2. **products table:**
   - `product_id` → `product_name`, `category`, `price`, `stock_quantity`

3. **orders table:**
   - `order_id` → `customer_id`, `order_date`, `total_amount`, `status`
   - `order_id` → `customer_id` (customer can be derived from order)

4. **order_items table:**
   - `order_item_id` → `order_id`, `product_id`, `quantity`, `unit_price`, `subtotal`
   - `order_id`, `product_id` → `quantity`, `unit_price`, `subtotal` (composite key dependency)

### Why This Design is in 3NF:

**First Normal Form (1NF):** All tables have atomic values (no repeating groups or arrays). Each attribute contains a single value, and each row is unique.

**Second Normal Form (2NF):** All non-key attributes are fully functionally dependent on the primary key. In `order_items`, attributes like `quantity` and `unit_price` depend on the combination of `order_id` and `product_id`, which is why we have a separate table rather than embedding these in orders.

**Third Normal Form (3NF):** No transitive dependencies exist. All non-key attributes depend only on the primary key, not on other non-key attributes. For example:
- In the original design, if we had stored `customer_name` directly in orders, we would have a transitive dependency (order_id → customer_id → customer_name), violating 3NF. By separating customers into their own table, we eliminate this.
- `unit_price` in order_items is intentionally denormalized slightly (could be derived from products.price) to preserve historical pricing, but this is a business requirement, not a normalization issue.

### Avoiding Anomalies:

**Update Anomalies:** If customer information was stored directly in orders, updating a customer's email would require updating multiple order records. With normalized design, we update once in the customers table.

**Insert Anomalies:** We can add new products without needing an order first, and add new customers without requiring a purchase.

**Delete Anomalies:** Deleting an order doesn't delete the customer or product records, maintaining referential integrity through foreign key constraints.

This normalized structure supports efficient querying, data integrity, and scalability while maintaining historical accuracy (e.g., product prices at time of purchase).

---

## Sample Data Representation

### customers Table

| customer_id | first_name | last_name | email | phone | city | registration_date |
|-------------|------------|-----------|-------|-------|------|-------------------|
| 1 | Rahul | Sharma | rahul.sharma@gmail.com | +91-9876543210 | Bangalore | 2023-01-15 |
| 2 | Priya | Patel | priya.patel@yahoo.com | +91-9988776655 | Mumbai | 2023-02-20 |
| 3 | Amit | Kumar | amit.kumar@fleximart.com | +91-9765432109 | Delhi | 2023-03-10 |

### products Table

| product_id | product_name | category | price | stock_quantity |
|------------|--------------|----------|-------|----------------|
| 1 | Laptop Pro 15 | Electronics | 45000.00 | 50 |
| 2 | Wireless Mouse | Electronics | 899.00 | 200 |
| 3 | Running Shoes | Clothing | 3500.00 | 100 |

### orders Table

| order_id | customer_id | order_date | total_amount | status |
|----------|-------------|------------|--------------|--------|
| 1 | 1 | 2024-01-15 | 45000.00 | Completed |
| 2 | 2 | 2024-01-16 | 1798.00 | Completed |
| 3 | 1 | 2024-01-17 | 3500.00 | Completed |

### order_items Table

| order_item_id | order_id | product_id | quantity | unit_price | subtotal |
|---------------|----------|------------|----------|------------|----------|
| 1 | 1 | 1 | 1 | 45000.00 | 45000.00 |
| 2 | 2 | 2 | 2 | 899.00 | 1798.00 |
| 3 | 3 | 3 | 1 | 3500.00 | 3500.00 |

