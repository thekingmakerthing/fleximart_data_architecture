# Part 2: NoSQL Database Analysis

## Overview

This part analyzes the suitability of MongoDB for FlexiMart's diverse product catalog and implements basic MongoDB operations for product management.

## Files

- **`nosql_analysis.md`**: Complete analysis of RDBMS limitations, NoSQL benefits, and trade-offs
- **`mongodb_operations.js`**: Five MongoDB operations (load, query, aggregation, update, analysis)
- **`products_catalog.json`**: Sample product catalog with nested structures

## Setup

1. Start MongoDB service:
   ```bash
   mongod --dbpath /path/to/data
   ```

2. Run MongoDB operations:
   ```bash
   mongosh < mongodb_operations.js
   ```

   Or import data separately:
   ```bash
   mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray
   ```

## Operations

1. **Load Data**: Import product catalog into MongoDB
2. **Basic Query**: Find Electronics products with price < ₹50,000
3. **Review Analysis**: Find products with average rating >= 4.0
4. **Update Operation**: Add new review to product
5. **Complex Aggregation**: Calculate average price by category

