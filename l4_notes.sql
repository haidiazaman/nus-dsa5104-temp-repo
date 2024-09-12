-- JOIN OPERATIONS -cartesian products
-- natural, inner, outer join

-- NATURAL JOIN
-- combines on all common attributes without specifying any attributes
-- from clause can have multiple relations natural joined tgt

-- NATURAL JOIN VS INNER JOIN
-- Natural joins automatically join tables based on column names, 
-- while inner joins require explicitly specifying the join columns in the ON or USING clause. 
-- Natural join returns only one instance of a common join column, 
-- while inner join returns duplicate join columns from both tables.

use university;
select name,course_id
from student, takes
where student.id=takes.id;

select name,course_id
from student natural join takes;
-- because id is the only common attribute btwn them

-- Dangerous in Natural Join
-- Beware of unrelated attributes with same name which get equated incorrectly
-- e.g. List the names of students along with the titles of courses that they have taken
-- Correct version
select name, title
from student natural join takes, course
where takes.course_id = course.course_id;
-- Incorrect version
select name, title
from student natural join takes natural join course;

-- because student has dept_name and course also has dept_name
-- natural join will join only when they intersect but the dept_name here only show
-- the dept the student belogns to and the dept the course is taught from
-- but the student can take course outside his dept

-- USING CLAUSE
-- To avoid the danger of equating attributes erroneously, we can use the
-- “using” construct that allows us to specify exactly which columns should be equated

select name, title
from (student natural join takes) join course using (course_id);


select name, title
from (student natural join takes) natural join course using (course_id);
-- this doesnt work - seems to only work with inner join - this is the default join used in mysql

-- ON VS USING CLAUSE - on is like where clause but for joins
-- ON is the more general of the two. One can join tables ON a column, a set of columns and even a condition. For example:
SELECT * FROM world.City JOIN world.Country ON (City.CountryCode = Country.Code) WHERE ...

-- USING is useful when both tables share a column of the exact same name on which they join. In this case, one may say:
SELECT ... FROM film JOIN film_actor USING (film_id);


-- OUTER JOIN - left, right or full outer join
-- computes join and adds rows that are not common depending on left, right or full outer join
select * from course;
select * from prereq;
-- natural left outer join 
select * from course natural left outer join prereq;
-- natural right outer join 
select * from course natural right outer join prereq;
-- natural join just joins on the common attributes, which is course_id in these tables, dont need to specify on but can be 
-- dangerous so need check the attributes of the columns properly
-- can also use on condition

-- full outer join = union
select * from course natural full outer join prereq;
-- full not implemented in mysql - use union
(
	select *
    from course natural left outer join prereq
)
union
(
	select *
    from course natural right outer join prereq
);    

-- • A left outer join B preserves tuples in A.
-- • A right outer join B preserves tuples in B.
-- • A full outer join B preserves tuples in both A and B.
-- • A inner join B does not preserve non-matched tuples.


-- INNER JOIN requires explicit specification of the join condition using the ON clause.

-- VIEWS - create view <view_name> as <query> --> select * from <view_name>
-- In SQL, a view is a virtual table based on the result of a SQL query. 
-- t behaves like a regular table but doesn't store the data itself; instead, 
-- it presents data dynamically from one or more underlying tables. 
-- The view is useful for several reasons, including simplifying complex queries, 
-- enhancing security by restricting access to certain columns or rows, and 
-- encapsulating business logic.

select ID, name, dept_name
from instructor;

create view v as (select ID, name, dept_name from instructor);
select * from v;

-- One view may be used in the expression defining another view
-- A view relation v 1 is said to depend directly on a view relation v2 if v2 is
-- used in the expression defining v 1
-- § A view relation v 1 is said to depend on view relation v 2 if either v1 depends
-- directly to v 2 or there is a path of dependencies from v 1 to v 2
-- § A view relation v is said to be recursive if it depends on itself.


-- View expansion - a view defined using other views
-- Materialised views - saved physical copy instead of virtual table only but MySQL does not support

create view faculty as 
	select ID,name,dept_name
    from instructor;
select * from faculty;
select * from instructor;
insert into faculty
	values('30765','Green','Music');
select * from faculty;
select * from instructor;
-- updating view will also update the original table
-- Yes, if you update -- a view, it can update the underlying table (original relation)
-- Conditions for Updating a View:
-- Simple View: The view must be based on a single table and cannot have complex constructs like joins, aggregate functions, or GROUP BY clauses.
-- Key Preservation: The view must include the primary key (or a unique key) of the base table to ensure that each row can be uniquely identified.
-- No Derived Columns: The view should not include calculated or derived columns, such as those using expressions (column1 + column2) or aggregates (SUM(), COUNT(), etc.).
-- No Distinct, GROUP BY, or Aggregate Functions: Views with these operations are not updateable because the data they present is summarized or non-unique.


create view instructor_info as
select ID, name, building
from instructor, department
where instructor.dept_name = department.dept_name;
insert into instructor_info
values ('69987', 'White', 'Taylor');
-- cannot do update when you reference 2 tables in from clause

create view history_instructors as
select *
from instructor
where dept_name= 'History';

select * from history_instructors;
select * from instructor;
insert into history_instructors values ('25566', 'Brown', 'Biology', 100000);
insert into history_instructors values ('33445', 'White', 'History', 90000);
select * from history_instructors;
select * from instructor;

-- conditions to do updates in views
-- Most SQL implementations allow updates only on simple views
-- • The from clause has only one database relation.
-- • The select clause contains only attribute names of the relation, and
-- does not have any expressions, aggregates, or distinct
-- specification.
-- • Any attribute not listed in the select clause can be set to null
-- • The query does not have a group by or having clause.


-- SQL TRANSACRTIONS
-- By default, MySQL runs with autocommit mode enabled. This means that, when not otherwise inside a
-- transaction, each statement is atomic, as if it were surrounded by START TRANSACTION and COMMIT.
-- With START TRANSACTION, autocommit remains disabled until you end the transaction
-- with COMMIT or ROLLBACK.
-- Atomic transaction
-- • either fully executed or rolled back as if it never occurred

## PAGE 36 ##
drop database if exists testdb;
create database testdb; 
use testdb;

create table bankaccount
	(account_id varchar(10),
     account_name varchar(20),
	 balance numeric(10,2) check (balance >= 0),
     primary key (account_id)
    );
insert into bankaccount values 
	('ACC0001', 'Arnold', 50),('ACC0002', 'Brown', 500);

create table shoeshop
	(shoe_id varchar(10),
     stock_number int check (stock_number >= 0),
     unit_price numeric(10,2),
     primary key (shoe_id)
    );
insert into shoeshop values ('SHOE0001', 20, 100);

start transaction;
	update shoeshop set stock_number = stock_number-1 where shoe_id = 'SHOE0001';
	-- @variable_name is a user-defined variable (prefixe with @)
    -- two ways to set it value:
    -- select @price := unit_price from shoeshop where shoe_id = 'SHOE0001');
	set @price = (select unit_price from shoeshop where shoe_id = 'SHOE0001');
    update bankaccount set balance = balance-@price where account_id = 'ACC0001';
commit;
-- if you get an error in the above code, it will not reach "commit", you can run rollback
select * from shoeshop; -- to see what is wrong before rolling back
rollback;
select * from shoeshop; -- things are now fixed

-- VARIABLES
set @var1=5;
show variables;

-- SQL procedure, delimiter, declare, transactions
drop procedure if exists buy_one_shoes;

/*
In MySQL, the delimiter is changed in procedures to avoid syntax errors and to 
set custom delimiters. The default delimiter in MySQL is a semicolon (;), but 
if a semicolon is used within a statement, it can be interpreted as the end of 
the statement. This can cause syntax errors or incorrect execution.
*/
delimiter //
create procedure buy_one_shoes(in _account_id varchar(10), in _shoe_id varchar(10))
begin
	declare price numeric(10,2); -- price is a local variable
    
	declare continue handler for 3819 -- Error Code: 3819. Check constraint '...' is violated.
		begin 
			rollback;
		end;
        
	start transaction;         
		update shoeshop set stock_number = stock_number-1 where shoe_id = _shoe_id;
		set price = (select unit_price from shoeshop where shoe_id = _shoe_id); 
		update bankaccount set balance = balance-price where account_id = _account_id;
	commit;
end; //
-- the above line can be either end; // or end //
delimiter ;

call buy_one_shoes('ACC0002','SHOE0001');
select * from bankaccount;
select * from shoeshop;

call buy_one_shoes('ACC0001','SHOE0001');
select * from bankaccount;
select * from shoeshop;


-- INTEGRITY CONSTRAINTS
-- integrity constraints guard against accidental damage to the database,
-- by ensuring that authorized changes to the database do not result in a
-- loss of data consistency.

-- e.g.
-- Declare name and budget to be not null when creating a relation
-- 1. name varchar(20) not null
-- budget numeric(12,2) not null

-- 2. unique ( A 1 , A 2 , ..., A m )
-- • The unique specification states that the attributes A 1 , A 2 , ..., A m
-- form a candidate key
-- * candidates keys can be null

-- 3. check (P) clause specifies a predicate P that must be satisfied by
-- every tuple in a relation.
-- example 
create table section_new
(course_id varchar (8),
sec_id varchar (8),
semester varchar (6),
primary key (course_id, sec_id),
check (semester in ('Fall', 'Winter', 'Spring', 'Summer')));


-- REFERENTIAL INTEGRITY -- foreign key
-- Foreign keys can be specified as part of the SQL create table
-- statement
-- foreign key (dept_name) references department
-- § By default, a foreign key references the primary-key attributes of the
-- referenced table.
-- § SQL allows a list of attributes of the referenced relation to be specified
-- explicitly.
-- foreign key (dept_name) references department (dept_name)

-- CASCADE
-- In SQL, CASCADE is a keyword used in conjunction with FOREIGN KEY constraints or 
-- actions like DELETE or UPDATE. It specifies that when a referenced record in a parent table 
-- is modified or deleted, the corresponding changes should be automatically "cascaded" 
-- to the related records in the child table(s). This ensures referential integrity between the related tables.
create table course (
(...
dept_name varchar(20),
foreign key (dept_name) references department
on delete cascade
on update cascade,
. . .);
-- instead of cascade can use set null

create table person (
ID char(10),
name char(40),
mother char(10),
father char(10),
primary key (ID),
foreign key (father) references person (name),
foreign key (mother) references person (name)
);
-- How to insert a tuple without causing constraint violation?
-- • Insert father and mother of a person before inserting person
-- • OR, set father and mother to null initially, update after inserting all
-- persons (not possible if father and mother attributes declared to be not
-- null)
-- • OR defer constraint checking
-- • OR using INITIALLY DEFERRED

create table person (
	ID int,
    name varchar(10),
    spouse varchar(10),
    primary key (ID),
    unique (name),
    foreign key (spouse) references person (name) ); 
insert into person values (1, 'John', 'Mary');    
insert into person values (1, 'John', null);  
insert into person values (2, 'Mary', null);
update person set spouse = 'Mary' where ID = 1;
update person set spouse = 'John' where ID = 2;
select * from person;


-- note primary key attributes is minimum need to identify unique rows,
-- even if there are other attirbutes that have unique values, primary key is only 1 attribute 
-- primary key has more than 1 attribtue only when > 1 attribute reqd to create a unique row
-- foreign key are keys referring to other tables


-- BUILT-IN DATA TYPES IN SQL
-- § date: Dates, containing a (4 digit) year, month and date
-- • Example: date '2005-7-27'
-- § time: Time of day, in hours, minutes and seconds.
-- • Example: time '09:00:30' time '09:00:30.75'
-- § timestamp: date plus time of day
-- • Example: timestamp '2005-7-27 09:00:30.75'
-- § interval: period of time
-- • Example: interval '1' day
-- • Subtracting a date/time/timestamp value from another gives an
-- interval value
-- • Interval values can be added to date/time/timestamp values

-- but date might not be in the right format so need to use substring


-- Large object types - blob, clob

-- DOMAIN user defined type only in Postgres, not implemented in mysql
-- Suppose you have a column that stores the age of employees, 
-- and you want to ensure that the value entered is always between 18 and 65. 
-- You can define a domain to enforce this constraint.

CREATE DOMAIN age_domain AS INT
CHECK (VALUE >= 18 AND VALUE <= 65);
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    age age_domain
);


-- index creation - indexing like in dict, dont need go thru entire list, just directly get the index
select * from student;
show indexes from student;
-- by default only shows primary and foreign key
create index studentID_index on student(ID);
select * from student where ID='12345';
show indexes from student;





















