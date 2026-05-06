
# Create a new database 
CREATE DATABASE hr_analytics;
USE hr_analytics;

# Create the employees table 
CREATE TABLE employees(
Age INT,
Attrition VARCHAR(3),
BussinessTravel VARCHAR(50),
DailyRate INT,
Department VARCHAR(50),
DistanceFromHome INT,
Education INT,
EducationField VARCHAR(50),
EmployeeCount INT,
EmployeeNumber INT PRIMARY KEY,
EnvironmentSatisfaction INT,
Gender VARCHAR(10),
HourlyRate INT,
JobInvolvement INT,
JobLevel INT,
JobRole VARCHAR(50),
JobSatisfaction INT,
MaritalStatus VARCHAR(20),
MonthlyIncome INT,
MonthlyRate INT,
NumCompaniesWorked INT,
Over18 VARCHAR(3),
OverTime VARCHAR(3),
PercentSalaryHike INT,
PerformanceRating INT,
RelationshipSatisfaction INT,
StandardHours INT,
StockOptionLevel INT,
TotalWorkingYears INT,
TrainingTimesLastYear INT,
WorkLifeBalance INT,
YearsAtCompany INT,
YearsInCurrentRole INT,
YearsSinceLastPromotion INT,
YearsWithCurrManager INT
);

SELECT COUNT(*) FROM employees;
SELECT * FROM employees LIMIT 5;

# First 10 employees 
SELECT 
EmployeeNumber,
Age,
Gender,
Department,
JobRole,
MonthlyIncome,
Attrition
From employees 
LIMIT 10;


# Overall Attrition Rate 
SELECT 
Attrition,
COUNT(*) AS employee_count,
ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM employees),2) AS percentage 
FROM employees
GROUP BY Attrition;

# Attrition Rate by Department 
SELECT 
department, 
COUNT(*) AS total_employees,
SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END) AS left_count,
ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS attrition_rate
FROM employees
GROUP BY Department
ORDER BY attrition_rate DESC;



# Overtime vs Attrition
SELECT 
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employees
GROUP BY OverTime;


# Income Difference (Stayed vs Left)
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 0) AS avg_income,
    ROUND(MIN(MonthlyIncome), 0) AS min_income,
    ROUND(MAX(MonthlyIncome), 0) AS max_income
FROM employees
GROUP BY Attrition;

#Employees with Multiple Risk Factors
SELECT 
    Department,
    JobRole,
    OverTime,
    MaritalStatus,
    MonthlyIncome,
    YearsAtCompany,
    Attrition
FROM employees
WHERE OverTime = 'Yes' 
  AND MonthlyIncome < 5000
  AND YearsAtCompany < 3
ORDER BY MonthlyIncome ASC
LIMIT 10;


# Job Roles with Highest Attrition
SELECT 
    JobRole,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate,
    ROUND(AVG(MonthlyIncome), 0) AS avg_income
FROM employees
GROUP BY JobRole
HAVING COUNT(*) > 10
ORDER BY attrition_rate DESC
LIMIT 5;


#Attrition by Age Group
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM employees
GROUP BY age_group
ORDER BY age_group;

# Create aggregated table for Tableau
SELECT 
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate,
    ROUND(AVG(MonthlyIncome), 0) AS avg_income,
    ROUND(AVG(YearsAtCompany), 1) AS avg_tenure
FROM employees
GROUP BY Department;


#Income Brackets Analysis
SELECT 
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium (3k-6k)'
        WHEN MonthlyIncome BETWEEN 6000 AND 10000 THEN 'High (6k-10k)'
        ELSE 'Very High (>10k)'
    END AS income_bracket,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM employees
GROUP BY income_bracket
ORDER BY attrition_rate DESC;


# Work-Life Balance vs Attrition
SELECT 
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Bad'
        WHEN WorkLifeBalance = 2 THEN 'Good'
        WHEN WorkLifeBalance = 3 THEN 'Better'
        ELSE 'Best'
    END AS wlb_rating,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;


# Satisfaction Score vs Attrition
SELECT 
    JobSatisfaction,
    CASE 
        WHEN JobSatisfaction = 1 THEN 'Low'
        WHEN JobSatisfaction = 2 THEN 'Medium'
        WHEN JobSatisfaction = 3 THEN 'High'
        ELSE 'Very High'
    END AS satisfaction_label,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate,
    ROUND(AVG(MonthlyIncome), 0) AS avg_income
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


# Years Since Last Promotion vs Attrition
SELECT 
    CASE 
        WHEN YearsSinceLastPromotion = 0 THEN 'Just Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 Years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 Years'
        ELSE 'Over 5 Years'
    END AS promotion_gap,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM employees
GROUP BY promotion_gap
ORDER BY attrition_rate DESC;
