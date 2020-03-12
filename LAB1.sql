create table Category_Details
  (
    category_id numeric(2) primary key,--1
    category_name varchar(30)
  );

  select * from Category_Details;

create table Sub_category_details
  (
      sub_category_id numeric(2),
      category_id numeric(2),
      sub_category_name varchar(30),
      constraint pk_sub_cat primary key(sub_category_id),--2
      constraint fk_sub_cat foreign key(category_id) references Category_Details on delete cascade --3
  );

create table Product_details
  (
    product_id numeric(6),
    category_id numeric(2),
    sub_category_id numeric(2),
    product_name varchar(30)
    constraint pk_prod primary key(product_id), --4
    constraint fk_prodC foreign key(category_id) references Category_Details, --4
    constraint fk_prdSC foreign key(sub_category_id) references Sub_category_details, --4
  );

--5
insert into Category_Details values (01,'FOOD');
insert into Category_Details values (02,'CLOTHING');

insert into Sub_category_details values (12,01,'SNACKS');
insert into Sub_category_details values (13,02,'JEANS');
insert into Sub_category_details values (14,01,'FROZEN');

insert into Product_details values (000001,01,12,'Lays');
insert into Product_details values (000002,01,12,'Gol-Gappa');
insert into Product_details values (000003,02,13,'Levis');
insert into Product_details values (000004,01,14,'Icecream');

select * from Category_Details;
select * from Sub_category_details;
select * from Product_details;

--Excercise 2
alter table Product_details add price numeric(2);--1
alter table Product_details alter column price numeric(6,2);--2
alter table Product_details drop column price;--3
alter table Product_details add brandname varchar(20) not null;--4 --


exec sp_rename 'Category_Details','Cat_dt';--5
select  * from Cat_dt;
