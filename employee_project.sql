-- ==========================================================

-- Employee Management System — SQL Project Documentation

-- ==========================================================
/*
-- ============================================================

 Project Title
 
-- ============================================================

Employee Management System – SQL Data Analysis*/

/*
Project Overview

The Employee Management System is a relational database project developed using MySQL to manage and analyze employee-related information. The system stores information about employees, departments, job roles, salaries, bonuses, qualifications, leaves, and payroll.

The project consists of six interconnected tables: JobDepartment, SalaryBonus, Employee, Qualification, Leaves, and Payroll. Primary keys and foreign keys are used to establish relationships between the tables and maintain data integrity.

SQL queries are used to analyze employee distribution, salary structures, job roles, qualifications, leave patterns, bonuses, and payroll information.


 Domain
Employee Management

Employee management involves maintaining information related to employees within an organization, including their personal information, job roles, departments, salaries, qualifications, leaves, and payroll.

The main areas covered in this project are:

Employee Information Management
Job Role Assignment
Departmental Structure
Salary and Compensation
Employee Qualifications
Leave and Absence Management
Payroll Management


Problem Statement

Organizations maintain large amounts of employee information such as employee details, departments, job roles, salaries, qualifications, leaves, and payroll.

Managing this information manually can make it difficult to:

Find employee information quickly
Analyze employee distribution
Compare salaries between departments
Track employee qualifications
Analyze leave patterns
Calculate payroll information
Compare bonuses
Identify salary trends

Therefore, a structured relational database is required to efficiently store, manage, retrieve, and analyze employee information using SQL.

 ============================================================
 Project Objectives
============================================================

The main objectives of this project are:

To create a structured database for employee management.
To maintain employee and department information.
To manage job roles and salary information.
To store employee qualification details.
To track employee leave records.
To manage payroll information.
To analyze salaries and bonuses across departments.
To identify employee and departmental patterns.
To use SQL queries for business analysis.
To generate meaningful insights from employee-related data.

These objectives align with the project presentation's stated goals around employee, salary, qualification, leave, and payroll analysis.


Tools and Technologies: 

Tool / Technology	Purpose
MySQL	Database creation and SQL analysis
MySQL Workbench	Writing and executing SQL queries
SQL	Data management and analysis
ER Model	Understanding database relationships

Database Structure

The project contains 6 main tables:

JobDepartment
SalaryBonus
Employee
Qualification
Leaves
Payroll
*/


-- create database

create database employee_project;

-- use that data base

use employee_project;

-- ============================================================
-- Table 1: Job Department
-- ============================================================

CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- ============================================================
-- Table 2: Salary/Bonus
-- ============================================================

CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Table 3: Employee
-- ============================================================

CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================================
-- Table 4: Qualification
-- ============================================================

CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- Table 5: Leaves
-- ============================================================

CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Table 6: Payroll
-- ============================================================

CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

/*
Six relational tables were successfully created for the Employee Management System.
Primary keys and foreign keys establish relationships between employees, departments, salaries, qualifications, leaves, and payroll.
The database structure is ready for data insertion and SQL analysis.
*/

show tables;
select * from employee;
select * from jobdepartment;
select * from leaves;
select * from payroll;
select * from qualification;
select * from salarybonus;

/*
All six tables were successfully retrieved and verified.
The data contains employee, department, salary, qualification, leave, and payroll details.
This confirms that the database tables are properly created and populated.
*/

-- ============================================================
-- Analysis Questions
-- ============================================================

-- ============================================================
-- 1. EMPLOYEE INSIGHTS
-- ============================================================

-- How many unique employees are currently in the system?

select count(distinct emp_id) as unique_employees from employee;

/*
The query counts the distinct employee IDs in the employee table.
It removes duplicate employee IDs using DISTINCT.
The result shows there are 60 unique employees in the system.
*/

-- Which departments have the highest number of employees?

select jd.jobdept as department, count(distinct e.emp_id) as employee_count from employee e
join  jobdepartment jd on e.job_id = jd.job_id
group by jd.jobdept
order by employee_count desc;

/*
The query counts the unique employees in each department.
Finance and IT have the highest number of employees, with 9 employees each.
Legal has the lowest number, with 5 employees.
*/

-- What is the average salary per department?

select jd.jobdept, avg(sb.annual) as avg_salary from jobdepartment jd 
join  salarybonus sb on jd.job_id = sb.job_id
group by jd.jobdept
order by avg_salary desc;

/*
he query calculates the average annual salary for each department.
Legal has the highest average salary at ₹10,15,200.
HR has the lowest average salary at ₹7,50,857.14.
*/

-- Who are the top 5 highest-paid employees?

select e.emp_id, max(sb.annual) as max_anual_salary from employee e
join  salarybonus sb on e.job_id = sb.job_id
group by e.emp_id
order by max_anual_salary desc
limit 5;

/*
The query identifies the top 5 highest-paid employees based on annual salary.
MAX() gets the highest salary associated with each employee.
The results are sorted from highest to lowest salary, and LIMIT 5 returns the top five employees.
*/

-- What is the total salary expenditure across the company?

select sum(sb.annual) as sum_of_anual_salary from employee e
join  salarybonus sb on e.job_id = sb.job_id;

/*
The query calculates the total annual salary expenditure across the company.
SUM() adds the annual salaries of employees after joining the Employee and SalaryBonus tables.
The total salary expenditure is ₹5,18,52,000.
*/

-- ============================================================
-- 2. JOB ROLE AND DEPARTMENT ANALYSIS
-- ============================================================

-- How many different job roles exist in each department?

select jobdept, count(distinct name) from jobdepartment
group by jobdept
order by count(distinct name) desc;

/*
The query counts the different job roles in each department using COUNT(DISTINCT name).
Finance has the highest number of different job roles, with 9 roles.
Legal has the lowest number, with 5 roles.

*/


-- What is the average salary range per department?

select jobdept,
round(avg((
cast(replace(trim(substring_index(salaryrange, '-', 1)), '$', '') as decimal(10,2))
+
cast(replace(trim(substring_index(salaryrange, '-', -1)), '$', '') as decimal(10,2))) / 2
        ), 2
 ) as average_salary_range
from JobDepartment
group by jobdept
order by average_salary_range desc;

/*
SELECT → Selects the required columns from a table.
SUBSTRING_INDEX() → Extracts a specific part of a string based on a delimiter.
TRIM() → Removes extra spaces from the beginning and end of a string.
REPLACE() → Removes or replaces specified characters or text.
CAST() → Converts a value from one data type to another.
DECIMAL() → Defines a numeric value with fixed decimal precision.
+ → Adds the lower and upper salary values.
/ 2 → Calculates the midpoint of the salary range.
AVG() → Calculates the average value.
ROUND() → Rounds a number to the specified decimal places.
AS → Gives a temporary name (alias) to a column.
FROM → Specifies the table from which data is retrieved.
GROUP BY → Groups rows based on a column.
ORDER BY → Sorts the result.
DESC → Sorts values from highest to lowest.
*/

/*
The query calculates the average salary range for each department by finding the midpoint of the minimum and maximum salary.
SUBSTRING_INDEX(), TRIM(), REPLACE(), and CAST() are used to convert the salary range into numeric values.
The departments are then sorted from the highest to the lowest average salary range.
*/


-- Which job roles offer the highest salary?

select jd.jobdept, max(sb.annual) as max_salary from jobdepartment jd
join salarybonus sb on jd.job_id = sb.job_id
group by jd.jobdept
order by max_salary desc;

/*
The query identifies the highest annual salary offered in each department.
MAX() finds the highest salary, and departments are sorted from highest to lowest salary.
Finance has the highest maximum salary, followed by Engineering and IT.
*/


-- Which departments have the highest total salary allocation?

select jd.jobdept, max(sb.annual) as highest_total_salary_allocation from jobdepartment jd
join salarybonus sb on jd.job_id = sb.job_id
group by jd.jobdept
order by highest_total_salary_allocation desc
limit 1;

/*
The query identifies the department with the highest annual salary allocation.
MAX() finds the highest annual salary for each department, and LIMIT 1 returns the top department.
Finance has the highest salary allocation, based on the current query.
*/

-- ============================================================
-- 3. QUALIFICATION AND SKILLS ANALYSIS
-- ============================================================

-- How many employees have at least one qualification listed?

select count(distinct emp_id) from qualification;

/*
The query counts the number of employees who have at least one qualification.
COUNT(DISTINCT emp_id) ensures each employee is counted only once.
The result shows that 60 employees have at least one qualification listed.
*/

-- Which positions require the most qualifications?

select position, count(*) as total_count from qualification
group by position
order by total_count desc;

/*
The query counts the number of qualifications required for each position.
GROUP BY position groups the records based on job position.
The results are sorted from the position requiring the most qualifications to the least.
*/

-- Which employees have the highest number of qualifications?

select e.emp_id, e.firstname, e.lastname, count(*) as total_count from employee e join 
qualification q on e.emp_id = q.emp_id
group by e.emp_id,e.firstname, e.lastname
order by total_count desc;

/*
The query counts the number of qualifications for each employee.
COUNT(*) calculates the total qualifications, and GROUP BY groups them employee-wise.
The results are sorted from the highest number of qualifications to the lowest.
*/

-- ============================================================
-- 4. LEAVE AND ABSENCE PATTERNS
-- ============================================================

-- Which year had the most employees taking leaves?

select year(date), count(distinct emp_id) as total_count from leaves
group by year(date)
order by total_count desc;

/*
The query identifies the year with the highest number of employees taking leave.
COUNT(DISTINCT emp_id) counts each employee only once per year.
The results are sorted from the year with the most employees taking leave to the least.
*/

-- What is the average number of leave days taken by its employees per department?

SELECT
    jd.jobdept AS department,
    AVG(leave_count) AS average_leave_days
FROM (
    SELECT e.emp_ID, e.Job_ID, COUNT(l.leave_ID) AS leave_count FROM Employee e
    LEFT JOIN Leaves l ON e.emp_ID = l.emp_ID
    GROUP BY e.emp_ID, e.Job_ID
) AS employee_leaves
JOIN JobDepartment jd
    ON employee_leaves.Job_ID = jd.Job_ID
GROUP BY jd.jobdept
ORDER BY average_leave_days DESC;

/*
The query calculates the average number of recorded leave entries per employee in each department.
COUNT() calculates each employee’s leave count, and AVG() calculates the department-wise average.
The results are sorted from the highest average leave count to the lowest.
*/

-- Which employees have taken the most leaves?

select e.emp_ID, e.firstname, e.lastname, count(l.leave_ID) as total_leaves from Employee e
join Leaves l on e.emp_ID = l.emp_ID
group by e.emp_ID, e.firstname, e.lastname
order by total_leaves desc
limit 5;

/*
The query identifies the top 5 employees who have taken the most leaves.
COUNT() calculates the total leaves for each employee, and ORDER BY sorts them in descending order.
LIMIT 5 displays only the five employees with the highest number of leaves.
*/


-- What is the total number of leave days taken company-wide?

select count(leave_id) as total_leave_days
from leaves;

/*
The query calculates the total number of leave records taken across the company.
COUNT(leave_id) counts every leave entry in the leaves table.
The result represents the total recorded leave entries company-wide.
*/

-- How do leave days correlate with payroll amounts?

select e.emp_id, e.firstname, e.lastname,
    count(l.leave_id) as total_leave_days,
    sum(p.total_amount) as total_payroll_amount from employee e
left join leaves l on e.emp_id = l.emp_id
left join payroll p on e.emp_id = p.emp_id
group by e.emp_id, e.firstname, e.lastname
order by total_leave_days desc;

/*
The query compares employees’ recorded leave days with their total payroll amounts.
COUNT() calculates leave entries, while SUM() calculates the total payroll amount for each employee.
The results are sorted by highest number of leave entries, helping identify the relationship between leave and payroll.
*/

-- ============================================================
-- 5. PAYROLL AND COMPENSATION ANALYSIS
-- ============================================================

-- What is the total monthly payroll processed?

select sum(total_amount) as total_monthly_payroll
from payroll;

/*
The query calculates the total payroll amount processed by the company.
SUM(total_amount) adds all payroll amounts from the payroll table.
The result represents the total payroll processed for the available payroll records.
*/

-- What is the average bonus given per department?

select jd.jobdept as department, avg(sb.bonus) as average_bonus from jobdepartment jd
join salarybonus sb on jd.job_id = sb.job_id
group by jd.jobdept
order by average_bonus desc;

/*
The query calculates the average bonus received in each department.
AVG(sb.bonus) calculates the average bonus for each department.
The results are sorted from the highest average bonus to the lowest.
*/

-- Which department receives the highest total bonuses?

select jd.jobdept as department, sum(sb.bonus) as total_bonus from jobdepartment jd
join salarybonus sb on jd.job_id = sb.job_id
group by jd.jobdept
order by total_bonus desc
limit 1;

/*
The query calculates the total bonus received by each department using SUM().
The results are sorted from highest to lowest total bonus.
LIMIT 1 identifies the department receiving the highest total bonus.
*/


-- What is the average value of total_amount after considering leave deductions?

select avg(total_amount) as average_total_amount
from payroll;

/*
The query calculates the average payroll amount recorded in the payroll table.
AVG(total_amount) calculates the average value of all payroll amounts.
The result represents the average payroll amount after leave-related adjustments recorded in the payroll data.
*/


-- What is the most common reason for taking leave?

select reason, count(*) as leave_count from leaves
group by reason
order by leave_count desc
limit 1;

/*
The query identifies the most common reason for taking leave.
COUNT(*) counts leave records for each reason, and GROUP BY groups them by reason.
ORDER BY sorts the reasons by frequency, and LIMIT 1 returns the most frequent leave reason.
*/


-- What is the average age of employees in each department?

select jd.jobdept as department, avg(e.age) as average_age from employee e
join jobdepartment jd on e.job_id = jd.job_id
group by jd.jobdept
order by average_age desc;

/*
he query calculates the average age of employees in each department.
AVG(e.age) finds the average age, while GROUP BY calculates it separately for each department.
ORDER BY average_age DESC displays departments from highest to lowest average age.
*/


-- How many employees are there in each gender category?

select gender, count(*) as employee_count from employee
group by gender
order by employee_count desc;

/*
The query counts the number of employees in each gender category.
GROUP BY gender groups employees based on their gender, and COUNT(*) counts employees in each group.
ORDER BY employee_count DESC displays the gender categories from highest to lowest employee count.
*/

-- Which job role has the lowest annual salary?

select jd.name as job_role, sb.annual as annual_salary from jobdepartment jd
join salarybonus sb on jd.job_id = sb.job_id
order by sb.annual
limit 1;

/*
The query identifies the job role with the lowest annual salary.
ORDER BY sb.annual sorts salaries from lowest to highest.
LIMIT 1 returns only the job role with the lowest annual salary.
*/

-- Which job role has the Highest annual salary?

SELECT 
    jd.name AS job_role, sb.annual AS annual_salary
FROM
    jobdepartment jd
        JOIN
    salarybonus sb ON jd.job_id = sb.job_id
ORDER BY sb.annual DESC
LIMIT 1;

/*
The query identifies the job role with the highest annual salary.
ORDER BY sb.annual DESC sorts salaries from highest to lowest.
LIMIT 1 returns only the job role with the highest annual salary.
*/
-- Rank employees by annual salary

select e.emp_id, e.firstname, e.lastname, sb.annual,
rank() over (order by sb.annual desc) as salary_rank from employee e
join salarybonus sb on e.job_id = sb.job_id;

/*
The query ranks all employees based on their annual salary.
RANK() assigns a salary rank, with the highest salary receiving rank 1.
ORDER BY sb.annual DESC sorts employees from highest to lowest annual salary.
*/


-- Rank employees within each department

select e.emp_id, e.firstname, e.lastname, jd.jobdept as department, sb.annual,
rank() over ( partition by jd.jobdept order by sb.annual desc ) as department_rank from employee e
join jobdepartment jd on e.job_id = jd.job_id
join salarybonus sb on e.job_id = sb.job_id;

/*
The query ranks employees separately within each department based on annual salary.
PARTITION BY jd.jobdept creates a separate ranking group for each department.
RANK() assigns rank 1 to the highest-paid employee in each department.
*/

-- How are employees ranked by annual salary within each department?

select e.emp_id, e.firstname, e.lastname, jd.jobdept as department, sb.annual,
rank() over (partition by jd.jobdept
order by sb.annual desc) as department_rank from employee e
join jobdepartment jd on e.job_id = jd.job_id
join salarybonus sb on e.job_id = sb.job_id
order by jd.jobdept, department_rank;


/*
he query ranks employees by annual salary within each department.
PARTITION BY jd.jobdept creates a separate salary ranking for every department.
ORDER BY jd.jobdept, department_rank displays employees department-wise and rank-wise, with the highest-paid employee ranked 1st in each department.
*/

-- ============================================================
-- Queries + Outputs + Insights
-- ============================================================

/*
SQL queries were used to analyze employee, department, salary, qualification, leave, and payroll data.
Aggregate functions such as COUNT(), SUM(), AVG(), and MAX() were used to generate meaningful results.
JOIN, GROUP BY, ORDER BY, subqueries, and window functions were used for deeper analysis.
*/

-- ============================================================
-- Key Findings
-- ============================================================

/*
The database contains 60 unique employees.
Finance and IT have the highest number of employees, with 9 employees each.
Legal has the highest average salary among the departments.
The total annual salary expenditure is ₹5,18,52,000.
Salary ranking helped identify the highest-paid employees within the company and each department.
*/


-- ============================================================
-- Challenges
-- ============================================================
/*
Managing relationships between six interconnected tables.
Handling salary data and converting values into suitable numeric formats.
Understanding and applying JOINs, GROUP BY, subqueries, and window functions.
Analyzing leave and payroll information accurately.
*/


-- ============================================================
-- Learning Outcomes
-- ============================================================

/*
Gained practical experience in MySQL and relational database management.
Learned to write SQL queries for real-world business analysis.
Improved understanding of JOINs, aggregate functions, subqueries, and window functions.
Learned how to convert raw database information into meaningful business insights.
*/


-- ============================================================
-- Future Scope
-- ============================================================

/*
Develop an interactive Power BI dashboard using the SQL database.
Add employee attendance and performance tracking.
Automate payroll and leave calculations.
Add advanced employee analytics and reporting.
Implement role-based access and improved database security.
*/


-- ============================================================
-- Conclusion
-- ============================================================

/*
he Employee Management System successfully demonstrates how SQL can be used to store, manage, and analyze employee-related information.
The database consists of interconnected tables covering employees, departments, salaries, bonuses, qualifications, leaves, and payroll.
SQL concepts such as JOINs, aggregate functions, GROUP BY, ORDER BY, subqueries, and window functions were applied to answer business questions.
The analysis helped identify important insights related to employee distribution, salary patterns, job roles, qualifications, leaves, and payroll.
Overall, this project provided practical experience in database design, SQL querying, data analysis, and generating business insights.
*/