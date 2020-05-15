-- Retirement eligibility (search with conditional)
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility (search with two conditionals)
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Creating new table form existing tables
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining tables with cleaner code
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
    retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining tables with cleaner code
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Joining tables into new current_emp table
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number (ordered)
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee count table by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Joining tables into new employee_info table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
    s.salary 
INTO employee_info
FROM employees as e
LEFT JOIN salaries as s
ON e.emp_no = s.emp_no;

-- Joining tables into new emp_info table
SELECT e.emp_no,
	e.first_name,
    e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no = ce.emp_no);

-- List of retirees per department
SELECT de.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Create new table for retiring employees in sales
SELECT emp_no, first_name, last_name, dept_name
INTO sales_emp
FROM dept_info
WHERE dept_name = 'Sales';

-- Create new table for more retiring employees
SELECT emp_no, first_name, last_name, dept_name
INTO sal_dev_emp
FROM dept_info
WHERE dept_name in ('Sales', 'Development');

-- List of retirees by title
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    tl.title,
    tl.from_date,
    s.salary
INTO retiree_titles
FROM current_emp AS ce
INNER JOIN titles AS tl
ON (ce.emp_no = tl.emp_no)
INNER JOIN salaries AS s
ON (ce.emp_no = s.emp_no);

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 salary
INTO unique_titles
FROM
 (SELECT rt.emp_no,
 rt.first_name,
 rt.last_name,
 rt.title,
 rt.from_date,
 rt.salary, ROW_NUMBER() OVER
 (PARTITION BY (rt.emp_no)
 ORDER BY tl.to_date DESC) rn
 FROM retiree_titles AS rt
 INNER JOIN titles AS tl
 ON (rt.emp_no = tl.emp_no)
 ) tmp WHERE rn = 1
ORDER BY emp_no;

-- Count of retiring employees per title
SELECT title, COUNT(emp_no) AS emp_count 
INTO retiree_titles_count
FROM unique_titles
GROUP BY title
ORDER BY emp_count DESC;

-- List of retirees by title (secondary method)
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    tl.title,
    tl.from_date,
    s.salary
INTO retiree_titles
FROM current_emp AS ce
INNER JOIN titles AS tl
ON (ce.emp_no = tl.emp_no)
INNER JOIN salaries AS s
ON (ce.emp_no = s.emp_no)
WHERE (tl.to_date = '9999-01-01')
ORDER BY ce.emp_no;

-- List of employees eligibile for membership
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    tl.title,
    tl.from_date,
    tl.to_date
INTO elig_memb
FROM employees AS e
INNER JOIN titles AS tl
ON (e.emp_no = tl.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (tl.to_date = '9999-01-01')
ORDER BY e.emp_no;