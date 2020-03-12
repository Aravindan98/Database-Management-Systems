DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;EXEC sp_msforeachtable @Command1 = "DROP TABLE ?"


CREATE TABLE employees (
employeeid NUMERIC(9) NOT NULL,
firstname VARCHAR(10),
lastname VARCHAR(20),
deptcode CHAR(5),
salary NUMERIC(9, 2),
  PRIMARY KEY(employeeid)
);


CREATE TABLE departments (
  code CHAR(5) NOT NULL,
  name VARCHAR(30),
  managerid NUMERIC(9),
  subdeptof CHAR(5),
  PRIMARY KEY(code),
  FOREIGN KEY(managerid) REFERENCES employees(employeeid),
  FOREIGN KEY(subdeptof) REFERENCES departments(code)
);

ALTER TABLE employees ADD FOREIGN KEY (deptcode) REFERENCES departments(code);

CREATE TABLE projects (
  projectid CHAR(8) NOT NULL,
  deptcode CHAR(5),
  description VARCHAR(200),
  startdate DATE DEFAULT GETDATE(),
  enddate DATE,
  revenue NUMERIC(12, 2),
  PRIMARY KEY(projectid),
  FOREIGN KEY(deptcode) REFERENCES departments(code)
);

CREATE TABLE workson (
  employeeid NUMERIC(9) NOT NULL,
  projectid CHAR(8) NOT NULL,
  assignedtime DECIMAL(3,2),
  PRIMARY KEY(employeeid, projectid),
  FOREIGN KEY(employeeid) REFERENCES employees(employeeid),
  FOREIGN KEY(projectid) REFERENCES projects(projectid)
);

INSERT INTO departments VALUES ('ADMIN', 'Administration', NULL, NULL);
INSERT INTO departments VALUES ('ACCNT', 'Accounting', NULL, 'ADMIN');
INSERT INTO departments VALUES ('CNSLT', 'Consulting', NULL, 'ADMIN');
INSERT INTO departments VALUES ('HDWRE', 'Hardware', NULL, 'CNSLT');

INSERT INTO employees VALUES (1, 'Al', 'Betheleader', 'ADMIN', 70000);
INSERT INTO employees VALUES (2, 'PI', 'Rsquared', 'ACCNT', 40000);
INSERT INTO employees VALUES (3, 'Harry', 'Hardware', 'HDWRE', 50000);
INSERT INTO employees VALUES (4, 'Sussie', 'Software', 'CNSLT', 60000);
INSERT INTO employees VALUES (5, 'Abe', 'Advice', 'CNSLT', 30000);
INSERT INTO employees VALUES (6, 'Hardly', 'Aware', NULL, 65000);

UPDATE departments SET managerid = 1 WHERE code = 'ADMIN';
UPDATE departments SET managerid = 2 WHERE code = 'ACCNT';
UPDATE departments SET managerid = 3 WHERE code = 'HDWRE';
UPDATE departments SET managerid = 4 WHERE code = 'CNSLT';

INSERT INTO projects VALUES ('EMPHAPPY', 'ADMIN', 'Employee Moral', '14-MAR-2002', '30-NOV-2003', 0);
INSERT INTO projects VALUES ('ROBOSPSE', 'CNSLT', 'Robotic Spouse', '14-MAR-2002', NULL, 200000);
INSERT INTO projects VALUES ('ADT4MFIA', 'ACCNT', 'Mofia Audit', '03-JUL-2003', '30-NOV-2004', 100000);
INSERT INTO PROJECTS VALUES ('DNLDCLNT', 'CNSLT', 'Download Client', '03-FEB-2005', NULL, 15000);

INSERT INTO workson VALUES (2, 'ADT4MFIA', 0.60);
INSERT INTO workson VALUES (3, 'ROBOSPSE', 0.75);
INSERT INTO workson VALUES (4, 'ROBOSPSE', 0.75);
INSERT INTO workson VALUES (5, 'ROBOSPSE', 0.50);
INSERT INTO workson VALUES (5, 'ADT4MFIA', 0.60);
INSERT INTO workson VALUES (3, 'DNLDCLNT', 0.25);

--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Consulting');

--select distinct firstname+' '+lastname as name from employees e,workson w where e.deptcode=(select code from departments where name='Consulting')
--and w.employeeid=e.employeeid and w.projectid='ADT4MFIA' and w.assignedtime>0.2;

--select sum(assignedtime)/(select sum(assignedtime) from workson)*100 from workson group by employeeid having employeeid=(select employeeid from employees where firstname+' '+lastname='Abe Advice');
--select name from departments where code not in (select deptcode from projects);
--select firstname+' '+lastname as name from employees where salary>(select avg(salary) from employees where deptcode=(select code from departments where name='Accounting'));
--select description from projects where projectid in (select projectid from workson where assignedtime>0.7);
--SELECT DESCRIPTION FROM PROJECTS
--WHERE PROJECTID IN(
--SELECT W1.PROJECTID
--FROM WORKSON W1
--WHERE (W1.ASSIGNEDTIME/(SELECT SUM(W.ASSIGNEDTIME)
--FROM WORKSON W
--WHERE W.EMPLOYEEID = W1.EMPLOYEEID
--GROUP BY W.EMPLOYEEID)>.7));
--select firstname+' '+lastname as name from employees where salary>any(select (salary) from employees where deptcode=(select code from departments where name='Accounting'));

--select min(salary) from employees where salary>all(select (salary) from employees where deptcode=(select code from departments where name='Accounting'));
--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Accounting') and salary=(select max(salary) from employees where deptcode=(select code from departments where name='Accounting'));
------------select e.employeeid,sum(w.assignedtime) from employees e,workson w,projects p where e.employeeid=w.employeeid  and w.assignedtime>0.5 and w.projectid=p.projectid and p.deptcode <> e.deptcode group by e.employeeid;

--select distinct d.code from departments d,employees e,projects p,workson w where e.deptcode=d.code ;

--SELECT D.NAME FROM DEPARTMENTS D WHERE EXISTS (SELECT E.FIRSTNAME FROM EMPLOYEES E WHERE E.DEPTCODE = D.CODE AND NOT EXISTS ((SELECT PROJECTID FROM PROJECTS P1 WHERE P1.DEPTCODE = D.CODE) EXCEPT (SELECT P.PROJECTID FROM PROJECTS P, WORKSON W WHERE W.EMPLOYEEID = E.EMPLOYEEID AND W.PROJECTID = P.PROJECTID)));

--select firstname+' '+lastname as name from employees where deptcode=(select code from departments where name='Accounting') ;




select * from employees;
select * from departments;
select * from workson;
select * from projects;


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
--9.List the “magical” projects that have not started (indicated by a startdate in the future or ?NULL)but are generating revenue.
select projectid from projects where revenue>0 and startdate is null or startdate>getDate();
--10.List the IDs of the projects either from the ACTNG department or that are on going(i.e.,?NULL end date). Exclude any projects that have revenue of $50,000 or less
select projectid from projects where (enddate is null or deptcode='ACTNG') and (revenue>50000);

--SUPPLEMENTARY Material Excercises
--1.List all employee names as one field called name.
select firstname+' '+lastname as 'name' from employees;
--2.List all the department codes assigned to a project. Remove all duplicates.
select distinct deptcode from projects;
--3.Find the project ID and duration of each project.
select projectid,datediff(enddate,startdate) as 'duration' from projects where startdate is not null and enddate is not null;
--4.Find the project ID and duration of each project . If the project has not finished,report it's execution time as of now. [Hint: Getdate() gives current date]
select projectid,startdate-coalesce(enddate,Getdate()) as 'duration' from projects;
--5.Find the ID's of employees assigned to a project that is more than 20 hours per week. Write three queries using 20, 40, and 60 hour work weeks.
select employeeid from workson where assignedtime > .20;
select employeeid from workson where assignedtime > .40;
select employeeid from workson where assignedtime > .60;
--6.For each employee assigned to a task, output the employee ID with the following:•'part time' if assigned time is ?< ?0.33
--•'split time' if assigned time is ?>?= 0.33 and ?< ?0.67•'full time' if assigned time is ?>?= 0.67
select employeeid,
case
when assignedtime<0.33 then 'Part-time'
when assignedtime >=0.33 and assignedtime<0.67 then 'Split-time'
when assignedtime >=0.67 then 'Full-time'
end as 'emptype' from workson;

--7.We need to create a list of abbreviated project names. Each abbreviated name concatenates the first three characters of the project description, a hyphen,and the department code. All characters must be uppercase (e.g., EMP-ADMIN).
select substring(description,1,3)+'-'+deptcode as 'project name' from projects --
--8.For each project,list the ID and year the project started .Order the results in ascending order by year.
select projectid,extract(year from startdate) as 'year' from projects order by year asc
--9.If every employee is given a 5% raise,find the lastname and new salary of the employees who will make more than $50,000.
select lastname,salary*1.05 as 'new salary' from employees where new salary >50000
--10.For all the employees in the HDWRE department, list their ID,firstname,lastname,and salary after a 10% raise. The salary column in the result should be named NextYear.
select employeeid,firstname,lastname,salary*1.1 as 'NextYear' from employees where deptcode='HDWRE';
--11.Create a neatly formatted directory of all employees, including their department code and name.The list should be sorted first by department code,then by lastname,then byfirst name
select firstname,lastname,deptcode from employees order by deptcode,firstname,lastname asc













































