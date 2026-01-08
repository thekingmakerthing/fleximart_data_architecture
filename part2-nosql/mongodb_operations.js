// ============================================================================
// FlexiMart MongoDB Operations
// Part 2.2: MongoDB Implementation (10 marks)
// ============================================================================

// Use the products database in mongodb compass after maunally creatinb Fleximart database.
db.fleximart;

// Clear existing collection (optional, for testing)
db.products.drop();

// ============================================================================
// Operation 1: Load Data (1 mark)
// Import the provided JSON file into collection 'products'
// ============================================================================
// Note: In MongoDB shell, you can load JSON using:
// mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray

// For this script, we'll insert the documents directly
db.products.insertMany([
  {
    "product_id": "ELEC001",
    "name": "Samsung Galaxy S21",
    "category": "Electronics",
    "price": 79999,
    "stock": 150,
    "specs": {
      "ram": "8GB",
      "storage": "128GB",
      "processor": "Exynos 2100",
      "screen_size": "6.2 inches",
      "battery": "4000 mAh"
    },
    "reviews": [
      {
        "user": "U001",
        "rating": 5,
        "comment": "Excellent phone with great camera!",
        "date": "2024-01-15"
      },
      {
        "user": "U002",
        "rating": 4,
        "comment": "Good performance, battery could be better",
        "date": "2024-01-20"
      },
      {
        "user": "U003",
        "rating": 5,
        "comment": "Amazing display quality",
        "date": "2024-02-01"
      }
    ]
  },
  {
    "product_id": "ELEC002",
    "name": "Dell XPS 15 Laptop",
    "category": "Electronics",
    "price": 125000,
    "stock": 75,
    "specs": {
      "ram": "16GB",
      "storage": "512GB SSD",
      "processor": "Intel Core i7-11800H",
      "screen_size": "15.6 inches",
      "graphics": "NVIDIA RTX 3050"
    },
    "reviews": [
      {
        "user": "U004",
        "rating": 5,
        "comment": "Perfect for video editing",
        "date": "2024-01-18"
      },
      {
        "user": "U005",
        "rating": 4,
        "comment": "Great build quality, a bit expensive",
        "date": "2024-02-05"
      }
    ]
  },
  {
    "product_id": "ELEC003",
    "name": "Sony WH-1000XM4 Headphones",
    "category": "Electronics",
    "price": 24990,
    "stock": 200,
    "specs": {
      "type": "Over-ear",
      "noise_cancellation": "Active",
      "battery_life": "30 hours",
      "wireless": true
    },
    "reviews": [
      {
        "user": "U006",
        "rating": 5,
        "comment": "Best noise cancellation I've experienced",
        "date": "2024-01-22"
      },
      {
        "user": "U007",
        "rating": 5,
        "comment": "Comfortable for long sessions",
        "date": "2024-02-10"
      },
      {
        "user": "U008",
        "rating": 4,
        "comment": "Excellent sound quality",
        "date": "2024-02-15"
      }
    ]
  },
  {
    "product_id": "ELEC004",
    "name": "Apple iPad Air",
    "category": "Electronics",
    "price": 49900,
    "stock": 120,
    "specs": {
      "ram": "4GB",
      "storage": "64GB",
      "processor": "Apple M1",
      "screen_size": "10.9 inches",
      "cellular": false
    },
    "reviews": [
      {
        "user": "U009",
        "rating": 4,
        "comment": "Great tablet for productivity",
        "date": "2024-01-25"
      },
      {
        "user": "U010",
        "rating": 5,
        "comment": "Love the M1 chip performance",
        "date": "2024-02-08"
      }
    ]
  },
  {
    "product_id": "ELEC005",
    "name": "Canon EOS R6 Camera",
    "category": "Electronics",
    "price": 189900,
    "stock": 45,
    "specs": {
      "sensor": "20.1 MP Full Frame",
      "iso_range": "100-102400",
      "video": "4K 60fps",
      "autofocus_points": 6072,
      "image_stabilization": "In-body 5-axis"
    },
    "reviews": [
      {
        "user": "U011",
        "rating": 5,
        "comment": "Professional quality camera",
        "date": "2024-01-28"
      }
    ]
  },
  {
    "product_id": "SHOE001",
    "name": "Nike Air Max 270",
    "category": "Clothing",
    "price": 8999,
    "stock": 180,
    "specs": {
      "size": "8,9,10,11",
      "color": "Black/White",
      "material": "Mesh and Synthetic",
      "brand": "Nike",
      "gender": "Unisex"
    },
    "reviews": [
      {
        "user": "U012",
        "rating": 5,
        "comment": "Very comfortable running shoes",
        "date": "2024-01-30"
      },
      {
        "user": "U013",
        "rating": 4,
        "comment": "Good quality, runs slightly small",
        "date": "2024-02-12"
      }
    ]
  },
  {
    "product_id": "SHOE002",
    "name": "Adidas Ultraboost 22",
    "category": "Clothing",
    "price": 12999,
    "stock": 150,
    "specs": {
      "size": "7,8,9,10,11",
      "color": "White/Black",
      "material": "Primeknit",
      "brand": "Adidas",
      "gender": "Men"
    },
    "reviews": [
      {
        "user": "U014",
        "rating": 5,
        "comment": "Best running shoes ever!",
        "date": "2024-02-03"
      },
      {
        "user": "U015",
        "rating": 4,
        "comment": "Great cushioning and support",
        "date": "2024-02-18"
      },
      {
        "user": "U016",
        "rating": 5,
        "comment": "Worth every penny",
        "date": "2024-02-20"
      }
    ]
  },
  {
    "product_id": "SHOE003",
    "name": "Puma RS-X Sneakers",
    "category": "Clothing",
    "price": 6999,
    "stock": 200,
    "specs": {
      "size": "6,7,8,9,10,11",
      "color": "Black/Grey",
      "material": "Leather and Mesh",
      "brand": "Puma",
      "gender": "Unisex"
    },
    "reviews": [
      {
        "user": "U017",
        "rating": 4,
        "comment": "Stylish and comfortable",
        "date": "2024-02-05"
      },
      {
        "user": "U018",
        "rating": 4,
        "comment": "Good value for money",
        "date": "2024-02-14"
      }
    ]
  },
  {
    "product_id": "SHOE004",
    "name": "Converse Chuck Taylor All Star",
    "category": "Clothing",
    "price": 4499,
    "stock": 250,
    "specs": {
      "size": "5,6,7,8,9,10",
      "color": "White",
      "material": "Canvas",
      "brand": "Converse",
      "gender": "Unisex"
    },
    "reviews": [
      {
        "user": "U019",
        "rating": 5,
        "comment": "Classic style, timeless design",
        "date": "2024-02-07"
      },
      {
        "user": "U020",
        "rating": 4,
        "comment": "Perfect casual shoes",
        "date": "2024-02-16"
      }
    ]
  },
  {
    "product_id": "SHOE005",
    "name": "Reebok Classic Leather",
    "category": "Clothing",
    "price": 5499,
    "stock": 170,
    "specs": {
      "size": "7,8,9,10,11",
      "color": "Navy Blue",
      "material": "Leather",
      "brand": "Reebok",
      "gender": "Men"
    },
    "reviews": [
      {
        "user": "U021",
        "rating": 4,
        "comment": "Comfortable everyday shoes",
        "date": "2024-02-09"
      }
    ]
  }
]);

print("Operation 1: Data loaded successfully. Total documents: " + db.products.count());

// ============================================================================
// Operation 2: Basic Query (2 marks)
// Find all products in "Electronics" category with price less than 50000
// Return only: name, price, stock
// ============================================================================

print("\nOperation 2: Electronics products with price < 50000");
db.products.find(
  { 
    category: "Electronics",
    price: { $lt: 50000 }
  },
  {
    name: 1,
    price: 1,
    stock: 1,
    _id: 0
  }
).pretty();

// ============================================================================
// Operation 3: Review Analysis (2 marks)
// Find all products that have average rating >= 4.0
// Use aggregation to calculate average from reviews array
// ============================================================================

print("\nOperation 3: Products with average rating >= 4.0");
db.products.aggregate([
  {
    $project: {
      product_id: 1,
      name: 1,
      category: 1,
      avgRating: {
        $avg: "$reviews.rating"
      },
      reviewCount: {
        $size: { $ifNull: ["$reviews", []] }
      }
    }
  },
  {
    $match: {
      avgRating: { $gte: 4.0 }
    }
  },
  {
    $sort: {
      avgRating: -1
    }
  }
]).forEach(function(product) {
  print(JSON.stringify(product));
});

// ============================================================================
// Operation 4: Update Operation (2 marks)
// Add a new review to product "ELEC001"
// Review: {user: "U999", rating: 4, comment: "Good value", date: ISODate()}
// ============================================================================

print("\nOperation 4: Adding review to product ELEC001");
db.products.updateOne(
  { product_id: "ELEC001" },
  {
    $push: {
      reviews: {
        user: "U999",
        rating: 4,
        comment: "Good value",
        date: new Date()
      }
    }
  }
);
print("Review added successfully");

// Verify the update
db.products.findOne(
  { product_id: "ELEC001" },
  { name: 1, reviews: 1, _id: 0 }
);

// ============================================================================
// Operation 5: Complex Aggregation (3 marks)
// Calculate average price by category
// Return: category, avg_price, product_count
// Sort by avg_price descending
// ============================================================================

print("\nOperation 5: Average price by category");
db.products.aggregate([
  {
    $group: {
      _id: "$category",
      avg_price: { $avg: "$price" },
      product_count: { $sum: 1 }
    }
  },
  {
    $project: {
      category: "$_id",
      avg_price: { $round: ["$avg_price", 2] },
      product_count: 1,
      _id: 0
    }
  },
  {
    $sort: {
      avg_price: -1
    }
  }
]).forEach(function(result) {
  print(JSON.stringify(result));
});

print("\nAll MongoDB operations completed successfully!");

