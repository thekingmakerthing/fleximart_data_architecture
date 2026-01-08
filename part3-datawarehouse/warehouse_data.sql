-- ============================================================================
-- FlexiMart Data Warehouse Sample Data
-- Part 3.2: Star Schema Implementation - Data Loading
-- Database: fleximart_dw
-- ============================================================================

USE fleximart_dw;

-- Clear existing data (for testing)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE fact_sales;
TRUNCATE TABLE dim_customer;
TRUNCATE TABLE dim_product;
TRUNCATE TABLE dim_date;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Dimension Table: dim_date
-- 30 dates covering January and February 2024 (including weekdays and weekends)
-- ============================================================================

INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend) VALUES
(20240101, '2024-01-01', 'Monday', 1, 1, 'January', 'Q1', 2024, FALSE),
(20240102, '2024-01-02', 'Tuesday', 2, 1, 'January', 'Q1', 2024, FALSE),
(20240103, '2024-01-03', 'Wednesday', 3, 1, 'January', 'Q1', 2024, FALSE),
(20240104, '2024-01-04', 'Thursday', 4, 1, 'January', 'Q1', 2024, FALSE),
(20240105, '2024-01-05', 'Friday', 5, 1, 'January', 'Q1', 2024, FALSE),
(20240106, '2024-01-06', 'Saturday', 6, 1, 'January', 'Q1', 2024, TRUE),
(20240107, '2024-01-07', 'Sunday', 7, 1, 'January', 'Q1', 2024, TRUE),
(20240108, '2024-01-08', 'Monday', 8, 1, 'January', 'Q1', 2024, FALSE),
(20240109, '2024-01-09', 'Tuesday', 9, 1, 'January', 'Q1', 2024, FALSE),
(20240110, '2024-01-10', 'Wednesday', 10, 1, 'January', 'Q1', 2024, FALSE),
(20240111, '2024-01-11', 'Thursday', 11, 1, 'January', 'Q1', 2024, FALSE),
(20240112, '2024-01-12', 'Friday', 12, 1, 'January', 'Q1', 2024, FALSE),
(20240113, '2024-01-13', 'Saturday', 13, 1, 'January', 'Q1', 2024, TRUE),
(20240114, '2024-01-14', 'Sunday', 14, 1, 'January', 'Q1', 2024, TRUE),
(20240115, '2024-01-15', 'Monday', 15, 1, 'January', 'Q1', 2024, FALSE),
(20240116, '2024-01-16', 'Tuesday', 16, 1, 'January', 'Q1', 2024, FALSE),
(20240117, '2024-01-17', 'Wednesday', 17, 1, 'January', 'Q1', 2024, FALSE),
(20240118, '2024-01-18', 'Thursday', 18, 1, 'January', 'Q1', 2024, FALSE),
(20240119, '2024-01-19', 'Friday', 19, 1, 'January', 'Q1', 2024, FALSE),
(20240120, '2024-01-20', 'Saturday', 20, 1, 'January', 'Q1', 2024, TRUE),
(20240121, '2024-01-21', 'Sunday', 21, 1, 'January', 'Q1', 2024, TRUE),
(20240122, '2024-01-22', 'Monday', 22, 1, 'January', 'Q1', 2024, FALSE),
(20240123, '2024-01-23', 'Tuesday', 23, 1, 'January', 'Q1', 2024, FALSE),
(20240124, '2024-01-24', 'Wednesday', 24, 1, 'January', 'Q1', 2024, FALSE),
(20240125, '2024-01-25', 'Thursday', 25, 1, 'January', 'Q1', 2024, FALSE),
(20240126, '2024-01-26', 'Friday', 26, 1, 'January', 'Q1', 2024, FALSE),
(20240127, '2024-01-27', 'Saturday', 27, 1, 'January', 'Q1', 2024, TRUE),
(20240128, '2024-01-28', 'Sunday', 28, 1, 'January', 'Q1', 2024, TRUE),
(20240129, '2024-01-29', 'Monday', 29, 1, 'January', 'Q1', 2024, FALSE),
(20240130, '2024-01-30', 'Tuesday', 30, 1, 'January', 'Q1', 2024, FALSE);

-- ============================================================================
-- Dimension Table: dim_product
-- 15 products across 3 categories: Electronics, Clothing, Accessories
-- ============================================================================

INSERT INTO dim_product (product_id, product_name, category, subcategory, unit_price) VALUES
('P001', 'Laptop Pro 15', 'Electronics', 'Computers', 50000.00),
('P002', 'Wireless Mouse', 'Electronics', 'Accessories', 899.00),
('P003', 'Gaming Keyboard', 'Electronics', 'Accessories', 2500.00),
('P004', 'Smartphone X1', 'Electronics', 'Mobile Phones', 25000.00),
('P005', 'Headphones Pro', 'Electronics', 'Audio', 3500.00),
('P006', 'Running Shoes', 'Clothing', 'Footwear', 3500.00),
('P007', 'Casual Shirt', 'Clothing', 'Apparel', 1299.00),
('P008', 'Jeans Classic', 'Clothing', 'Apparel', 2200.00),
('P009', 'Sneakers Sport', 'Clothing', 'Footwear', 5500.00),
('P010', 'T-Shirt Basic', 'Clothing', 'Apparel', 599.00),
('P011', 'Smart Watch', 'Electronics', 'Wearables', 12000.00),
('P012', 'Tablet Air', 'Electronics', 'Computers', 18000.00),
('P013', 'Hoodie Premium', 'Clothing', 'Apparel', 2800.00),
('P014', 'Backpack Travel', 'Accessories', 'Bags', 2200.00),
('P015', 'Wallet Leather', 'Accessories', 'Wallets', 1500.00);

-- ============================================================================
-- Dimension Table: dim_customer
-- 12 customers across 4 cities: Mumbai, Bangalore, Delhi, Hyderabad
-- ============================================================================

INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment) VALUES
('C001', 'Rahul Sharma', 'Mumbai', 'Maharashtra', 'High Value'),
('C002', 'Priya Patel', 'Mumbai', 'Maharashtra', 'Medium Value'),
('C003', 'Amit Kumar', 'Delhi', 'Delhi', 'High Value'),
('C004', 'Sneha Reddy', 'Hyderabad', 'Telangana', 'Medium Value'),
('C005', 'Vikram Singh', 'Bangalore', 'Karnataka', 'Low Value'),
('C006', 'Anjali Mehta', 'Mumbai', 'Maharashtra', 'High Value'),
('C007', 'Ravi Verma', 'Bangalore', 'Karnataka', 'Medium Value'),
('C008', 'Pooja Iyer', 'Bangalore', 'Karnataka', 'Low Value'),
('C009', 'Karthik Nair', 'Delhi', 'Delhi', 'Medium Value'),
('C010', 'Deepa Gupta', 'Delhi', 'Delhi', 'High Value'),
('C011', 'Arjun Rao', 'Hyderabad', 'Telangana', 'Medium Value'),
('C012', 'Lakshmi Krishnan', 'Hyderabad', 'Telangana', 'Low Value');

-- ============================================================================
-- Fact Table: fact_sales
-- 40 sales transactions with realistic patterns
-- Higher sales on weekends, varied quantities and prices
-- ============================================================================

INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount) VALUES
-- January 2024 Sales (Higher volume on weekends)
-- Weekday sales
(20240102, 1, 1, 1, 50000.00, 0.00, 50000.00),
(20240103, 2, 2, 2, 899.00, 0.00, 1798.00),
(20240104, 3, 3, 1, 2500.00, 0.00, 2500.00),
(20240105, 4, 4, 1, 25000.00, 1000.00, 24000.00),
(20240108, 5, 5, 2, 3500.00, 0.00, 7000.00),
(20240109, 6, 6, 1, 3500.00, 0.00, 3500.00),
(20240110, 1, 1, 1, 50000.00, 2000.00, 48000.00),
(20240111, 11, 7, 1, 12000.00, 0.00, 12000.00),
(20240112, 7, 8, 3, 1299.00, 0.00, 3897.00),
(20240115, 8, 9, 2, 2200.00, 100.00, 4300.00),
(20240116, 9, 10, 1, 5500.00, 0.00, 5500.00),
(20240117, 12, 11, 1, 18000.00, 0.00, 18000.00),
(20240118, 10, 12, 5, 599.00, 0.00, 2995.00),
(20240119, 13, 1, 1, 2800.00, 0.00, 2800.00),
(20240122, 4, 3, 1, 25000.00, 1500.00, 23500.00),
(20240123, 5, 4, 1, 3500.00, 0.00, 3500.00),
(20240124, 6, 5, 1, 3500.00, 0.00, 3500.00),
(20240125, 14, 6, 1, 2200.00, 0.00, 2200.00),
(20240126, 15, 7, 2, 1500.00, 0.00, 3000.00),
(20240129, 2, 8, 1, 899.00, 0.00, 899.00),
(20240130, 3, 9, 1, 2500.00, 0.00, 2500.00),

-- Weekend sales (higher volume)
(20240106, 1, 1, 1, 50000.00, 3000.00, 47000.00),
(20240106, 4, 3, 1, 25000.00, 2000.00, 23000.00),
(20240107, 11, 6, 1, 12000.00, 0.00, 12000.00),
(20240107, 6, 10, 1, 3500.00, 0.00, 3500.00),
(20240113, 9, 11, 2, 5500.00, 0.00, 11000.00),
(20240113, 12, 2, 1, 18000.00, 1000.00, 17000.00),
(20240114, 7, 12, 4, 1299.00, 0.00, 5196.00),
(20240114, 8, 1, 1, 2200.00, 0.00, 2200.00),
(20240120, 1, 6, 1, 50000.00, 2500.00, 47500.00),
(20240120, 4, 10, 1, 25000.00, 1000.00, 24000.00),
(20240121, 11, 3, 1, 12000.00, 500.00, 11500.00),
(20240121, 5, 4, 1, 3500.00, 0.00, 3500.00),
(20240127, 9, 7, 1, 5500.00, 0.00, 5500.00),
(20240127, 12, 9, 1, 18000.00, 0.00, 18000.00),
(20240128, 13, 11, 1, 2800.00, 0.00, 2800.00),
(20240128, 14, 5, 1, 2200.00, 0.00, 2200.00),
(20240128, 15, 8, 3, 1500.00, 0.00, 4500.00);

-- Verify data counts
SELECT 'dim_date' AS table_name, COUNT(*) AS record_count FROM dim_date
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales;

