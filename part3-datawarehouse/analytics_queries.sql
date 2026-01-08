-- ============================================================================
-- FlexiMart Data Warehouse - OLAP Analytics Queries
-- Part 3.3: OLAP Analytics Queries (15 marks)
-- ============================================================================

USE fleximart_dw;

-- ============================================================================
-- Query 1: Monthly Sales Drill-Down Analysis (5 marks)
-- ============================================================================
-- Business Scenario: "The CEO wants to see sales performance broken down by 
-- time periods. Start with yearly total, then quarterly, then monthly sales 
-- for 2024."
-- Demonstrates: Drill-down from Year to Quarter to Month
-- Expected Output: year | quarter | month_name | total_sales | total_quantity

SELECT 
    d.year,
    d.quarter,
    d.month_name,
    SUM(fs.total_amount) AS total_sales,
    SUM(fs.quantity_sold) AS total_quantity
FROM 
    fact_sales fs
    INNER JOIN dim_date d ON fs.date_key = d.date_key
WHERE 
    d.year = 2024
GROUP BY 
    d.year, d.quarter, d.month, d.month_name
ORDER BY 
    d.year, d.quarter, d.month;

-- ============================================================================
-- Query 2: Product Performance Analysis (5 marks)
-- ============================================================================
-- Business Scenario: "The product manager needs to identify top-performing 
-- products. Show the top 10 products by revenue, along with their category, 
-- total units sold, and revenue contribution percentage."
-- Includes: Revenue percentage calculation
-- Expected Output: product_name | category | units_sold | revenue | revenue_percentage

SELECT 
    p.product_name,
    p.category,
    SUM(fs.quantity_sold) AS units_sold,
    SUM(fs.total_amount) AS revenue,
    ROUND(
        (SUM(fs.total_amount) / (SELECT SUM(total_amount) FROM fact_sales)) * 100, 
        2
    ) AS revenue_percentage
FROM 
    fact_sales fs
    INNER JOIN dim_product p ON fs.product_key = p.product_key
GROUP BY 
    p.product_key, p.product_name, p.category
ORDER BY 
    revenue DESC
LIMIT 10;

-- ============================================================================
-- Query 3: Customer Segmentation Analysis (5 marks)
-- ============================================================================
-- Business Scenario: "Marketing wants to target high-value customers. 
-- Segment customers into 'High Value' (>₹50,000 spent), 'Medium Value' 
-- (₹20,000-₹50,000), and 'Low Value' (<₹20,000). Show count of customers 
-- and total revenue in each segment."
-- Segments: High/Medium/Low value customers
-- Expected Output: customer_segment | customer_count | total_revenue | avg_revenue

WITH customer_spending AS (
    SELECT 
        c.customer_key,
        c.customer_name,
        SUM(fs.total_amount) AS total_spent
    FROM 
        fact_sales fs
        INNER JOIN dim_customer c ON fs.customer_key = c.customer_key
    GROUP BY 
        c.customer_key, c.customer_name
),
segmented_customers AS (
    SELECT 
        customer_key,
        customer_name,
        total_spent,
        CASE 
            WHEN total_spent > 50000 THEN 'High Value'
            WHEN total_spent >= 20000 AND total_spent <= 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM 
        customer_spending
)
SELECT 
    customer_segment,
    COUNT(DISTINCT customer_key) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM 
    segmented_customers
GROUP BY 
    customer_segment
ORDER BY 
    CASE customer_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        ELSE 3
    END;

-- ============================================================================
-- Additional Analytical Query: Category Performance by Month
-- ============================================================================
-- Bonus query showing category performance over time

SELECT 
    d.month_name,
    p.category,
    COUNT(DISTINCT fs.sale_key) AS transaction_count,
    SUM(fs.quantity_sold) AS total_quantity,
    SUM(fs.total_amount) AS total_revenue
FROM 
    fact_sales fs
    INNER JOIN dim_date d ON fs.date_key = d.date_key
    INNER JOIN dim_product p ON fs.product_key = p.product_key
WHERE 
    d.year = 2024
GROUP BY 
    d.month, d.month_name, p.category
ORDER BY 
    d.month, total_revenue DESC;

