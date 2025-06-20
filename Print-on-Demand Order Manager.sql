-- DROP AND CREATE DATABASE
DROP DATABASE IF EXISTS PODOM; -- Acryonym for Print-on-Demand Order Manager
CREATE DATABASE PODOM;
USE PODOM;

-- USERS: Stores Info about all the users
CREATE TABLE users (
    userID INT AUTO_INCREMENT PRIMARY KEY,
    userName VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    userPassword VARCHAR(255),
    userRole ENUM('customer', 'admin') NOT NULL,
    isDeleted BOOLEAN DEFAULT FALSE
);

-- PRODUCTS: Stores info about products
CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productDescription VARCHAR(1000),
    size VARCHAR(50),
    color VARCHAR(50),
    material VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    discountPercent DECIMAL(5,2) DEFAULT 0.00, 
    isDeleted BOOLEAN DEFAULT FALSE
);

-- INVENTORY: Tracks inventory
CREATE TABLE inventory (
    productID INT PRIMARY KEY,
    stockLevel INT NOT NULL,
    lastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (productID) REFERENCES products(productID)
);

-- SHIPPING ADDRESSES: Allows the user to store multiple addresses
CREATE TABLE shippingAddresses (
    addressID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    addressLine VARCHAR(2000) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    zipCode VARCHAR(20),
    isDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (userID) REFERENCES users(userID)
);

-- ORDERS: Tracks information about orders
CREATE TABLE orders (
   orderID INT AUTO_INCREMENT PRIMARY KEY,
   userID INT NOT NULL,
   orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
   orderAmount DECIMAL(10,2) NOT NULL,
   addressID INT NOT NULL,
   FOREIGN KEY(userID) REFERENCES users(userID),
   FOREIGN KEY(addressID) REFERENCES shippingAddresses(addressID)
);

-- ORDER STATUS HISTORY: Tracks status changes of orders
CREATE TABLE orderStatusHistory (
    statusID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    orderStatus ENUM('Placed','Processing','Dispatched','Delivered','Cancelled'),
    changedTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

-- ORDER ITEMS: Stores details of each product inside each order.
CREATE TABLE orderItems (
    orderItemID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    customPrintsDetails VARCHAR(1000),
    FOREIGN KEY (orderID) REFERENCES orders(orderID),
    FOREIGN KEY (productID) REFERENCES products(productID)
);

-- ORDER RETURNS: Handles customer return requests
CREATE TABLE orderReturn (
    returnID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    reason TEXT,
    requestDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    returnStatus ENUM('Requested', 'Approved', 'Rejected', 'Completed') DEFAULT 'Requested',
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

-- REFUNDS: Tracks payment refunds for returned orders
CREATE TABLE refunds (
    refundID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    refundAmount DECIMAL(10,2),
    refundedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    refundStatus ENUM('Initiated', 'Processed', 'Failed') DEFAULT 'Initiated',
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

-- SAMPLE INSERTS

INSERT INTO users (userName, email, userPassword, userRole)
VALUES 
('Uday Pandey', 'uday@example.com', 'password_123', 'customer'),
('Admin User', 'admin@example.com', 'password_456', 'admin');

INSERT INTO products (productName, productDescription, size, color, material, price, discountPercent)
VALUES
('T-Shirt', 'Soft cotton round-neck t-shirt', 'M', 'Red', 'Cotton', 499.00, 10.00),
('Hoodie', 'Cozy hoodie with front zip', 'L', 'Black', 'Polyester', 899.00, 0.00);

INSERT INTO inventory (productID, stockLevel)
VALUES
(1, 50),
(2, 30);

INSERT INTO shippingAddresses (userID, addressLine, city, state, zipCode, isDefault)
VALUES
(1, '101 Tech Park Lane', 'Bangalore', 'Karnataka', '560001', TRUE),
(1, '23 Second Home Street', 'Pune', 'Maharashtra', '411045', FALSE);

INSERT INTO orders (userID, orderAmount, addressID)
VALUES
(1, 1000.00, 1);

INSERT INTO orderStatusHistory (orderID, orderStatus)
VALUES
(1, 'Placed'),
(1, 'Processing');

INSERT INTO orderItems (orderID, productID, quantity, unitPrice, customPrintsDetails)
VALUES
(1, 1, 2, 499.00, 'Print: Custom logo front'),
(1, 2, 1, 899.00, 'Text: “Best Day Ever” on back');

INSERT INTO orderReturn (orderID, reason)
VALUES
(1, 'Product size was too large');

INSERT INTO refunds (orderID, refundAmount)
VALUES
(1, 1000.00);

-- ========================
-- REQUIRED SQL QUERIES
-- ========================

-- QUERY 1: Place a New Order
INSERT INTO orders (userID, orderAmount, addressID)
VALUES (1, 1397.00, 1);
SET @orderID = LAST_INSERT_ID();

INSERT INTO orderItems (orderID, productID, quantity, unitPrice, customPrintsDetails)
VALUES
(@orderID, 1, 2, 499.00, 'Print: Fire Logo'),
(@orderID, 2, 1, 399.00, 'Text: Custom Text on back');

INSERT INTO orderStatusHistory (orderID, orderStatus)
VALUES (@orderID, 'Placed');

-- QUERY 2: Update Order Status
INSERT INTO orderStatusHistory (orderID, orderStatus)
VALUES (1, 'Dispatched');

-- QUERY 3: Retrieve All Orders for a User
SELECT o.orderID, o.orderDate, o.orderAmount, s.addressLine,
       oi.productID, p.productName, oi.quantity, oi.unitPrice
FROM orders o
JOIN shippingAddresses s ON o.addressID = s.addressID
JOIN orderItems oi ON o.orderID = oi.orderID
JOIN products p ON oi.productID = p.productID
WHERE o.userID = 1
ORDER BY o.orderDate DESC;

-- QUERY 4: List Inventory Levels
SELECT p.productName, i.stockLevel, i.lastUpdated
FROM inventory i
JOIN products p ON i.productID = p.productID
WHERE p.isDeleted = FALSE;

-- QUERY 5: Generate Report of Orders by Status
SELECT latestStatus.orderStatus, COUNT(*) AS totalOrders
FROM (
    SELECT orderID, MAX(changedTime) AS latestTime
    FROM orderStatusHistory
    GROUP BY orderID
) latest
JOIN orderStatusHistory latestStatus 
  ON latest.orderID = latestStatus.orderID AND latest.latestTime = latestStatus.changedTime
GROUP BY latestStatus.orderStatus;
