# MySQL Practice

SQL practice project completed during the DAN.IT Data Analytics course.

## Database

All queries are based on the classic `employees` database.

To set up the database locally, download the dump file:
[Download emp.zip](#)

Then import it via terminal:

```bash
/usr/local/mysql/bin/mysql -u root -p
source ~/Desktop/emp.sql
```

## Files

| File | Description |
|------|-------------|
| `homework1.sql` | Basic SELECT, WHERE, LIKE, GROUP BY, HAVING, aggregate functions |
| `homework2.sql` | JOIN, subqueries, aliases, UNION / UNION ALL |
| `homework3.sql` | CASE, CTE, nested subqueries, salary segmentation |
| `step_project.sql` | Step project: database design from scratch + complex queries |

## Topics Covered

- SELECT, WHERE, ORDER BY, LIMIT
- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY, HAVING
- INNER JOIN, multiple JOINs
- Subqueries (in WHERE, FROM, JOIN)
- CTE (Common Table Expressions)
- CASE statements
- Window functions: ROW_NUMBER(), RANK(), LAG(), LEAD()
- Database design: CREATE TABLE, PRIMARY KEY, FOREIGN KEY, AUTO_INCREMENT
- Normalization (1NF–3NF)
- Transactions: START TRANSACTION, COMMIT

## Stack

MySQL Workbench
