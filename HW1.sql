SELECT *
FROM employees
WHERE gender = 'F'
	AND (hire_date = '1990-01-01' OR hire_date >= '2000-01-01');

SELECT first_name, last_name
FROM employees
WHERE first_name = last_name;

SELECT first_name, last_name, gender, hire_date
FROM employees
WHERE emp_no BETWEEN 10001 AND 10004;

SELECT dept_name
FROM departments
WHERE dept_name LIKE '%a%'
	OR dept_name LIKE '_e%';
    
SELECT *
FROM employees
WHERE gender = 'M'
	AND TIMESTAMPDIFF(YEAR, birth_date, hire_date) = 45
    AND MONTH(birth_date) = 10
    AND DAYOFWEEK(hire_date) = 1;
    
SELECT MAX(salary)
FROM salaries
WHERE from_date > '1995-06-01';

SELECT dept_no, COUNT(emp_no) AS employees_count
FROM dept_emp
WHERE to_date > CURRENT_DATE
GROUP BY dept_no
HAVING COUNT(*) > 13000
ORDER BY employees_count DESC;

SELECT emp_no, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM salaries
GROUP BY emp_no;