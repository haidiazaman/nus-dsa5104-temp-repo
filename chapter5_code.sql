##############################################################
# code on Page 10 of the slides
##############################################################
drop procedure if exists instructor_of;
-- https://dev.mysql.com/doc/refman/9.0/en/create-procedure.html
-- you cannot return a table from MySQL function 
delimiter //
create procedure instructor_of(in in_dept_name varchar(20))
begin
	select ID, name, dept_name, salary
	from instructor 
	where dept_name = in_dept_name;
end; //
delimiter ;
         
call instructor_of('Physics');


##############################################################
# code on Page 13 of the slides
##############################################################
drop procedure if exists dept_count_proc; 
delimiter //
create procedure dept_count_proc(in dept_name_str varchar(20), out d_count int)
begin
	select count(*) into d_count
	from instructor 
	where dept_name = dept_name_str;
end //
delimiter ;
         
call dept_count_proc('Physics', @num_count);

select @num_count;


##############################################################
# code on Page 16 of the slides
##############################################################
drop procedure if exists fib1; 
delimiter //
create procedure fib1(in n int, out answer int)
begin 
    declare i int default 2;
    declare p, q int default 1;
    set answer = 1;
    while i < n do
        set answer = p + q;
        set p = q;
        set q = answer;
        set i = i + 1;
    end while;
end //
delimiter ;
         
call fib1(5, @answer1);
select @answer1;


##############################################################
# code on Page 17 of the slides
##############################################################
drop procedure if exists fib2; 
delimiter //
create procedure fib2(in n int, out answer int)
begin
    declare i int default 1;
    declare p int default 0;
    declare q int default 1;
    set answer = 1;
    repeat
        set answer = p + q;
        set p = q;
        set q = answer;
        set i = i + 1;
    until i >= n end repeat;
end //
delimiter ;

call fib2(6, @answer2);
select @answer2;


##############################################################
# code on Page 18 of the slides
##############################################################
drop procedure if exists fib3; 
delimiter //
create procedure fib3(in n int, out answer int)
begin
    declare i int default 2;
    declare p, q int default 1;
    set answer = 1;
    loop1: loop
        if i >= n then
            leave loop1;
        end if;
        set answer = p + q;
        set p = q;
        set q = answer;
        set i = i + 1;
    end loop loop1;
end //
delimiter ;

call fib3(7, @answer3);
select @answer3;

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
		for sqlstate '23000' 
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


##############################################################
# code on Page 37 of the slides
##############################################################
drop table if exists student_grades;

create table student_grades (
	ID varchar(5),
    student_name varchar(20),
	dept_name varchar(20),
	GPA decimal(3,2),
    primary key (ID)
);

insert into student_grades values ('00128', 'Zhang', 'History', '3.5');
insert into student_grades values ('12345', 'Shankar', 'History', '3.6');
insert into student_grades values ('19991', 'Brandt', 'History', NULL);
insert into student_grades values ('23121', 'Chavez', 'History', '3.1');
insert into student_grades values ('44553', 'Peltier', 'Music', '3.5');
insert into student_grades values ('45678', 'Levy', 'Music', '2.5');
insert into student_grades values ('54321', 'Williams', 'Music', '4.0');
insert into student_grades values ('55739', 'Sanchez', 'Music', '3.5');
insert into student_grades values ('70557', 'Snow', 'Physics', '2.0');
insert into student_grades values ('76543', 'Brown', 'Physics', '3.1');
insert into student_grades values ('76653', 'Aoi', 'Physics', '3.1');
insert into student_grades values ('98765', 'Bourikas', 'Physics', '2.4');
insert into student_grades values ('98988', 'Tanaka', 'Physics', '3.1');

select * from student_grades;

select 
	ID,
    GPA,
    rank() over (order by GPA desc) as s_rank
from student_grades;


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
from sales; 

select s_buyer, s_date,
	sum(s_value) over (partition by s_buyer
					   order by s_date
                       rows unbounded preceding) as balance
from sales
order by s_buyer, s_date;


##############################################################
# code on Page 51 of the slides
##############################################################
drop table if exists sales;

create table sales (
	item_name char(5),
	color varchar(6),
	clothes_size varchar(6),
	quantity integer
);

insert into sales values('dress', 'dark', 'small', 2);
insert into sales values('dress', 'dark', 'medium', 6);
insert into sales values('dress', 'dark', 'large', 12);
insert into sales values('dress', 'pastel', 'small', 4);
insert into sales values('dress', 'pastel', 'medium', 3);
insert into sales values('dress', 'pastel', 'large', 3);
insert into sales values('dress', 'white', 'small', 2);
insert into sales values('dress', 'white', 'medium', 3);
insert into sales values('dress', 'white', 'large', 0);

insert into sales values('pants', 'dark', 'small', 14);
insert into sales values('pants', 'dark', 'medium', 6);
insert into sales values('pants', 'dark', 'large', 0);
insert into sales values('pants', 'pastel', 'small', 1);
insert into sales values('pants', 'pastel', 'medium', 0);
insert into sales values('pants', 'pastel', 'large', 1);
insert into sales values('pants', 'white', 'small', 3);
insert into sales values('pants', 'white', 'medium', 0);
insert into sales values('pants', 'white', 'large', 2);

insert into sales values('shirt', 'dark', 'small', 2);
insert into sales values('shirt', 'dark', 'medium', 6);
insert into sales values('shirt', 'dark', 'large', 6);
insert into sales values('shirt', 'pastel', 'small', 4);
insert into sales values('shirt', 'pastel', 'medium', 2);
insert into sales values('shirt', 'pastel', 'large', 1);
insert into sales values('shirt', 'white', 'small', 17);
insert into sales values('shirt', 'white', 'medium', 1);
insert into sales values('shirt', 'white', 'large', 10);

insert into sales values('skirt', 'dark', 'small', 2);
insert into sales values('skirt', 'dark', 'medium', 5);
insert into sales values('skirt', 'dark', 'large', 1);
insert into sales values('skirt', 'pastel', 'small', 11);
insert into sales values('skirt', 'pastel', 'medium', 9);
insert into sales values('skirt', 'pastel', 'large', 15);
insert into sales values('skirt', 'white', 'small', 2);
insert into sales values('skirt', 'white', 'medium', 5);
insert into sales values('skirt', 'white', 'large', 3);

select 
	item_name,
    sum(case color when 'dark' then quantity end) as dark,
    sum(case color when 'pastel' then quantity end) as pastel,
    sum(case color when 'white' then quantity end) as white
from sales
group by item_name;