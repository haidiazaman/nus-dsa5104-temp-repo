#####

-- 4.2
-- 4.2a
-- select * from instructor;
-- select * from teaches;
select instructor.ID, count(sec_id) num_sec_taught
from instructor left join teaches
on instructor.ID=teaches.ID
group by ID;

-- 4.2b
select ID, count(sec_id) num_sec_taught
from (select a.ID,b.sec_id from instructor a, teaches b where a.ID=b.ID) temp
group by ID;

SELECT ID, (
    SELECT COUNT(*) AS Number_of_sections
    FROM teaches T
    WHERE T.id = I.id
)
FROM instructor I;


-- 4.2c
select A.ID,A.course_id,A.sec_id,A.semester,A.year
from teaches A
right join
(select * from section where semester='Spring' and year=2018) B
on 
	A.course_id=B.course_id and
    A.sec_id=B.sec_id and
    A.semester=B.semester and
    A.year=B.year;
-- wrong

select *
from section natural left join teaches;

-- SOLUTION
SELECT course_id,sec_id,ID,decode(name,null,'-',name) as name
FROM (section NATURAL LEFT OUTER JOIN teaches)
    NATURAL LEFT OUTER JOIN instructor
WHERE semester = 'Spring' AND year = 2018;
-- A more complex version of the query can be written using union 
-- of join result with another query that uses a subquery to find courses that do not match


-- 4.2d
select * from department;
select *
from instructor natural left join department
;

select * from instructor;
select dept_name, count(ID) num_instr
from instructor
group by dept_name;

GROUP BY dept_name;
select * from department NATURAL LEFT OUTER JOIN instructor;

select * from department; -- 7
select * from instructor; -- 12
select * from department natural join instructor;
-- ** left and right joins are outer joins
-- so left join would mean it keeps all the common rows btwn right and left tables that fit the condition
-- and also all of the other rows in the left tables that doesnt meet the condition

-- SOLUTION
SELECT dept_name, COUNT(id)
FROM department NATURAL LEFT  JOIN instructor;

######

######
-- 4.3a
SELECT * FROM student NATURAL LEFT OUTER JOIN takes; -- 23
select * from student;
select * from takes;
select s.ID,s.name,s.dept_name,s.tot_cred,
t.course_id,t.sec_id,t.semester,t.year,t.grade from student s, takes t
where s.ID=t.ID or s.ID not in (select distinct ID from takes); -- 22
-- how to keep the rows from left table? cause now id number 70557 not kept

(select s.ID,s.name,s.dept_name,s.tot_cred,
t.course_id,t.sec_id,t.semester,t.year,t.grade from student s, takes t
where s.ID=t.ID) 
union
(select * from student);
; -- 22
-- SOLUTION 1
select * from student natural join takes
union
select
ID,name,dept_name,tot_cred,null,null,null,null,null -- to make same number of columns can do null,...
from student s1 where not exists (select id from takes t1 where t1.id=s1.id);

-- SOLUTION 2
SELECT * FROM student NATURAL JOIN takes
UNION
SELECT ID,name,dept_name,tot_cred,null,null,null,null,null
FROM student S1 
WHERE ID NOT IN (SELECT ID FROM takes);


-- 4.3b
-- QUESTION
SELECT * FROM student NATURAL FULL OUTER JOIN takes;


select 
	s.ID,s.name,s.dept_name,s.tot_cred,
	t.course_id,t.sec_id,t.semester,t.year,t.grade 
from student s, takes t
where s.ID=t.ID
union
select *,null,null,null,null,null
from student
union
select ID,null,null,null,course_id,sec_id,semester,year,grade 
from takes; -- 57 rows

-- SOLUTION
(SELECT * FROM student NATURAL JOIN takes)

UNION

(
    SELECT ID,name,dept_name,tot_cred,null,null,null,null,null
    FROM student S1    
    WHERE NOT EXISTS (SELECT ID FROM takes T1 WHERE T1.id = S1.id)
)

UNION 

(
    SELECT ID,null,null,null,course_id,sec_id,semester,year,grade
    FROM takes T1
    WHERE NOT EXISTS (SELECT ID FROM student S1 WHERE T1.id = S1.id)
);

-- full outer join doesnt mean including all the null values
-- your solution almost correct but needs to include the not exists thing to ensure 
-- no full null rows


#####

#####

-- 4.15
-- QUESTION
SELECT * 
FROM section NATURAL JOIN classroom;

select * from section;
select * from classroom;

select * from section s inner join classroom c 
using (building, room_number); -- 15

-- SOLUTION

SELECT c.building,c.room_number,course_id,sec_id,semester,year,time_slot_id,capacity
FROM section INNER JOIN classroom c USING (building, room_number); 

-- 4.20
select * from takes;
select * from course;
select t.ID,t.course_id,t.sec_id,t.semester,t.year,t.grade,c.credits
from takes t left join course c
on t.course_id=c.course_id;

-- MY ANSWER
create view tot_credits(year,num_credits) as 
(
	select year, sum(credits) num_credits
	from takes t left join course c
	on t.course_id=c.course_id
	group by year
);


-- SOLUTION
CREATE VIEW tot_credits(year,num_credits) AS (
    SELECT year, SUM(credits)
    FROM takes NATURAL JOIN course
    GROUP BY year
    ORDER BY year ASC
)
