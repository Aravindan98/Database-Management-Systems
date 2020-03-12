--Excercise 1
select * from ingredients;
--1.Find the ID of the vendor who supplies grape
select vendorid from ingredients where name='grape';
--2.Find all of the ingredients from the fruit food group with an inventory greater than 100
select * from ingredients where foodgroup='fruit' and inventory>100;
--3.Display all the food groups from ingredients, in which ‘grape’ is not a member
select distinct foodgroup from ingredients where foodgroup not in (select foodgroup from ingredients where name='grape');
--4.Find the ingredients, unit price suppliedby ‘VGRUS’ (vendorID) orderby unitprice(asc)
select ingredientid,unitprice from ingredients where vendorid='VGRUS' order by unitprice asc;
--5.Find the date on which the last item was added.
select max(dateadded) from items
--6.Find the number of vendors each vendor referred, and only report the vendors reffering more than one.
select referredby,count(*) as 'ref_count' from vendors group by referredby having count(*)>1;

-- Excercise 2
--1.Find the average salary for all employees.
select avg(salary) from employees;
--2.Find the average salary of employees in every department.
select deptcode,avg(salary) as 'dept_avg' from employees group by deptcode;
--3.Find the minimum and maximum project revenue for all active projects that make money.
select min(revenue),max(revenue) from projects where enddate is null and (revenue is not null and revenue>0.0);
--4.Find the number of projects that are completed. You may not use a WHERE clause.
select count(enddate) from projects;
--5.Find the last name of the employee whose last name is last in dictionary order.
select max(lastname) from employees;
--6.Compute the employee salary standard deviation. As a reminder,the formula for the population standard deviation is as follows (search for the stddev function in sql):
select stdev(salary) from employees;
--7.Find the number of employees who are assigned to some department .You may not use a WHERE clause.
select count(deptcode) from employees 
--8.For each department, list the department code and the number of employees in the department.
select deptcode,count(employeeid) as 'No_of_emp' from employees group by deptcode having deptcode is not null
--9.For each department that has a project,list the department code and report the average revenue and count of all of its projects.
select deptcode,avg(revenue) as 'avg_rev ',count(*) as 'proj_count' from projects group by deptcode having count(*)>0 and deptcode is not null;
--10.Calculate the salary cost for each department with employees that don’t have a lastname ending in “re” after giving everyone a 10% raise.
select deptcode,sum(salary*1.1) from employees where lastname not like '%re' group by deptcode;

-- Excercise 3
--1.Findalldatesonwhichprojectseitherstartedorended.Eliminateanyduplicateor​NULL​dates.Sort your results in descending order.
select startdate as 'date' from projects where startdate is not null union select distinct enddate as 'date' from projects where enddate is not null order by 'date' asc;
--2.UseINTERSECTtofindthefirstandlastnameofallemployeeswhobothworkontheRoboticSpouse and for the Hardware department.
select firstname,lastname from employees e,workson w,projects p where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse' intersect select distinct firstname,lastname from employees e,departments d where e.deptcode=d.code and name='Hardware';
--3.UseEXCEPTtofindthefirstandlastnameofallemployeeswhoworkontheRoboticSpousebut not for the Hardware department.
select firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse' except select distinct firstname,lastname from employees e,departments d where e.deptcode=d.code and name='Hardware';
--4.FindthefirstandlastnameofallemployeeswhoworkontheDownloadClientprojectbutnotthe Robotic Spouse project.
select firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Download Client' except select distinct firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse';
--6.FindthefirstandlastnameofallemployeeswhoworkoneithertheDownloadClientprojectorthe Robotic Spouse project.
select firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Download Client' union select distinct firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse';
--7.FindthefirstandlastnameofallemployeeswhoworkoneithertheDownloadClientprojectorthe Robotic Spouse project but not both.
(select firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Download Client' union select distinct firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse')
except (select firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Download Client' intersect select distinct firstname,lastname from employees e,workson w,projects p  where e.employeeid=w.employeeid and p.projectid=w.projectid and p.description='Robotic Spouse');
