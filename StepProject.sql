SELECT EXTRACT(YEAR FROM from_date) AS salary_year, ROUND(AVG(salary), 2) AS avg_salary
FROM salaries
WHERE from_date < '2005-01-01'
GROUP BY salary_year
ORDER BY salary_year;

SELECT d.dept_name, ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
INNER JOIN dept_emp de ON d.dept_no = de.dept_no
INNER JOIN salaries s ON de.emp_no = s.emp_no
WHERE de.to_date > CURRENT_DATE
	AND s.to_date > CURRENT_DATE
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

SELECT d.dept_name, EXTRACT(YEAR FROM s.from_date) AS salary_year, ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
INNER JOIN dept_emp de ON d.dept_no = de.dept_no
INNER JOIN salaries s ON de.emp_no = s.emp_no
WHERE s.from_date < '2005-01-01'
GROUP BY d.dept_name, salary_year
ORDER BY d.dept_name, salary_year;

SELECT d.dept_name, COUNT(de.emp_no) AS employees_count
FROM departments d
INNER JOIN dept_emp de ON d.dept_no = de.dept_no
WHERE de.to_date > CURRENT_DATE
GROUP BY d.dept_name
HAVING COUNT(de.emp_no) > 15000
ORDER BY employees_count DESC;

SELECT e.emp_no, e.last_name, e.hire_date, d.dept_name
FROM employees e 
INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
INNER JOIN departments d ON dm.dept_no = d.dept_no
WHERE dm.to_date > CURRENT_DATE
ORDER BY e.hire_date ASC
LIMIT 1;

WITH dept_avg AS 
	(SELECT de.dept_no, ROUND(AVG(s.salary), 2) AS avg_dept_salary
    FROM dept_emp de
    INNER JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.to_date > CURRENT_DATE
    AND s.to_date > CURRENT_DATE
    GROUP BY de.dept_no)
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, s.salary, da.avg_dept_salary, ROUND(s.salary - da.avg_dept_salary, 2) AS salary_diff
FROM employees e 
INNER JOIN salaries s ON e.emp_no = s.emp_no
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN dept_avg da ON de.dept_no = da.dept_no
WHERE s.to_date > CURRENT_DATE
	AND de.to_date > CURRENT_DATE
ORDER BY salary_diff DESC
LIMIT 10;

WITH ranked_managers AS 
	(SELECT dm.dept_no, dm.emp_no, dm.from_date, 
    ROW_NUMBER() OVER (PARTITION BY dm.dept_no ORDER BY dm.from_date)
    AS manager_rank FROM dept_manager dm)
SELECT d.dept_name, e.first_name, e.last_name, e.hire_date, rm.from_date AS manager_start_date
FROM ranked_managers rm
INNER JOIN employees e ON rm.emp_no = e.emp_no
INNER JOIN departments d ON rm.dept_no = d.dept_no
WHERE rm.manager_rank = 2;

CREATE DATABASE IF NOT EXISTS courses;
USE courses;
CREATE TABLE IF NOT EXISTS teachers (teacher_no INT AUTO_INCREMENT PRIMARY KEY, teacher_name VARCHAR(100) NOT NULL, phone_no VARCHAR(20) NOT NULL);
CREATE TABLE IF NOT EXISTS courses (course_no INT AUTO_INCREMENT PRIMARY KEY, course_name VARCHAR(100) NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL);
CREATE TABLE IF NOT EXISTS students (student_no INT AUTO_INCREMENT PRIMARY KEY, teacher_no INT NOT NULL, course_no INT NOT NULL, student_name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL, birth_date DATE NOT NULL, FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no), FOREIGN KEY (course_no) REFERENCES courses(course_no));

START TRANSACTION;
INSERT INTO teachers (teacher_name, phone_no) VALUES
('James Morrison', '+1234567890'),
('Elena Vasquez', '+0987654321'),
('Kai Tanaka', '+1122334455'),
('Sofia Reeves', '+5544332211'),
('Marcus Webb', '+9988776655');
INSERT INTO courses (course_name, start_date, end_date) VALUES
('Music Theory Basics', '2024-01-15', '2024-03-15'),
('Guitar for Beginners', '2024-02-01', '2024-04-01'),
('Music Production', '2024-03-01', '2024-05-01'),
('Vocal Training', '2024-04-01', '2024-06-01'),
('DJ & Electronic Music', '2024-05-01', '2024-07-01');
INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(1, 1, 'Liam Carter', 'liam@gmail.com', '2001-03-12'),
(1, 2, 'Zoe Mitchell', 'zoe@gmail.com', '2000-07-24'),
(2, 1, 'Noah Bennett', 'noah@gmail.com', '1999-11-05'),
(2, 3, 'Mia Sullivan', 'mia@gmail.com', '2001-08-30'),
(3, 2, 'Ethan Rivera', 'ethan@gmail.com', '2000-04-17'),
(3, 4, 'Ava Chen', 'ava@gmail.com', '1998-09-22'),
(4, 3, 'Lucas Kim', 'lucas@gmail.com', '2001-01-08'),
(4, 5, 'Emma Walsh', 'emma@gmail.com', '1999-06-14'),
(5, 4, 'Oliver Stone', 'oliver@gmail.com', '2000-12-03'),
(5, 5, 'Isabella Park', 'isabella@gmail.com', '1998-02-28');
COMMIT;

SELECT t.teacher_name, COUNT(s.student_no) AS students_count
FROM teachers t 
INNER JOIN students s ON t.teacher_no = s.teacher_no
GROUP BY t.teacher_name
ORDER BY students_count DESC;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
SELECT teacher_no, course_no, student_name, email, birth_date
FROM students
LIMIT 3;

SELECT teacher_no, course_no, student_name, email, birth_date, COUNT(*) AS duplicate_count
FROM students
GROUP BY teacher_no, course_no, student_name, email, birth_date
HAVING COUNT(*) > 1;
