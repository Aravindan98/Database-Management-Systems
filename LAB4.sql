-- Excercise 1 -- same questions as Lab3

--Excercise 2
--1.Find the name and price of all meals and items.
select name,price from items union select name,unitprice from ingredients;
--2.Find all item IDs with ingredients in both the Fruit and Vegetable foodgroups.
select itemid from madewith m,ingredients i where m.ingredientid=i.ingredientid and i.foodgroup='Fruit' intersect select itemid from madewith m,ingredients i where m.ingredientid=i.ingredientid and i.foodgroup='Vegetable' 
--3.List  all  the  food  groups  provided  by some  ingredient  that  is  in  the  Fruit  Plate  but  not  the Fruit Salad.
select foodgroup from ingredients i, madewith m, items mi where i.ingredientid=m.ingredientid and m.itemid=mi.itemid and (mi.name='Fruit Plate')
except select foodgroup from ingredients i, madewith m, items mi where i.ingredientid=m.ingredientid and m.itemid=mi.itemid and (mi.name='Fruit Salad');
--4.Find all item IDs of items not made with Cheese
select itemid from items except select mi.itemid from ingredients i, madewith m, items mi where (i.ingredientid=m.ingredientid and m.itemid=mi.itemid) and (i.name='Cheese');

create view ea as select employeeid,sum(assignedtime) as 'TotalAssTime' from workson group by employeeid; --auxillary table which would help
select * from ea
create view pa as select projectid,sum(assignedtime) as 'TotalAssTime' from workson group by projectid

--Excercise 3
--1.Find the names of all people who work in the Consulting department and who spend more than 20% of their time on the project with ID ADT4MFIA. Solve using: 1) using only WHERE based join (i.e., noINNER/OUTER/CROSS JOIN), 2) using some form of JOIN.
select firstname+' '+lastname as 'Name' from employees where employeeid in (select w.employeeid from ea e join workson w on e.employeeid=w.employeeid where projectid='ADT4MFIA' and assignedtime>0.2*TotalAssTime); 
--2.Find the names of all people who work in the Consulting department. Solve using: 1)using only WHERE-based join (i.e., no INNER/OUTER/CROSS JOIN) 2)with CROSS JOIN
select firstname+' '+lastname as 'Name' from employees e,departments d where e.deptcode=d.code and d.name='Consulting';
--3.Find the total percentage of time assigned to employee Abe Advice. Solve using: 1)using only WHERE-based join (i.e., no INNER/OUTER/CROSS JOIN) and 2)using some form of JOIN.
select employeeid, TotalAssTime*100/(select sum(TotalAssTime) from ea) from ea where employeeid in (select employeeid from employees where firstname='Abe' and lastname='Advice');
--4.Find the descriptions of all projects that require more than 70% of an employee’s time. Solve it two ways: 1) using only WHERE-based join (i.e., no INNER/OUTER/CROSS JOIN) and 2)using some form of JOIN.
select distinct description from ea e join workson w on e.employeeid=w.employeeid join projects p on w.projectid=p.projectid where assignedtime>0.7*TotalAssTime
--5.For each employee, list the employee ID, number of projects, and the total percentage of time for the current projects to which she is assigned. Include employees not assigned to any project.
create view v1 as select employeeid,count(projectid) as 'no_proj' from workson w group by employeeid;
create view v2 as select w.employeeid,sum(assignedtime) as 'Cur_proj_time' from workson w join ea e on w.employeeid=e.employeeid where projectid in (select projectid from projects where enddate is null) group by w.employeeid;
select v1.employeeid,no_proj,coalesce(Cur_proj_time,0.0) as 'Cur_proj_time' from v1 left join v2 on v1.employeeid=v2.employeeid 
--6.Find the description of all projects with no employees assigned to them.
select description from projects except select description from projects p join workson w on w.projectid=p.projectid;
--7.For each project, find the greatest percentage of time assigned to one employee. Solve it two ways: using only WHERE-based join (i.e., no INNER/OUTER/CROSS JOIN) and 2) using some form of JOIN.
select projectid,max(assignedtime)*100/(select TotalAssTime from pa p where p.projectid=w.projectid) as 'max_ass_time' from workson w group by projectid;
--8.For  each  employee  ID,  find  the  last  name  of  all  employees  making  more  money  than  that employee. Solve it two ways: 1) using only WHERE-based join (i.e., no INNER/OUTER/CROSS JOIN) and 2) using some form of JOIN
select e2.employeeid,e1.lastname as 'richer_emp_lname' from employees e1, employees e2 where e1.salary>e2.salary;

--Excercise 4
--1 to 4 done in Lab3

--5. Using EXCEPT, find all of the departments without any projects
select name from departments except select d.name from projects p join departments d on p.deptcode=d.code;

