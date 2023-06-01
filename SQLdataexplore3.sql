--multiple tables, joins, subqueries, aggregations and more filtering conditions
-- Create tables
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT
);

CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE salaries (
    id INT PRIMARY KEY,
    employee_id INT,
    amount DECIMAL(10, 2),
    year INT
);

-- Insert sample data
INSERT INTO employees (id, name, department_id)
VALUES (1, 'John Doe', 1),
       (2, 'Jane Smith', 2),
       (3, 'Mike Johnson', 1);

INSERT INTO departments (id, name)
VALUES (1, 'Engineering'),
       (2, 'Sales');

INSERT INTO salaries (id, employee_id, amount, year)
VALUES (1, 1, 50000.00, 2021),
       (2, 1, 55000.00, 2022),
       (3, 2, 60000.00, 2021),
       (4, 2, 65000.00, 2022),
       (5, 3, 45000.00, 2021);

-- Query to retrieve employee names and their department names
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
JOIN departments d ON e.department_id = d.id;

-- Query to retrieve the average salary per department for the year 2022
SELECT d.name AS department_name, AVG(s.amount) AS average_salary
FROM departments d
JOIN employees e ON d.id = e.department_id
JOIN salaries s ON e.id = s.employee_id
WHERE s.year = 2022
GROUP BY d.name;

-- Query to retrieve the employee with the highest salary in each department for the year 2021
SELECT d.name AS department_name, e.name AS employee_name, s.amount AS salary
FROM departments d
JOIN employees e ON d.id = e.department_id
JOIN salaries s ON e.id = s.employee_id
WHERE s.year = 2021 AND s.amount = (
    SELECT MAX(amount)
    FROM salaries
    WHERE employee_id = e.id
    AND year = s.year
);

-- Query to calculate the total salary expense for the year 2021
SELECT SUM(amount) AS total_salary_expense
FROM salaries
WHERE year = 2021;
