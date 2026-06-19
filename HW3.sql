SELECT
	CASE
		WHEN TIMESTAMPDIFF(YEAR, birth_date, hire_date) < 25 THEN '< 25 y.o'
        WHEN TIMESTAMPDIFF(YEAR, birth_date, hire_date) BETWEEN 25 AND 44 THEN '25-44 y.o.'
        WHEN TIMESTAMPDIFF(YEAR, birth_date, hire_date) BETWEEN 45 AND 54 THEN '45-54 y.o.'
        ELSE '>= 55 y.o.'
	END AS hiring_age, MAX(s.salary) AS max_salary
FROM employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date > CURRENT_DATE
GROUP BY hiring_age
ORDER BY hiring_age;

WITH last_title AS (SELECT emp_no, MAX(to_date) AS max_to_date FROM titles GROUP BY emp_no)
SELECT t.title, s.salary
FROM titles t
INNER JOIN last_title lt ON t.emp_no = lt.emp_no AND t.to_date = lt.max_to_date
INNER JOIN salaries s ON t.emp_no = s.emp_no
INNER JOIN dept_emp de ON t.emp_no = de.emp_no
WHERE s.to_date < CURRENT_DATE
	AND t.to_date < CURRENT_DATE
    AND de.to_date < CURRENT_DATE
ORDER BY s.salary DESC
LIMIT 1;

SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, s.salary
FROM employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date > CURRENT_DATE
ORDER BY s.salary DESC
LIMIT 10;

SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, s.salary
FROM employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date > CURRENT_DATE
	AND s.salary > (SELECT AVG(salary) FROM salaries WHERE to_date > CURRENT_DATE)
ORDER BY e.emp_no;

SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.dept_name
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
INNER JOIN (SELECT dept_no FROM dept_emp WHERE to_date > CURRENT_DATE GROUP BY dept_no HAVING COUNT(emp_no) > 20000) big_depts ON de.dept_no = big_depts.dept_no
WHERE de.to_date > CURRENT_DATE;

SELECT s.emp_no, s.salary
FROM salaries s
WHERE s.to_date > CURRENT_DATE
	AND s.salary > (SELECT MAX(s2.salary) 
					FROM salaries s2
                    INNER JOIN dept_emp de ON s2.emp_no = de.emp_no
                    INNER JOIN departments d ON de.dept_no = d.dept_no
                    WHERE s2.to_date > CURRENT_DATE
                    AND de.to_date > CURRENT_DATE
                    AND d.dept_name = 'Finance'
                    );
                    
SELECT DISTINCT d.dept_name
FROM departments d
INNER JOIN dept_emp de ON d.dept_no = de.dept_no
INNER JOIN salaries s ON de.emp_no = s.emp_no
WHERE s.salary > 150000;