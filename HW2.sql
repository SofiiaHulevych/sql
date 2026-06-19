SELECT
	e.first_name,
    e.last_name,
    d.dept_name,
    t.title,
    TIMESTAMPDIFF(YEAR, t.from_date, CURDATE()) AS years_in_position,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_in_company
FROM employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
INNER JOIN titles t ON e.emp_no = t.emp_no
WHERE s.salary = (SELECT MAX(salary) FROM salaries WHERE to_date > CURRENT_DATE)
	AND s.to_date > CURRENT_DATE
    AND de.to_date > CURRENT_DATE
    AND t.to_date > CURRENT_DATE;
    
SELECT
	d.dept_name,
    e.first_name,
    e.last_name,
    s.salary
FROM employees e
INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
INNER JOIN departments d ON dm.dept_no = d.dept_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE dm.to_date > CURRENT_DATE
	AND s.to_date > CURRENT_DATE;
    
SELECT
	e.emp_no,
    s_emp.salary AS employee_salary, s_mgr.salary AS manager_salary
FROM employees e
INNER JOIN salaries s_emp ON e.emp_no = s_emp.emp_no
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN dept_manager dm ON de.dept_no = dm.dept_no
INNER JOIN salaries s_mgr ON dm.emp_no = s_mgr.emp_no
WHERE s_emp.to_date > CURRENT_DATE
	AND de.to_date > CURRENT_DATE
    AND dm.to_date > CURRENT_DATE
    AND s_mgr.to_date > CURRENT_DATE
ORDER BY e.emp_no;

SELECT
	e.emp_no,
    s_emp.salary AS employee_salary,
    s_mgr.salary AS manager_salary
FROM employees e
INNER JOIN salaries s_emp ON e.emp_no = s_emp.emp_no
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN dept_manager dm ON de.dept_no = dm.dept_no
INNER JOIN salaries s_mgr ON dm.emp_no = s_mgr.emp_no
WHERE s_emp.to_date > CURRENT_DATE
	AND de.to_date > CURRENT_DATE
    AND dm.to_date > CURRENT_DATE
    AND s_mgr.to_date > CURRENT_DATE
    AND s_emp.salary > s_mgr.salary
ORDER BY e.emp_no;

SELECT title, COUNT(emp_no) AS employees_count
FROM titles
WHERE to_date > CURRENT_DATE
GROUP BY title 
ORDER BY employees_count DESC;

SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
HAVING COUNT(DISTINCT de.dept_no) > 1;

SELECT 
	EXTRACT(YEAR FROM from_date) AS salary_year, ROUND(AVG(salary) / 1000, 2) AS avg_salary_k, ROUND(MAX(salary) / 1000, 2) AS max_salary_k
FROM salaries
GROUP BY EXTRACT(YEAR FROM from_date)
ORDER BY salary_year;

SELECT gender, COUNT(emp_no) AS employees_count
FROM employees
WHERE DAYOFWEEK(hire_date) IN (1, 7)
GROUP BY gender;