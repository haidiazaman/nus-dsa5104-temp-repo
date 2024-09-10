-- NOTES from Lect 3 --

-- relations: tables
-- attributes: columns

-- create table <table_name> (
-- 	column_name1 char(n),
-- 	column_name2 varchar(n),
--     column_name3 numeric(a,b),
-- )

-- primary key - unique identifier for that table
-- foreign key - reference column(s) for that table from another table (relation)
-- references, on delete set null etc

-- updates to tables
-- * insert, delete, drop table, alter, add

select * from instructor; -- selects all attributes (columns)
select dept_name from instructor;
select distinct dept_name from instructor;
select all dept_name from instructor;
select '437' from instructor; -- 437 also becomes the column name
select '437' as foo from instructor; -- sets column name as foo
select 'hi there' as foo from instructor; -- sets column name as foo
select 123 from instructor;
select 123 as num from instructor;

select * from instructor;
select ID, name, salary/12 as monthly_salary from instructor; -- can do divide operation on numeric column

select * from instructor;
select ID, name from instructor where dept_name='Comp. Sci.' and salary>70000;


select * from instructor, teaches; -- this creates a cartesian product
-- Cartesian product not very useful directly, but useful combined with
-- where-clause condition (selection operation in relational algebra
-- To get actual rows
-- method 1 using where 
select * from instructor I,teaches T where I.ID=T.ID;
select * from instructor I,teaches T where I.ID=T.ID order by I.ID asc;
select * from instructor I,teaches T where I.ID=T.ID and dept_name='Comp. Sci.';
select name,dept_name,salary,course_id from instructor I,teaches T where I.ID=T.ID;

-- method 2 using join (actually chap 4)
select * from instructor i left join teaches t on i.ID=t.ID; -- has null values
select * from instructor i left join teaches t on i.ID=t.ID where t.ID is not null order by i.ID asc;

-- rename operation using as, e.g. select distinct ID as distinct_id
-- e.g. select distinct T.name from instructor as T, instructor as S
-- this is equivalent select distinct T.name from instructor T, instructor S
-- dont need the as


-- self join example
create table employee_supervisor
	(
		person varchar(10),
        supervisor varchar(10)
    );
delete from employee_supervisor;
insert into employee_supervisor values ('Bob', 'Alice'); 
insert into employee_supervisor values ('Mary', 'Susan');
insert into employee_supervisor values ('Alice', 'David');
insert into employee_supervisor values ('David', 'Mary');
select * from employee_supervisor;

-- find supervisor of Bob
select supervisor from employee_supervisor where person='Bob';

-- find supervisor of supervisor of Bob
-- can do step by step but not efficient
-- do self join
select e1.supervisor
from employee_supervisor e1, employee_supervisor e2
where e1.person=e2.supervisor and e2.person='Bob';

-- find all the supervisors of Bob direct and indirect
select 
	e1.person,
    e1.supervisor as supervisor1,
    e2.supervisor as supervisor2,
    e3.supervisor as supervisor3,
    e4.supervisor as supervisor4
from 
	employee_supervisor e1
    join employee_supervisor e2 on e1.supervisor=e2.person
    join employee_supervisor e3 on e2.supervisor=e3.person
    join employee_supervisor e4 on e3.supervisor=e4.person
where e1.person='Bob'; 

-- string operations
-- percent ( % ). The % character matches any substring.
-- underscore ( _ ). The _ character matches any character.
select * from instructor;
select name from instructor where name like '%san';
select name from instructor where name like '%o%';
select name from instructor where name like '%a___';
-- Pattern matching examples:
-- • 'Intro%' matches any string beginning with “Intro”.
-- • '%Comp%' matches any string containing “Comp” as a substring.
-- • '_ _ _' matches any string of exactly three characters.
-- • '_ _ _ %' matches any string of at least three characters.
-- • concatenation (using “||”)
-- • converting from upper to lower case (and vice versa)
-- • finding string length, extracting substrings, etc.

-- patterns in MySQL are not case-sensitive but PostgreSQL is case-sensitive

-- order by < > asc desc, can do asc desc on diff attributes, will do in order of importance for first to last attribute
select * from instructor where salary>65000 order by ID,name desc;
select * from instructor where salary>65000 order by ID asc ,name desc;

-- between operator 
select name from instructor where salary between 60000 and 80000;
-- tuple comparsison
select name,course_id 
from instructor i, teaches t
where (i.ID, dept_name) = (t.ID, 'Physics');
-- set operations - union, intersect, except done on (table) (table)
(select course_id from section where semester = 'Fall' and year = 2017)
union
(select course_id from section where semester = 'Spring' and year = 2018);

(select course_id from section where semester = 'Fall' and year = 2017) 
intersect
(select course_id from section where semester = 'Spring' and year = 2018);

(select course_id from section where semester = 'Fall' and year = 2017)
except
(select course_id from section where semester = 'Spring' and year = 2018);

-- Set operations union, intersect, and except
-- Each of the above operations automatically eliminates duplicates
-- To retain all duplicates use the union all, intersect all, except all.

-- any arithmetic involving null will return null - 5+null=null
-- use IS NULL to check for null values
select name from instructor where salary is null;
-- any comparisons with null value wiull return null again
-- e.g. 5<null, null<>null, null=null
-- null is included in Boolean
-- and : (true and unknown) = unknown,
-- (false and unknown) = false,
-- (unknown and unknown) = unknown
-- • or: (unknown or true) = true,
-- (unknown or false) = unknown
-- (unknown or unknown) = unknown
-- where clause is evaluated as false if evaluated to unknown (null)

-- Aggregate functions
-- - avg, min, max, sum, count
select avg(salary) as avg_salary from instructor where dept_name='Physics'; -- returns  one value
select count(distinct ID) from teaches where semester='Spring' and year=2017;
-- count number of rows 
select count(*) from course;

-- Aggregate functions + Group By
select dept_name, avg(salary) avg_salary
from instructor 
group by dept_name;
-- cannot select attributes like name and ID since aggregation functions cant be run on them

-- Aggregate functions + Having clause
-- find names and avg salaries of departments whose avg > 42000
select dept_name, avg(salary) avg_salary
from instructor 
group by dept_name
having avg_salary > 42000;
-- Note: predicates in the having clause are applied after the formation of
-- groups whereas predicates in the where clause are applied before forming groups

-- THE BIG 6 - select,from,where,group by,having, order by
-- filter for year
-- for each course section, find average total credits (nned use groupby)
 
-- select *
-- from student s, takes t 
-- where t.year=2017

-- my query - close to correct
select t.sec_id,t.course_id, avg(tot_cred) avg_tot_cred, count(name) student_count 
from student s, takes t 
where s.ID=t.ID and t.year=2017
group by t.sec_id, t.course_id   
having student_count>1;

-- answer key
select course_id, semester, year, sec_id, avg(tot_cred) avg_tot_cred
from student s, takes t 
where s.ID=t.ID and t.year=2017
group by course_id,semester,year,sec_id
having count(s.ID)>=2
order by course_id asc;

-- NESTED SUBQUERIES
-- instead of select from <relation> where
-- instead of from <relation> you do from <subquery>
-- subquery is just another normal query
-- Where clause: P can be replaced with an expression of the form: B <operation> (subquery)
-- B is an attribute and <operation> to be defined later

-- SET MEMBERSHIP (NESTED SUBSQUERIES in WHERE clause) I - intro/general
-- each table here treated like sets then can use and or to do intersection or union

-- find courses offered in fall 2017 and Spring 2018
select distinct course_id from section where semester='Fall' and year=2017 and -- one table 
	course_id in (select course_id from section where semester='Spring' and year=2018); -- another table
 
select distinct course_id from section where semester='Fall' and year=2017 or -- one table 
	course_id in (select course_id from section where semester='Spring' and year=2018); -- another table
     
-- find courses offered in fall 2017 not Spring 2018
select course_id from section where semester='Fall' and year=2017 and 
	course_id not in (select course_id from section where semester='Spring' and year=2018);

-- find all courses taugnt in both fall 2017 and spring 2018
(select course_id from section where semester='Fall' and year=2017)
intersect
(select course_id from section where semester='Spring' and year=2018);

-- same as 
select distinct course_id from section where semester='Fall' and year=2017 and 
	course_id in (select course_id from section where semester='Spring' and year=2018);
    
-- find all instructor namres whose name is neither in Mozart or Einstein
select name from instructor where name not in ('Mozart','Einstein');

-- Find the total number of (distinct) students who have taken course sections 
-- taught by the instructor with ID 10101

-- need teaches table -> find instr with ID 10101 and the courses he teaches
-- get course_id(s) from prev line
-- find student ID taking those courses
-- get distinct number

select count(distinct ID) as num_students 
from takes 
where (course_id, sec_id, semester, year)
in (select course_id, sec_id, semester, year  
    from teaches
    where teaches.ID=10101);
    
    
-- SET MEMBERSHIP (NESTED SUBSQUERIES in WHERE clause) II - Some clause

-- Find names of instructors with salary greater than that of some (at least 
-- one) instructor in the Biology department.

select distinct T.name 
from instructor S, instructor T
where T.salary > S.salary and S.dept_name='Biology'
order by name;

-- same query using some
select name 
from instructor 
where salary > some (
select salary
from instructor
where dept_name='Biology'
);

-- SET MEMBERSHIP (NESTED SUBSQUERIES in WHERE clause) II - All clause

-- Find the names of all instructors whose salary is greater than the salary of
-- all instructors in the Biology department.

select name
from instructor
where salary > all (select salary
from instructor
where dept_name = 'Biology');


-- find the dept that have the highest ave salary
-- sub query: create table of ave salary, find highest ave
-- main query: return the dept_name corr to highest ave

select dept_name
from instructor
group by dept_name
having avg(salary) >= all (
	select avg(salary)
	from instructor 
	group by dept_name
    );
    
    
-- exists clause
-- Yet another way of specifying the query “Find all courses taught in both the
-- Fall 2017 semester and in the Spring 2018 semester”
select course_id
from section as S
where semester = 'Fall' and year = 2017 and exists (
	select *
	from section as T
	where semester = 'Spring' and year= 2018
	and S.course_id = T.course_id
    );
    
-- find total number of distinct students who have taken course sections taught by 
-- instructor with ID 110011
-- same as problem before in II but try doing using exists

-- prev method
select count(distinct(ID)) count_students from takes where course_id in (
	select course_id from teaches where ID=10101
);

-- using exists
select count(distinct(ID)) count_students from takes where exists (
	select course_id from teaches where ID=10101
); -- wrong since it includes several more cases


select count(distinct(ID))
from takes
where exists (
	select course_id, sec_id, semester,year
    from teaches
    where teaches.ID=10101 
		and takes.course_id=teaches.course_id
        and takes.sec_id=teaches.sec_id
        and takes.semester=teaches.semester
        and takes.year=teaches.year
    );
-- this exists just checks if it is a valid subquery
	
    
-- not exists
select distinct S.ID, S.name
from student as S
where not exists ( 
	(select course_id
	from course
	where dept_name = 'Biology')
except
	(select T.course_id
	from takes as T
	where S.ID = T.ID)
);
-- • First nested query lists all courses offered in Biology
-- • Second nested query lists all courses a particular student took
-- this query is incorrect tho

-- alternative
SELECT * 
FROM takes 
WHERE course_id IN (
    SELECT course_id 
    FROM course 
    WHERE dept_name = 'Biology'
);

-- alternative
select * from takes 
where exists (
	select * from course where dept_name='Biology' 
    and takes.course_id=course.course_id
);
-- correlated subquery contain attributes that do not exists in the subqeuery but in main query


-- unique operator - like distinct but for rows
select C.course_id 
from course as C
where unique (
	select S.course_id
    from section S
    where S.year=2017 and C.course_id=S.course_id
);
-- not yet implemented in SQL

-- alternative
select C.course_id 
from course C
where 2 = (
	select count(S.course_id)
    from section S
    where S.year=2017 and C.course_id=S.course_id
)
order by course_id;
-- important one to filter for certain count of rows using N=(subquery)

-- gets count of each course in section
select course_id, count(sec_id)
from section
group by course_id,year
having year=2017
order by course_id;

-- SET MEMBERSHIP (NESTED SUBSQUERIES in FROM clause) II 

-- Find the average instructors’ salaries of those departments where the
-- average salary is greater than $42,000

-- normal way
select dept_name, avg(salary) avg_salary
from instructor
group by dept_name
having avg_salary>42000
order by dept_name;

-- using nested subquery in from clause -- dont need having clause
select dept_name,avg_salary
from (select dept_name, avg(salary) avg_salary 
	from instructor
	group by dept_name) as S
where S.avg_salary>42000
order by dept_name;

-- alternative
select dept_name,avg_salary
from (select dept_name, avg(salary)
	from instructor
	group by dept_name) as S (dept_name, avg_salary)
where S.avg_salary>42000
order by dept_name;
-- S (dept_name, avg_salary) defines a relation

-- WITH clause
-- defining a temporary relation whose definition is available 
-- only to the query in which the with clause occur

-- find all departments with the maximum budget
with max_budget (budget_value) as (select max(budget) from department)
select D.dept_name
from department D, max_budget M
where D.budget=M.budget_value;

-- COMPLEX QUERIES using WITH clause
-- find all departments where the total salary is greater than the average of
-- the total salary at all departments

-- attempt 1 - correct
with dept_total_salaries(dept_name,total_salary) as (
	select dept_name,sum(salary) total_salary
	from instructor
	group by dept_name
)
select dept_name
from dept_total_salaries
where total_salary > (select avg(total_salary) from dept_total_salaries);

-- attempt 2 - cleaner but wrong
select dept_name
from (select dept_name,sum(salary) total_salary from instructor group by dept_name) as S (dept_name,total_salary) 
where S.total_salary > (select avg(total_salary) from S);
-- doesnt work because
-- (select avg(total_salary) from S);
-- sql finds S from university database and since youre creating another subquery in the where
-- the S is local only to the main select from where query 
-- as such need to rewrite the entire query to make it work in this format

-- attempt 3
select dept_name
from (select dept_name,sum(salary) total_salary from instructor group by dept_name) as S (dept_name,total_salary) 
where S.total_salary > 
(select avg(sum(salary)) from instructor group by dept_name);
-- wrong because you need to nest the last statement, cant do 2 agg functions,
-- but dont need to do 2 group bys

-- attempt 4 by chatgpt
SELECT dept_name
FROM (
    SELECT dept_name, SUM(salary) AS total_salary
    FROM instructor
    GROUP BY dept_name
) AS S
WHERE S.total_salary > (
    SELECT AVG(total_salary)
    FROM (
        SELECT SUM(salary) AS total_salary
        FROM instructor
        GROUP BY dept_name
    ) AS avg_salaries
);


-- attempt 5
select dept_name
from (select dept_name,sum(salary) total_salary from instructor group by dept_name) as S (dept_name,total_salary) 
where S.total_salary > 
(select avg(total_salary)
from (select sum(salary) total_salary from instructor group by dept_name) as avg_total_salary
);

-- answer key
-- fastest and easiest logical way despite being quite long
-- uses 2 temporary relations
with 
	-- first temporary relation
	dept_total (dept_name, value) as
		(select dept_name, sum(salary)
		from instructor
		group by dept_name),
	-- second temporary relation that references the first temp relation
    dept_total_avg (value) as
		(select avg(value)
		from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value > dept_total_avg.value;


-- Scalar subquery one where a single value is expected
select 
	distinct dept_name, 
	(select count(*)
	from instructor
	where department.dept_name = instructor.dept_name) as num_instructors
from department;

-- Modification of database

-- DELETION - on rows instead of columns, so dont need to do select <> just do delete from directly 
-- Delete all instructors
delete from instructor;
-- Delete all instructors from the Finance department
delete from instructor
where dept_name='Finance';
-- Delete all tuples in the instructor relation for those instructors associated
-- with a department located in the Watson building.
delete from instructor
where dept_name in 
	(select dept name
	from department
	where building = 'Watson');
-- Delete all instructors whose salary is less than the average salary of instructors
delete from instructor
where salary < 
	(select avg(salary) from instructor);
-- cant do where salary < avg(salary) because the agg functions can only be done in select clause
-- order of execution -> from where select
-- The above code works correctly in PostgreSQL, but MySQL won’t allow you to
-- execute it. You get following error message:
-- Error Code: 1093. You can't specify target table 'instructor' for update in FROM clause

-- In MySQL, you should use
set @a = (select avg(salary) from instructor);
delete from instructor 
where salary < @a;

-- Delete using primary key
delete from relation where attribute1=.. and attribute2=.. 
-- where the primary key = (attribute1, attribute2)


-- INSERTION
-- Add a new tuple to course
insert into course
values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);
-- or equivalently
insert into course (course_id, title, dept_name, credits)
values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);
-- Add a new tuple to student with tot_creds set to null
insert into student
values ('3003', 'Green', 'Finance', null);


-- UPDATES
-- Give a 5% salary raise to all instructors
update instructor
set salary = salary * 1.05;
-- Give a 5% salary raise to those instructors who earn less than 70000
update instructor
set salary = salary * 1.05
where salary < 70000;
-- Give a 5% salary raise to instructors whose salary is less than average
update instructor
set salary = salary * 1.05
where salary < (select avg (salary)
from instructor);
-- SQL standard, including PostgreSQL, first tests all tuples in the relation
-- to see whether they should be updated, and it carries out the updates
-- afterward. But MySQL won’t allow you to run the above update.

-- increase salaries of instructors whose salary > 90k by 3% and all others by 5%
update instructor
set salary = salary *1.03
where salary > 90000;
update instructor
set salary = salary *1.05
where salary <= 90000;
-- order is important since you need to make sure that you increase the salary of people
-- over 90k first


-- CASE STATEMENT for conditional updates
-- case when <> then <>
-- 	else <>
-- end
--     
-- same as like python
-- if <> : <>
-- else <>

-- alternative for prev using case 
update instructor
set salary = case
	when salary > 90000 then salary = salary * 1.03
    else salary = salary*1.05
    end;
-- wrong since as you dont need to do salary =

-- corrected
update instructor
set salary = case
	when salary > 90000 then salary * 1.03
    else salary*1.05
    end;
    
-- Recompute and update tot_creds value for all students
update student S
set tot_cred = (select sum(credits)
	from takes, course
	where takes.course_id = course.course_id and
	S.ID= takes.ID.and
	takes.grade != 'F' and
	takes.grade is not null
    );
-- Sets tot_creds to null for students who have not taken any course
-- Instead of sum(credits), use:
case
when sum(credits) is not null then sum(credits)
else 0
end;


-- to set a limit of top 5 or sth
-- then do 
limit 5;

-- NOTES on group by vs using multiple where statements
-- Aggregation:

-- GROUP BY aggregates data and provides summaries, such as counts or averages for grouped rows.
-- WHERE filters individual rows but does not perform any aggregation or grouping.
-- Row-Level vs. Group-Level:

-- WHERE is applied at the row level, meaning each row is checked to see if it matches the conditions.
-- GROUP BY operates at the group level, meaning rows are grouped together, and then you can aggregate data about those groups.
-- Use of Aggregate Functions:

-- GROUP BY is typically paired with aggregate functions like SUM(), COUNT(), etc., to get summary information about the groups.
-- WHERE doesn't allow aggregate functions unless it's part of a HAVING clause that applies after grouping.
-- Pre/Post-Grouping Filtering:

-- WHERE filters rows before grouping (if used with GROUP BY).
-- If you need to filter based on aggregate functions (like SUM() or COUNT()), you would use the HAVING clause after grouping.