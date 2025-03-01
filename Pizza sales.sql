Step 1: Drop Tables If They Exist (Avoid Errors)
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;

-- Step 2: Create Tables
CREATE TABLE pizzas (
    pizza_id INT PRIMARY KEY,
    pizza_name VARCHAR(100),
    category VARCHAR(50),
    size VARCHAR(10),
    price DECIMAL(5,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    pizza_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

-- Step 3: Insert 20 Pizza Records
INSERT INTO pizzas VALUES
(1, 'Margherita', 'Veg', 'Medium', 8.99),
(2, 'Pepperoni', 'Non-Veg', 'Large', 12.99),
(3, 'BBQ Chicken', 'Non-Veg', 'Medium', 10.99),
(4, 'Veggie Supreme', 'Veg', 'Large', 11.99),
(5, 'Cheese Burst', 'Veg', 'Small', 7.99),
(6, 'Farmhouse', 'Veg', 'Medium', 9.49),
(7, 'Tandoori Paneer', 'Veg', 'Large', 13.49),
(8, 'Chicken Tikka', 'Non-Veg', 'Small', 8.99),
(9, 'Mexican Wave', 'Veg', 'Medium', 10.99),
(10, 'Hawaiian Delight', 'Non-Veg', 'Large', 14.99),
(11, 'Meat Lovers', 'Non-Veg', 'Large', 15.99),
(12, 'Double Cheese', 'Veg', 'Small', 6.99),
(13, 'Peri Peri Chicken', 'Non-Veg', 'Medium', 11.49),
(14, 'Classic Cheese', 'Veg', 'Medium', 7.99),
(15, 'Pepper Barbecue', 'Non-Veg', 'Large', 13.99),
(16, 'Garlic Bread Pizza', 'Veg', 'Small', 5.99),
(17, 'Chicken Supreme', 'Non-Veg', 'Medium', 12.49),
(18, 'Veg Lovers', 'Veg', 'Large', 11.99),
(19, 'Mushroom Delight', 'Veg', 'Medium', 9.99),
(20, 'Sausage Feast', 'Non-Veg', 'Large', 14.49);

-- Step 4: Insert Sample Orders
INSERT INTO orders VALUES
(201, '2025-02-01', 'Alice'),
(202, '2025-02-02', 'Bob'),
(203, '2025-02-02', 'Charlie'),
(204, '2025-02-03', 'David'),
(205, '2025-02-04', 'Emma'),
(206, '2025-02-05', 'Frank'),
(207, '2025-02-05', 'Grace'),
(208, '2025-02-06', 'Hannah');

-- Step 5: Insert Order Details
INSERT INTO order_details VALUES
(1, 201, 1, 2), (2, 201, 3, 1), (3, 202, 2, 1), (4, 203, 4, 3),
(5, 204, 5, 2), (6, 204, 1, 1), (7, 205, 7, 2), (8, 206, 8, 1),
(9, 207, 9, 4), (10, 208, 10, 2), (11, 208, 11, 3), (12, 201, 12, 2),
(13, 202, 13, 1), (14, 203, 14, 2), (15, 204, 15, 3), (16, 205, 16, 1),
(17, 206, 17, 2), (18, 207, 18, 3), (19, 208, 19, 2), (20, 201, 20, 1);

-- Step 6: Sales Analysis Queries

-- 1. Total Sales Revenue
SELECT SUM(p.price * od.quantity) AS Total_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 2. Total Number of Pizzas Sold
SELECT SUM(quantity) AS Total_Pizzas_Sold FROM order_details;

-- 3. Most Popular Pizza (Highest Sales)
SELECT p.pizza_name, SUM(od.quantity) AS Total_Quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_name
ORDER BY Total_Quantity DESC
LIMIT 1;

-- 4. Top 3 Best-Selling Pizzas
SELECT p.pizza_name, SUM(od.quantity) AS Total_Quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_name
ORDER BY Total_Quantity DESC
LIMIT 3;

-- 5. Sales Revenue by Pizza Category
SELECT p.category, SUM(p.price * od.quantity) AS Category_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.category;

-- 6. Best Customer by Total Purchase
SELECT o.customer_name, SUM(p.price * od.quantity) AS Total_Spent
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.customer_name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 7. Average Order Value (AOV)
SELECT AVG(Order_Total) AS Average_Order_Value FROM (
    SELECT o.order_id, SUM(p.price * od.quantity) AS Order_Total
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.order_id
) AS OrderSums;

-- 8. Total Sales Per Pizza Size
SELECT p.size, SUM(p.price * od.quantity) AS Size_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size;

-- 9. Customer Order Frequency
SELECT customer_name, COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY customer_name
ORDER BY Total_Orders DESC;

-- 10. Revenue by Day of the Week
SELECT STRFTIME('%w', o.order_date) AS Weekday, SUM(p.price * od.quantity) AS Revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY Weekday
ORDER BY Weekday;

-- 11. Revenue by Month
SELECT STRFTIME('%m', o.order_date) AS Month, SUM(p.price * od.quantity) AS Monthly_Revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY Month
ORDER BY Month;

-- 12. Least Selling Pizza
SELECT p.pizza_name, SUM(od.quantity) AS Total_Quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_name
ORDER BY Total_Quantity ASC
LIMIT 1;