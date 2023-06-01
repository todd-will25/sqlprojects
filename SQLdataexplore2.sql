--working with dates and time and manipulating based different criteria
-- Create a table for tasks
CREATE TABLE tasks (
    id INT PRIMARY KEY,
    task_name VARCHAR(50),
    due_date DATE,
    status VARCHAR(20)
);

-- Insert sample data
INSERT INTO tasks (id, task_name, due_date, status)
VALUES (1, 'Task 1', '2023-05-25', 'Pending'),
       (2, 'Task 2', '2023-05-20', 'Completed'),
       (3, 'Task 3', '2023-05-18', 'Pending'),
       (4, 'Task 4', '2023-05-27', 'Pending'),
       (5, 'Task 5', '2023-05-30', 'Completed');

-- Query to retrieve tasks due today
SELECT id, task_name
FROM tasks
WHERE due_date = CONVERT(DATE, GETDATE());

-- Query to retrieve tasks that are overdue
SELECT id, task_name, due_date
FROM tasks
WHERE due_date < CONVERT(DATE, GETDATE())
AND status = 'Pending';

-- Query to update the status of tasks that are overdue to 'Delayed'
UPDATE tasks
SET status = 'Delayed'
WHERE due_date < CONVERT(DATE, GETDATE())
AND status = 'Pending';

-- Query to calculate the average time taken to complete tasks
SELECT AVG(DATEDIFF(DAY, due_date, GETDATE())) AS avg_completion_time
FROM tasks
WHERE status = 'Completed';

-- Query to retrieve the number of tasks completed per day
SELECT CONVERT(VARCHAR(10), due_date, 120) AS completion_date, COUNT(*) AS task_count
FROM tasks
WHERE status = 'Completed'
GROUP BY CONVERT(VARCHAR(10), due_date, 120);
