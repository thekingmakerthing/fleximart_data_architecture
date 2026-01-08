# FlexiMart NoSQL Database Analysis

## Part 2.1: NoSQL Justification Report (10 marks)

### Section A: Limitations of RDBMS (4 marks - 150 words)

The current relational database (MySQL/PostgreSQL) would face significant challenges when managing FlexiMart's diverse product catalog. Products have fundamentally different attributes based on their category. For instance, laptops require attributes like RAM, processor, storage capacity, and screen size, while shoes need size, color, material, and brand. Clothing items require different attributes like fabric type, washing instructions, and fit. Storing these varied attributes in a relational model forces either of two problematic approaches: creating a massive product table with hundreds of nullable columns (most products would have most columns as NULL) or implementing an Entity-Attribute-Value (EAV) pattern, which breaks relational integrity and makes queries complex and slow.

Furthermore, frequent schema changes when adding new product types would require ALTER TABLE operations, downtime, and migration scripts. Additionally, storing customer reviews as nested data becomes problematic in RDBMS, requiring a separate reviews table with complex joins, making it difficult to retrieve a complete product document with all its reviews in a single query. These limitations create maintenance overhead and performance bottlenecks as the catalog grows.

### Section B: NoSQL Benefits (4 marks - 150 words)

MongoDB's flexible schema (document structure) solves these problems elegantly. Each product document can have a unique structure tailored to its category. A laptop product can include a "specs" nested object with RAM, processor, and storage fields, while a shoe product can have a completely different structure with size, color, and material fields. This allows the product catalog to evolve without schema migrations. When new product types are introduced, they can be added immediately without altering existing product structures.

MongoDB's embedded documents feature enables storing reviews directly within product documents as an array, creating a complete product document that includes all its reviews. This eliminates the need for joins and provides atomic access to all product-related data in a single query. Horizontal scalability through sharding allows MongoDB to distribute product data across multiple servers, supporting millions of products with varying structures while maintaining query performance. The document model naturally represents the hierarchical nature of product data, making the code more intuitive and maintainable.

### Section C: Trade-offs (2 marks - 100 words)

Two significant disadvantages of using MongoDB instead of MySQL for this product catalog are: (1) **ACID transaction limitations**: While MongoDB now supports multi-document transactions, they are less mature than relational databases. Complex transactions involving inventory updates, order processing, and payment handling that span multiple documents may have performance implications or consistency concerns compared to MySQL's robust transaction support. (2) **Complex query capabilities**: MongoDB's query language, while powerful, lacks the SQL sophistication for complex analytical queries. Advanced JOINs, subqueries, and aggregations that are straightforward in SQL require more complex MongoDB aggregation pipelines, making business intelligence and reporting tasks more challenging. Additionally, the lack of enforced schema can lead to data inconsistency issues without careful application-level validation.

