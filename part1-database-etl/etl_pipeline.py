from socket import create_connection
import pandas as pd
import re
import mysql.connector
from mysql.connector import Error
import logging
from sqlalchemy import create_engine
import os

# Database Configuration (Update with actual credentials)
DB_USER = 'root'
DB_PASSWORD = 'Rbab#007'
DB_HOST = 'localhost'
DB_PORT = '3306'
DB_NAME = 'fleximart'

# File Paths
DATA_DIR = '../data'
FILES = {
    'customers': os.path.join(DATA_DIR, 'customers_raw.csv'),
    'products': os.path.join(DATA_DIR, 'products_raw.csv'),
    'sales': os.path.join(DATA_DIR, 'sales_raw.csv')
}

def get_db_connection():
    """Create SQLAlchemy engine connection"""
    conn_str = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    return create_engine(conn_str)

def test_db_connection():
    """Quickly test DB connectivity; returns True on success"""
    try:
        engine = get_db_connection()
        conn = engine.connect()
        conn.close()
        return True
    except Exception as e:
        print(f"DB connection test failed: {e}")
        return False

def clean_phone(phone):
    """Standardize phone to +91-XXXXXXXXXX"""
    if pd.isna(phone):
        return None
    # Remove non-digits
    digits = re.sub(r'\D', '', str(phone))
    
    # Handle lengths
    if len(digits) == 10:
        return f"+91-{digits}"
    elif len(digits) == 11 and digits.startswith('0'):
        return f"+91-{digits[1:]}"
    elif len(digits) == 12 and digits.startswith('91'):
        return f"+91-{digits[2:]}"
    return digits # Return as-is if pattern doesn't match

def parse_date_robust(date_str):
    """Handle mixed date formats (YYYY-MM-DD, DD/MM/YYYY, etc.)"""
    if pd.isna(date_str):
        return None
    
    formats = ['%Y-%m-%d', '%d/%m/%Y', '%m-%d-%Y', '%d-%m-%Y']
    for fmt in formats:
        try:
            return pd.to_datetime(date_str, format=fmt).date()
        except ValueError:
            continue
    
    # Fallback to pandas flexible parser
    try:
        return pd.to_datetime(date_str).date()
    except:
        return None

def create_schema(cursor):
    """Creates the database schema based on provided SQL."""
    print("Creating schema...")
    
    # Drop tables in reverse order of dependencies to avoid FK errors
    tables = ['order_items', 'orders', 'products', 'customers']
    for table in tables:
        cursor.execute(f"DROP TABLE IF EXISTS {table}")

    # Schema Definitions
    schema_queries = [
        """
        CREATE TABLE customers (
            customer_id INT PRIMARY KEY AUTO_INCREMENT,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            phone VARCHAR(20),
            city VARCHAR(50),
            registration_date DATE
        )
        """,
        """
        CREATE TABLE products (
            product_id INT PRIMARY KEY AUTO_INCREMENT,
            product_name VARCHAR(100) NOT NULL,
            category VARCHAR(50) NOT NULL,
            price DECIMAL(10,2) NOT NULL,
            stock_quantity INT DEFAULT 0
        )
        """,
        """
        CREATE TABLE orders (
            order_id INT PRIMARY KEY AUTO_INCREMENT,
            customer_id INT NOT NULL,
            order_date DATE NOT NULL,
            total_amount DECIMAL(10,2) NOT NULL,
            status VARCHAR(20) DEFAULT 'Pending',
            FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        )
        """,
        """
        CREATE TABLE order_items (
            order_item_id INT PRIMARY KEY AUTO_INCREMENT,
            order_id INT NOT NULL,
            product_id INT NOT NULL,
            quantity INT NOT NULL,
            unit_price DECIMAL(10,2) NOT NULL,
            subtotal DECIMAL(10,2) NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders(order_id),
            FOREIGN KEY (product_id) REFERENCES products(product_id)
        )
        """
    ]

    for query in schema_queries:
        try:
            cursor.execute(query)
        except Error as e:
            logging.error(f"Failed to create table: {e}")
            print(f"Error: {e}")
    
    print("Schema created successfully.")



def run_etl():
    report = []
    report.append("FlexiMart Data Quality Report")
    report.append("=============================")

    # --- 1. Customers ---
    print("Processing Customers...")
    df_c = pd.read_csv(FILES['customers'])
    stats_c = {'processed': len(df_c), 'duplicates': 0, 'missing': 0}
    
    # Deduplicate
    initial_len = len(df_c)
    df_c = df_c.drop_duplicates(subset=['customer_id'])
    stats_c['duplicates'] = initial_len - len(df_c)
    
    # Missing Values (Email)
    stats_c['missing'] += df_c['email'].isnull().sum()
    df_c['email'] = df_c.apply(lambda row: f"{row['first_name'].lower()}.{row['last_name'].lower()}@example.com" if pd.isnull(row['email']) else row['email'], axis=1)
    
    # Standardize
    df_c['phone'] = df_c['phone'].apply(clean_phone)
    df_c['registration_date'] = df_c['registration_date'].apply(parse_date_robust)
    
    # Surrogate Key Preparation (DB Auto-increment handles ID, we drop raw ID or map it if needed)
    # For this exercise, we strictly follow schema which has auto-increment.
    # We will load data excluding the ID column if we were inserting into a fresh DB, 
    # but to maintain relationships with Sales, we might need to force the ID.
    # We'll assume the raw IDs (C001) map to integers (1) for simplicity.
    df_c['customer_id'] = df_c['customer_id'].astype(str).str.replace('C', '').astype(int)

    report.append(f"Customers: Processed {stats_c['processed']} | Duplicates Removed {stats_c['duplicates']} | Missing Handled {stats_c['missing']} | Loaded {len(df_c)}")

    # --- 2. Products ---
    print("Processing Products...")
    df_p = pd.read_csv(FILES['products'])
    stats_p = {'processed': len(df_p), 'duplicates': 0, 'missing': 0}
    
    # Deduplicate
    initial_len = len(df_p)
    df_p = df_p.drop_duplicates()
    stats_p['duplicates'] = initial_len - len(df_p)
    
    # Standardize Category
    df_p['category'] = df_p['category'].str.strip().str.title()
    
    # Missing Values
    stats_p['missing'] += df_p['price'].isnull().sum() + df_p['stock_quantity'].isnull().sum()
    
    # Fill Price with Category Mean
    df_p['price'] = pd.to_numeric(df_p['price'], errors='coerce')
    df_p['price'] = df_p.groupby('category')['price'].transform(lambda x: x.fillna(x.mean()))
    
    # Fill Stock with 0
    df_p['stock_quantity'] = df_p['stock_quantity'].fillna(0).astype(int)
    
    # ID Transform
    df_p['product_id'] = df_p['product_id'].astype(str).str.replace('P', '').astype(int)
    
    report.append(f"Products:  Processed {stats_p['processed']} | Duplicates Removed {stats_p['duplicates']} | Missing Handled {stats_p['missing']} | Loaded {len(df_p)}")

    # --- 3. Sales ---
    print("Processing Sales...")
    df_s = pd.read_csv(FILES['sales'])
    stats_s = {'processed': len(df_s), 'duplicates': 0, 'missing': 0}
    
    # Deduplicate
    initial_len = len(df_s)
    df_s = df_s.drop_duplicates()
    stats_s['duplicates'] = initial_len - len(df_s)
    
    # Handle Missing Foreign Keys
    missing_fks = df_s['customer_id'].isnull().sum() + df_s['product_id'].isnull().sum()
    stats_s['missing'] += missing_fks
    df_s = df_s.dropna(subset=['customer_id', 'product_id'])
    
    # Standardize Dates
    df_s['transaction_date'] = df_s['transaction_date'].apply(parse_date_robust)
    
    # ID Transform
    df_s['customer_id'] = df_s['customer_id'].astype(str).str.replace('C', '').astype(int)
    df_s['product_id'] = df_s['product_id'].astype(str).str.replace('P', '').astype(int)
    
    report.append(f"Sales:     Processed {stats_s['processed']} | Duplicates Removed {stats_s['duplicates']} | Missing Handled {stats_s['missing']} | Loaded {len(df_s)}")


    conn = create_connection()
    if conn is None: return

    cursor = conn.cursor()
    
    # 1. Setup Schema
    create_schema(cursor)

    
    # --- 4. Load to DB ---
    if test_db_connection():
        try:
            engine = get_db_connection()
            
            # Load Customers
            df_c.to_sql('customers', engine, if_exists='append', index=False)
            
            # Load Products
            df_p.to_sql('products', engine, if_exists='append', index=False)
            
            # Load Orders & Items
            # Split Sales into Orders and Order Items
            # NOTE: This requires generating new Order IDs. For simplicity in this pipeline,
            # we treat 'transaction_id' as 'order_id' if T001 -> 1.
            
            orders = df_s[['customer_id', 'transaction_date', 'status']].copy()
            orders['order_id'] = df_s['transaction_id'].astype(str).str.replace('T', '').astype(int)
            orders = orders.rename(columns={'transaction_date': 'order_date'})
            
            # Calculate total amount per order
            orders['total_amount'] = df_s['quantity'] * df_s['unit_price']
            
            # Insert Orders
            orders.to_sql('orders', engine, if_exists='append', index=False)
            
            # Insert Order Items
            items = df_s[['product_id', 'quantity', 'unit_price']].copy()
            items['order_id'] = orders['order_id']
            items['subtotal'] = items['quantity'] * items['unit_price']
            items.to_sql('order_items', engine, if_exists='append', index=False)
            
            print("Data loaded successfully.")
            
        except Exception as e:
            print(f"Database Load Skipped/Failed (Expected if DB not configured): {e}")
    else:
        print(f"Database Load Skipped: cannot connect to MySQL host '{DB_HOST}'. Start MySQL and verify DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, and DB_NAME.")

    # Write Report
    with open('data_quality_report.txt', 'w') as f:
        f.write('\n'.join(report))
        print("Report generated: data_quality_report.txt")

if __name__ == "__main__":
    run_etl()