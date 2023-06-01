--retrieving customers with specific name patterns, using subqueries, and utilizing grouping sets and window functions
-- Create tables
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    country_id INT
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE countries (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Insert sample data
INSERT INTO customers (id, name, country_id)
VALUES (1, 'John Doe', 1),
       (2, 'Jane Smith', 2),
       (3, 'Mike Johnson', 1);

INSERT INTO orders (id, customer_id, order_date, total_amount)
VALUES (1, 1, '2023-05-10', 100.00),
       (2, 1, '2023-05-15', 200.00),
       (3, 2, '2023-05-12', 150.00),
       (4, 3, '2023-05-18', 300.00);

INSERT INTO countries (id, name)
VALUES (1, 'USA'),
       (2, 'Canada');

-- Query to retrieve customers and their total order amounts by country
SELECT c.name AS customer_name, co.name AS country_name, SUM(o.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN countries co ON c.country_id = co.id
GROUP BY c.name, co.name;

-- Query to retrieve customers who have placed more than 2 orders
SELECT c.name AS customer_name, COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 2;

-- Query to retrieve customers who have placed orders in the last 7 days
SELECT c.name AS customer_name
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= DATEADD(DAY, -7, GETDATE());

-- Query to calculate the average order amount for customers from each country
SELECT co.name AS country_name, AVG(o.total_amount) AS avg_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN countries co ON c.country_id = co.id
GROUP BY co.name;

-- Query to retrieve customers whose names start with 'J' and have more than 5 characters
SELECT name
FROM customers
WHERE name LIKE 'J%' AND LEN(name) > 5;

-- Query to retrieve customers and their corresponding orders with a total amount greater than the average order amount
SELECT c.name AS customer_name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id AND o.total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);

-- Query to calculate the total sales amount by country and year, and also the overall total
SELECT c.country_id, YEAR(o.order_date) AS order_year, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN (
    SELECT id, country_id
    FROM customers
) c ON c.id = o.customer_id
GROUP BY GROUPING SETS ((c.country_id, YEAR(o.order_date)), ());

-- Query to calculate the average order amount and its percentage of the total amount for each order
SELECT order_date, total_amount,
       AVG(total_amount) OVER () AS average_amount,
       total_amount / SUM(total_amount) OVER () AS percentage
FROM orders;