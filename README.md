![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![MySQL](https://img.shields.io/badge/Database-MySQL-blue.svg)
# 🧾 Print-on-Demand Order Manager (PODOM)

This is a MySQL database project designed for internship and academic evaluation.  
It manages users, products, custom orders, inventory, returns, and refunds.  
It uses clean schema design, normalized structure, and includes essential SQL queries for order management and reporting.

---

## 🔍 What It Does

Stores user, product, and inventory information.

Handles:

- 👤 Customer orders  
- 🎨 Custom print requests  
- 🚚 Multi-step order statuses  
- 🔁 Returns & 💸 Refunds  

Ensures clean structure with:

- 📦 `orderItems` table for itemized order data  
- 📄 `orderStatusHistory` for audit trail  

Uses soft deletes to avoid data loss.

Includes 5 key SQL queries:

- 📥 Place a new order  
- 🔄 Update order status  
- 🔍 Get orders for a user  
- 📊 View inventory levels  
- 📈 Report orders by status  

---

## 💡 Features Implemented

### ✅ Core Features
- User management (`users`)  
- Product catalog (`products`)  
- Order processing (`orders`, `orderItems`)  
- Inventory tracking (`inventory`)  
- Custom print details  
- Order status updates  
- Audit trail of changes  

### 🎁 Bonus Features
- Multiple shipping addresses (`shippingAddresses`)  
- Order returns (`orderReturn`)  
- Refunds (`refunds`)  
- Soft delete support (`isDeleted`)  
- Reporting by status  

---

## 🧠 Design Notes

- 🧾 Used `camelCase` naming to avoid keyword conflicts (e.g., `name`, `order`)  
- ✅ Normalized to **3rd Normal Form** for relational integrity  

---

## 🧪 Sample Data

- 👤 2 users (customer & admin)  
- 👕 2 products (with and without discount)  
- ✅ 1 order with multiple items  
- 🚚 Multiple order status entries  
- 🔁 One return + 💸 one refund  

---

## 🧑‍💻 Author

**Uday Pandey**  
Built as part of an internship assignment and refined with best practices in relational database design.
