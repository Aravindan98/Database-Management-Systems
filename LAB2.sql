--Excercise 1
--1.List the first and last names of all employees.
select firstname,lastname from employees;
--2.List all attributes of the projects with revenue greater than $40,000.
select * from projects where revenue > 40000;
--3.List the department codes of the projects with revenue between $100,000 and $150,000.
select deptcode from projects where revenue between 100000 and 150000
--4.List the project IDs for the projects that started on or before July 1, 2004.
select projectid,startdate from projects where startdate < '01-07-2004' -- assuming 'dd-mm-yyyy'
--5.List the names of the departments that are top level (i.e., not a sub department).
select name from departments where subdeptof is null
--6.List the ID and descriptions of the projects under the departments with code ACCNT,CNSLT,or HDWRE.
select projectid,description from projects where deptcode in ('ACCNT','CNSLT','HDWRE');
--7.List all of the information about employees with lastnames that have exactly 8 characters and end in 'ware'.
select * from employees where lastname like '____ware';
--8.List the ID and last name of all employees who work for department ACTNG and make less than $30,000
select employeeid,lastname from employees where deptcode='ACTNG' and salary<30000;
--9.List the “magical” projects that have not started (indicated by a startdate in the future or ​NULL)but are generating revenue.
select projectid from projects where revenue>0 and startdate is null or startdate>getDate();
--10.List the IDs of the projects either from the ACTNG department or that are on going(i.e.,​NULL end date). Exclude any projects that have revenue of $50,000 or less
select projectid from projects where (enddate is null or deptcode='ACTNG') and (revenue>50000);

--SUPPLEMENTARY Material Excercises
--1.List all employee names as one field called name.
select firstname+' '+lastname as 'name' from employees;
--2.List all the department codes assigned to a project. Remove all duplicates.
select distinct deptcode from projects;
--3.Find the project ID and duration of each project.
select projectid,datediff(day,startdate,enddate) as 'duration' from projects where startdate is not null and enddate is not null;
--4.Find the project ID and duration of each project . If the project has not finished,report it's execution time as of now. [Hint: Getdate() gives current date]
select projectid,datediff(day,startdate,coalesce(enddate,Getdate())) as 'duration' from projects;
--5.Find the ID's of employees assigned to a project that is more than 20 hours per week. Write three queries using 20, 40, and 60 hour work weeks.
select employeeid from workson where assignedtime > .20;
select employeeid from workson where assignedtime > .40;
select employeeid from workson where assignedtime > .60;
--6.For each employee assigned to a task, output the employee ID with the following:•'part time' if assigned time is ​< ​0.33
--•'split time' if assigned time is ​>​= 0.33 and ​< ​0.67•'full time' if assigned time is ​>​= 0.67
select employeeid,
case
when assignedtime<0.33 then 'Part-time'
when assignedtime >=0.33 and assignedtime<0.67 then 'Split-time'
when assignedtime >=0.67 then 'Full-time'
end as 'emptype' from workson;

--7.We need to create a list of abbreviated project names. Each abbreviated name concatenates the first three characters of the project description, a hyphen,and the department code. All characters must be uppercase (e.g., EMP-ADMIN).
select upper(substring(description,1,3))+'-'+deptcode as 'project name' from projects --
--8.For each project,list the ID and year the project started .Order the results in ascending order by year.
select projectid,year(startdate) as 'year' from projects order by year asc
--9.If every employee is given a 5% raise,find the lastname and new salary of the employees who will make more than $50,000.
select lastname,salary*1.05 as 'new salary' from employees where salary*1.05 >50000
--10.For all the employees in the HDWRE department, list their ID,firstname,lastname,and salary after a 10% raise. The salary column in the result should be named NextYear.
select employeeid,firstname,lastname,salary*1.1 as 'NextYear' from employees where deptcode='HDWRE';
--11.Create a neatly formatted directory of all employees, including their department code and name.The list should be sorted first by department code,then by lastname,then byfirst name
select firstname,lastname,deptcode from employees order by deptcode,firstname,lastname asc

