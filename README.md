# Pewlett-Hackard-Analysis
Project working with SQL and pgAdmin

![EmployeeDB](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)

## Challenge Overview
Bobby’s new assignment consists of three parts: two additional analyses and a technical report to deliver the results to his manager. To help him complete these tasks, you will submit the following deliverables:
- Delivering Results: A README.md in the form of a technical report that details your analysis and findings
- Technical Analysis Deliverable 1: Number of Retiring Employees by Title. You will create three new tables, one showing number of [titles] retiring, one showing number of employees with each title, and one showing a list of current employees born between Jan. 1, 1952 and Dec. 31, 1955. New tables are exported as CSVs. 
- Technical Analysis Deliverable 2: Mentorship Eligibility. A table containing employees who are eligible for the mentorship program You will submit your table and the CSV containing the data (and the CSV containing the data)

## Pewlett Hackard Analysis Report
### Purpose of Analysis
- A large portion of Pewlett Hackard's employees are reaching retirement age over the next few years. This issue can cause a void in the work force if not properly managed. Using the new employee database, the managment team can have a significantly better idea of what employment changes are necessary to prepare for this surge in retirement.
### Technical Procedure
- To solve this problem, it is necessary to understand what positions need to be filled in the near future. To  formulate this analysis, new table was created from the retiring employees in relation to their titles. This was accomplished by joining columns from the retiring employees table, salaries table, and titles table. 
![retirees_by_title](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/retirees_by_title.PNG)
- After this table was created, duplicate employees were discovered in the table. Employees working in different positions throughout their time in the company caused this. The partition function as a subquery was necessary for filtering to the most resent title.
![partition_titles](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/partition_titles.PNG)
- Although the partitioning function is a very useful tool, for this example in particular, assigning a condition when joining the tables performs the same function with less code. 
![retirees_by_title_2](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/retirees_by_title_2.PNG)
- Using the COUNT command on the newly generated table, a new table was created to condense the information to a reasonable scale for quick analysis. 
![retiring_employees_count](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/retiring_employees_count.PNG)
- Lastly, a new table was necessary for determining what employees were eligible for the company’s membership program. Utilizing what I learned creating the other tables, I joined the employees and titles tables along with conditional commands to filter the desired data.
![employee_membership](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/employee_membership.PNG)
### Analysis Results
- From analyzing the filtered data, the largest hurtle management is going to have to overcome is replacing the 10,730 Senior Engineers slated to retire. 
![retiring_employees_count_table](https://github.com/ejlaflure/Pewlett-Hackard-Analysis/blob/master/Challenge_Images/retiring_employees_count_table.PNG)
- Additional analysis that should be performed to better prepare and compartmentalize this issue is to count the number of positions retiring by each department. This will allow each departments to focus on their needs and will delegate the tasks. For the Senior Engineers specifically, performing a count on Engineers in the company can be performed. Subtracting the employees slated for retirement and applying a conation that will only find Engineers that have been in the position long enough to be considered for promotion to Senior Engineers, will give an overview of potential employees available for promotion. 
