Table: employee

The employee table has three columns: Employee Id, Company Name, and Salary.
+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1     | A           | 2341   |
|2     | A           | 341    |
|3     | A           | 15     |
|4     | A           | 15314  |
|5     | A           | 451    |
|6     | A           | 513    |
|7     | B           | 15     |
|8     | B           | 13     |
|9     | B           | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+

Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

Result table:
+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|5      | A          | 451    |
|6      | A          | 513    |
|12    | B          | 234    |
|9      | B          | 1154   |
|14    | C          | 2645   |
+-----+------------+--------+


-----------------solution 
with cte as (

Select 
id ,
company,
salary,
count(company) over (partition by company )cnt,
row_number() over (partition by company order by salary ) rn
from employee
)
select 
id,
company,
salary
from cte
where
rn in ((cnt+1)/2,(cnt+2)/2)
order by company, salary Asc, id




SELECT  
    Id, 
    Company, 
    Salary 
FROM ( 
        SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY COMPANY ORDER BY Salary ASC, Id ASC) AS RN_ASC,
        ROW_NUMBER() OVER(PARTITION BY COMPANY ORDER BY Salary DESC, Id DESC) AS RN_DESC 
        FROM Employee
     ) AS temp 
WHERE RN_ASC BETWEEN RN_DESC - 1 AND RN_DESC + 1 
ORDER BY Company, Salary;


-- 1 6  (5, 7)
-- 2 5  (4, 6)
-- 3 4  (3, 5)
-- 4 3  (2, 4)
-- 5 2  (1, 3)
-- 6 1  (0, 2)

-- seLect * from employee
-- where 1 between 5 and  7; --true

-- seLect * from employee
-- where 3 between 3 and  5; --true


-- Tsql
SELECT
    DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY salary) OVER (partition by company) AS Median
FROM
    Employee;


-- snowflake/ bigquery
SELECT
    median(salary) OVER (partition by company) AS Median
FROM
    Employee;



