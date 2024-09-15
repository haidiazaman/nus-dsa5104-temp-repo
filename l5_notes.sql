-- functions and procedures allow “business logic” to be stored in the
-- database and executed from SQL statements.alter

-- SQL FUNCTIONS
-- example SQL function returning a value
create function dept_count(dept_name varchar(20)) returns integer
begin
	declare d_count integer;
	select count(*) into d_count
	from instructor
	where instructor.dept_name = dept_name
	return d_count;
end;

select dept_name, budget
from department
where dept_count(dept_name) > 12;


-- example SQL function returning a table
create function instructor_of (dept_name varchar(20))
	returns table (
		ID varchar(5),
		name varchar(20),
		dept_name varchar(20),
		salary numeric(8,2)
        )
	return table(
		select ID, name, dept_name, salary
		from instructor
		where instructor.dept_name = instructor_of.dept_name
        );
        
select *
from table (instructor_of ('Music'));
-- need to call table first since thats the type returned by the table function,
-- normal function dont need
-- BUT MySQL doesnt allow this


-- SQL PROCEDURES
drop procedure if exists instructor_of;

delimiter //
create procedure instructor_of (in in_dept_name varchar(20))
begin 
	select ID, name, dept_name, salary
    from instructor
    where dept_name = in_dept_name;
end //
delimiter ;

call instructor_of('Physics');

-- The function calculates and returns the results after receiving certain inputs. 
-- The procedure performs certain tasks after receiving certain inputs. 
-- Functions do not support try-catch blocks. Procedures support try-catch blocks

--  The delimiter
-- is changed to // to enable the entire definition to be passed to the server
-- as a single statement, and then restored to ; before invoking the
-- procedure. This enables the ; delimiter used in the procedure body to
-- be passed through to the server rather than being interpreted by
-- mysql itself.

delimiter //
create procedure dept_count_proc (in dept_name varchar(20),
out d_count integer)
begin
	select count(*) into d_count
	from instructor
	where instructor.dept_name = dept_count_proc.dept_name;
end // 
delimiter ;


-- declare d_count integer;
call dept_count_proc('Physics',d_count);
select @num_count;

-- SQL language constructs
-- 1. 
-- begin ... end
-- while boolean_expresion do sequence_of_actions end while
-- repeat sequence of statements; until boolean expression end repeat

-- 2. FOR loops - not supported, need to use WHILE or REPEAT or LOOP statements
-- e.g. find budget of all departments
declare n integer default 0; -- wouldnt work, need to use in a procedure or begin ... end

-- pseudocode
-- drop procedure if exists get_budgets;
delimiter //
create procedure get_budgets(in n int, out answer int)
begin
	declare n integer default 0;
    for r as 
		select budget from department
        where dept_name = 'Music'
	do 
		set n=n+r.budget
	end;

-- FOR loops not supported in MySQL, need to use WHILE or REPEAT

-- for loop using WHILE statement
drop procedure if exists fib1;
delimiter // 
create procedure fib1(in n int, out answer int)
begin
	declare i int default 2;
    declare p, q int default 1;
    set answer = 1;
    while i < n do
		set answer = p+q;
        set p=q;
        set q=answer;
        set i=i+1;
	end while;
end //
delimiter ;

-- for loop using REPEAT statement
drop procedure if exists fib2;
delimiter // 
create procedure fib2(in n int, out answer int)
begin
	declare i int default 1;
    declare p int default 0;
    declare q int default 1;
    set answer = 1;
    repeat
		set answer = p+q;
        set p=q;
        set q=answer;
        set i=i+1;
	until i>=n end repeat;
end //
delimiter ;

-- for loop using LOOP statement
drop procedure if exists fib3;
delimiter // 
create procedure fib3(in n int, out answer int)
begin
	declare i int default 2;
    declare p, q int default 1;
    set answer = 1;
    loop1: loop
		if i>=n then
			leave loop1;
		end if;
		set answer = p+q;
        set p=q;
        set q=answer;
        set i=i+1;
	end loop loop1;
end //
delimiter ;
call fib3(7, @answer3);
select @answer3;

-- Conditional statements (if-then-else)
-- if boolean expression
-- then statement or compound statement
-- elseif boolean expression
-- then statement or compound statement
-- else statement or compound statement
-- end if


-- e.g. Registers student after ensuring classroom capacity is not exceeded
-- • Returns 0 on success and -1 if capacity is exceeded
-- • See book (page 202) for details


##############################################################
# code on Page 21 of the slides
##############################################################
drop procedure if exists registerStudent; 
delimiter //
create procedure registerStudent(
					in s_id varchar(5),
					in s_courseid varchar (8), 
                    in s_secid varchar (8),
                    in s_semester varchar (6), 
                    in s_year numeric (4,0),
                    out regState int,
                    out errorMsg varchar(100))
begin
	-- declare all the local variables here
	declare currEnrol int;
    declare enrol_limit int;
    
	select count(*) into currEnrol
    from takes
	where course_id = s_courseid and sec_id = s_secid
		and semester = s_semester and year = s_year; 
        
	select capacity into enrol_limit
		from classroom natural join section
		where course_id = s_courseid and sec_id = s_secid
			and semester = s_semester and year = s_year; 
            
    if currEnrol < enrol_limit then
		insert into takes values
			(s_id, s_courseid, s_secid, s_semester, s_year, null); 
		set errorMsg = '';
		set regState = 0;
	else -- Otherwise, section capacity limit already reached
		set errorMsg = concat('Enrollment limit reached for course ', 
						s_courseid, ' section ', s_secid); 
		set regState = -1;
    end if;
end //
delimiter ;

select count(*) from takes; -- 22 at this moment

-- find the course that reach its enrol limit
select * from classroom natural join section order by capacity; 
-- supose the tables are populated by smallRelationsInsertFile.sql
-- the smallest capacity is 10: for room 514 in Building Painter
-- there are 3 courses in this room including ('BIO-301', '1', 'Summer', '2018')
-- Add 10 more students to ('BIO-301', '1', 'Summer', '2018') which already has 1 enroll
-- So, the last student will not be enrolled 

-- find all students that has not taken 'BIO-301'
select group_concat(dt.ID) into @studentIDs from 
	(select ID from student
	 except
	 select ID from takes where course_id = 'BIO-301') as dt;
select @studentIDs;
-- '98765,70557,76543,44553,76653,54321,19991,00128,45678,55739,23121'

call registerStudent('98765', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('70557', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('76543', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('44553', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('76653', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('54321', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('19991', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('00128', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
call registerStudent('45678', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
select @regState, @errorMsg;

call registerStudent('55739', 'BIO-301', '1', 'Summer', '2018', @regState, @errorMsg);
select @regState, @errorMsg;

select count(*) from takes; -- 31 at this moment


##############################################################
# code on Page 23 of the slides
##############################################################
drop table if exists test_table;
create table test_table (s1 int, primary key (s1));

drop procedure if exists handlerdemo; 
delimiter //
create procedure handlerdemo ()
begin
	declare continue handler 
		for sqlstate '23000' -- Error Code: 1062;
-- SQLSTATE: 23000
-- Message: Duplicate entry '%s' for key %d
-- SQLSTATE values are taken from ANSI SQL and
-- ODBC (Open Database Connectivity) and are
-- more standardized than the numeric error codes.
        set @x2 = 1;
	set @x = 1;
	insert into test_table values (1);
	set @x = 2;
	insert into test_table values (1);
	set @x = 3;
end //
delimiter ;

call handlerdemo();
select @x;


# SQL TRIGGERS -- insert, delete or update
-- A trigger is a statement that is executed automatically by the system as a
-- side effect of a modification to the database.
--  To design a trigger mechanism, we must:
-- • Specify the conditions under which the trigger is to be executed.
-- • Specify the actions to be taken when the trigger executes

-- Triggers can be activated before an event, which can serve as extra
-- constraints. For example, convert blank grades to null.

-- FORMAT OF TRIGGER
-- pseudocode
delimiter //
create trigger trigger_name
<trigger_time> <triger_event> on table_name for each row
begin
...
end; //
delimiter ;
where <trigger_time> is BEFORE or AFTER
where <trigger_event> is INSERT (before only) or UPDATE (before or after) or DELETE (after only)
;



##############################################################
# code on Page 28 of the slides
##############################################################
drop trigger if exists cannot_teaches_more_than_2_courses_a_semester;

delimiter $$
create trigger cannot_teaches_more_than_2_courses_a_semester
	before insert on teaches for each row
    begin
        declare number_teaching int;
		select count(*) into number_teaching
        from teaches
        where ID=new.ID and semester=new.semester and year=new.year;
        if number_teaching >= 2 -- means there are already 2 courses
        then 
			signal sqlstate '45000'
            -- this is basically catching the specific error message that MySQL will return
			set message_text = 'Cannot teach more than two courses a semester';
		end if;
    end $$
delimiter ; 

-- update section table to comply with the foreign key constraint from teaches table 
insert into section values ('CS-347', '1', 'Spring', '2018', 'Watson', '120', 'A'); 
select * from teaches order by ID; 
insert into teaches values ('45565', 'CS-347', '1', 'Spring', '2018');  
insert into teaches values ('10101', 'CS-347', '1', 'Spring', '2018');  
select * from teaches order by ID;

-- ANOTHER EXAMPLE to Maintain credits_earned value
##############################################################
# code on Page 30 of the slides
##############################################################
drop trigger if exists credits_earned;
delimiter $$
create trigger credits_earned after update on takes 
	for each row
	begin
		if (new.grade <> 'F') and (new.grade is not null)
				and (old.grade = 'F' or old.grade is null)
		then
			update student
			set tot_cred = tot_cred + 
				(select credits from course where course.course_id = new.course_id)
			where student.ID = new.ID;    
		end if;
	end $$
delimiter ;

select * from takes where ID = '98988'; -- taking BIO-301 with null grade
select * from course where course_id = 'BIO-301'; -- credit is 4
select * from student where ID = '98988'; -- tot_cred is 120

update takes
set grade = 'A'
where ID = '98988' and course_id = 'BIO-301';

select * from student where ID = '98988'; -- tot_cred is 124
select * from takes where ID = '98988'; -- updated


-- RECURSION IN SQL
-- Example: find which courses are a prerequisite, whether directly or
-- indirectly, for a specific course

##############################################################
# code on Page 33 of the slides
##############################################################
select * from prereq;
-- need to change the last two rows to create the table in Figure 5.13
update prereq 
set course_id = 'CS-315', prereq_id = 'CS-190' 
where course_id = 'CS-315' and prereq_id = 'CS-101';
update prereq 
set course_id = 'CS-319', prereq_id = 'CS-315' 
where course_id = 'CS-347' and prereq_id = 'CS-101';
update prereq 
set course_id = 'CS-347', prereq_id = 'CS-319' 
where course_id = 'EE-181' and prereq_id = 'PHY-101';

with recursive rec_prereq(course_id, prereq_id) as (
	select course_id, prereq_id
    from prereq
    union
    select rec_prereq.course_id, prereq.prereq_id
    from rec_prereq, prereq
    where rec_prereq.prereq_id = prereq.course_id
)
select * from rec_prereq;


-- ANOTHER EXAMPLE - L3 find direct and indirect supervisors of Bob example using recursive queries
##############################################################
# code on Page 34 of the slides
# from now on, we use a new database.
##############################################################

create database testdb;
use testdb;

drop table if exists emp_super;
create table emp_super
	(person 	varchar(15),
	 supervisor 	varchar(15)
	);

insert into emp_super values 
('Bob', 'Alice'),
('Mary', 'Susan'),
('Alice', 'David'),
('David', 'Mary');  

-- if you want, you can change 'create view' to 'create table'
create view person_supervisor as
with recursive cte as (
		select person, supervisor
		from emp_super
  union
		select cte.person, emp_super.supervisor
		from cte, emp_super 
		where cte.supervisor = emp_super.person
)
select * from cte;
select * from person_supervisor;
select supervisor from person_supervisor where person = 'Bob';


-- ADVANCED AGGREGATION FUNCTIONS

-- 1. RANKING
-- Ranking is done in conjunction with an order by specification.
--  Suppose we are given a relation
-- student_grades(ID, GPA)
-- giving the grade-point average of each student
--  Find the rank of each student.
-- select ID, rank() over (order by GPA desc) as s_rank
-- from student_grades
--  An extra order by clause is needed to get them in sorted order
-- select ID, rank() over (order by GPA desc) as s_rank
-- from student_grades
-- order by s_rank
--  Ranking may leave gaps: e.g. if 2 students have the same top GPA, both
-- have rank 1, and the next rank is 3
-- • dense_rank does not leave gaps, so next dense rank would be 2

select * from student_grades;
select ID,GPA,rank() over (order by GPA desc) as s_rank from student_grades;
-- using dense_rank() -- if there are students with the same rank, the next diff rank will be +1 instead of +n duplicates
-- using rank(), the next diff rank will be +n duplicates
select ID,GPA,dense_rank() over (order by GPA desc) as s_rank from student_grades;

-- Ranking can be done within partition of the data.
-- e.g. “Find the rank of students within each department.”
select ID, dept_name,
rank() over (partition by dept_name order by GPA desc)
as dept_rank
from dept_grades
order by dept_name, dept_rank;
--  Multiple rank clauses can occur in a single select clause.
--  Ranking is done after applying group by clause/aggregation
--  Can be used to find top-n results
-- • More general than the limit n clause supported by many databases,
-- since it allows top-n within each partition

-- OTHER RANKING FUNCTIONS
-- • percent_rank (within partition, if partitioning is done)
-- • cume_dist (cumulative distribution)
--  fraction of tuples with preceding values
-- • row_number (non-deterministic in presence of duplicates)
-- • ntile (chunks into percentiles)
use testdb;
select * from student_grades;
select ID, ntile(4) over (order by GPA desc) as quartile
from student_grades;


-- 2. WINDOWING 
-- e.g. moving average: “Given sales values for each date, calculate for
-- each date the average of the sales on that day, the previous day, and the
-- next day”
-- • Given relation sales(date, value)
##############################################################
# code on Page 46 of the slides
##############################################################
drop table if exists sales;

create table sales (
	s_buyer varchar(12), 
    s_date date,    
	s_value real    
);
insert into sales values('A','2020-01-01',5);
insert into sales values('B','2020-01-03',5);
insert into sales values('C','2020-01-05',6);
insert into sales values('A','2020-01-06',7);
insert into sales values('B','2020-01-07',10);
insert into sales values('C','2020-01-08',9);
insert into sales values('A','2020-01-11',8);
insert into sales values('B','2020-01-12',7);
insert into sales values('C','2020-01-13',6);

select * from sales;

select s_date, 
	sum(s_value) over (order by s_date rows between 1 preceding and 2 following)
    -- window: between 1 preceding and 2 following
from sales; 

-- Examples of other window specifications:
-- • between rows unbounded preceding and current
-- • rows unbounded preceding
-- • range between 10 preceding and current row
--  All rows with values between current row value –10 to current value
-- • range interval 10 day preceding
--  Not including current row


-- PARTITION BY vs GROUP BY
-- They're used in different places. GROUP BY modifies the entire query, like
select customerId, count(*) as orderCount
from Orders
group by customerId
-- But PARTITION BY just works on a window function, like ROW_NUMBER():
select row_number() over (partition by customerId order by orderId)
    as OrderNumberForThisCustomer
from Orders

-- WINDOWING using unbounded, and also add partition by
select s_buyer, s_date,
	sum(s_value) over (partition by s_buyer
					   order by s_date
                       rows unbounded preceding) as balance
from sales
order by s_buyer, s_date;


-- AGGREGATION ON MULTI-DIMENSIONAL DATA - pivot table
-- e.g.
select * from sales;
select 
	item_name,
    sum(case color when 'dark' then quantity end) as dark,
    sum(case color when 'pastel' then quantity end) as pastel,
    sum(case color when 'white' then quantity end) as white
from sales
group by item_name;

-- NOTE: usually case when ... then .. else .. end
-- but here its case color when 'dark'
-- this is a short notation for sum(case when color='dark' then ...)


-- ROLLUP in mysql
select item_name,color,sum(quantity)
from sales
group by item_name,color;

select item_name,color,sum(quantity)
from sales
group by item_name,color with rollup;

-- CUBE 
select item_name,color,sum(quantity)
from sales
group by cube(item_name,color);
-- only in mysql















