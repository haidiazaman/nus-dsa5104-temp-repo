use university;

######
-- 3.1
-- 3.1a
select title from course where dept_name='Comp. Sci.' and credits=3;

-- 3.1b
select * from takes;
select * from student;
select * from instructor;
select * from teaches;
select distinct ID from takes where course_id in 
	(select course_id from teaches where ID in 
		(select ID from instructor where name='Einstein'));

select ID 
from takes inner join 
(select course_id from teaches a left join instructor b on a.ID=b.ID where b.name='Einstein') c 
on takes.course_id = c.course_id;

-- SOLUTION
-- SELECT DISTINCT takes.ID
-- FROM takes, instructor, teaches
-- WHERE takes.course_id = teaches.course_id AND 
--     takes.sec_id = teaches.sec_id AND 
--     takes.semester = teaches.semester AND 
--     takes.year = teaches.year AND 
--     teaches.id = instructor.id AND 
--     instructor.name = 'Einstein';

-- 3.1c
select max(salary) from instructor;
 
-- 3.1d
select ID, name 
from instructor
where salary=(select max(salary) from instructor);

-- 3.1e
select * from section;
select course_id,sec_id,count(id) enrollment
from (select * from takes where semester='Fall' and year=2017) a
group by course_id,sec_id;

select course_id,sec_id,count(id) enrollment
from takes 
where semester='Fall' and year=2017
group by course_id,sec_id;

-- SOLUTION
-- SELECT course_id, sec_id, (
--     SELECT COUNT(id)
--     FROM takes
--     WHERE takes.year = section.year
--         AND takes.semester = section.semester
--         AND takes.course_id = section.course_id 
--         AND takes.sec_id = section.sec_id
-- ) AS enrollment 
-- FROM section 
-- WHERE semester = 'Fall' AND year = 2017

-- 3.1f 
with temp (course_id,sec_id,enrollment) as
	(select course_id,sec_id,count(id)
	from takes 
	where semester='Fall' and year=2017
    group by course_id,sec_id)
select course_id,sec_id,if(enrollment is not null, enrollment, 0) max_enrollment
from temp
where enrollment=(select max(enrollment) from temp);

-- SOLUTION
-- WITH enrollment_in_fall_2017(course_id, sec_id, enrollment) AS (
--     SELECT course_id, sec_id, COUNT(id)
--     FROM takes
--     WHERE semester = 'Fall' AND year = 2017
--     GROUP BY course_id, sec_id
-- ) 
-- SELECT CASE 
--         WHEN MAX(enrollment) IS NOT NULL THEN MAX(enrollment)
--         ELSE 0
--        END
-- FROM enrollment_in_fall_2017;

-- 3.1g
with temp (course_id,sec_id,enrollment) as
	(select course_id,sec_id,count(id)
	from takes 
	where semester='Fall' and year=2017
    group by course_id,sec_id)
select course_id,sec_id
from temp
where enrollment=(select max(enrollment) from temp);

-- SOLUTION
-- WITH enrollment_in_fall_2017(course_id, sec_id, enrollment) AS (
--     SELECT course_id, sec_id, COUNT(id) 
--     FROM takes
--     WHERE semester = 'Fall' AND year = 2017
--     GROUP BY course_id, sec_id
-- ) 
-- SELECT course_id, sec_id
-- FROM enrollment_in_fall_2017
-- WHERE enrollment = (SELECT MAX(enrollment) FROM enrollment_in_fall_2017);

######

######
-- 3.3

-- 3.3a
update instructor
set salary = salary*1.1
where dept_name = 'Comp. Sci.';

-- 3.3b
delete from course
where course_id not in (select distinct course_id from section);

-- 3.3c
insert into instructor
select ID, name, dept_name, 10000
from student 
where tot_cred>100;

#####

#####
-- 3.6
select dept_name 
from department
where lower(dept_name) like "%sci%" and dept_name is not null;


#####

#####
-- 3.11

-- 3.11a
-- join takes and course on dept_name, keep course_id
-- select ID, name

select distinct student.ID, student.name
from student inner join 
(select takes.ID, takes.course_id
from takes inner join course on takes.course_id=course.course_id 
where dept_name like '%Comp%') A 
on student.ID=A.ID;

-- SOLUTION
-- SELECT DISTINCT student.ID, student.name
-- FROM student INNER JOIN takes  ON student.ID = takes.ID 
--              INNER JOIN course ON takes.course_id = course.course_id
-- WHERE course.dept_name = 'Comp. Sci.';

-- 3.11b -- question dont make sense

-- 3.11c
select max(salary) max_salary,dept_name
from instructor 
group by dept_name;

-- 3.11d
with temp (salary,dept_name) as 
	(select max(salary) salary,dept_name
	from instructor 
	group by dept_name) 
select salary, dept_name
from temp 
where salary=(select min(salary) from temp);
    
with temp (salary,dept_name) as 
	(select max(salary) salary,dept_name
	from instructor 
	group by dept_name) 
select min(salary)
from temp ;

#####

#####
-- 3.27
with temp (ID, course_id, num_times) as 
(select ID, course_id, count(*) num_times
from takes
group by ID, course_id
having num_times>1)
select ID
from temp 
group by ID
having count(course_id)>=3;


#####

#####
-- 3.28
-- group by ID from teaches
-- having count courseid = distinct (subquery of number of distninc. course id  for that deptname)

select A.ID, A.name
from 
(select instructor.ID, instructor.name, instructor.dept_name, count(course_id) num_course_taught
from instructor right join teaches
on instructor.ID=teaches.ID
group by ID,name,dept_name) A
inner join
(select dept_name,count(course_id) total_num_courses
from course
group by dept_name) B
on A.dept_name=B.dept_name and A.num_course_taught=B.total_num_courses
order by name asc;


-- SOLUTION
SELECT id, name
FROM instructor AS i
WHERE NOT EXISTS (
    (SELECT course_id FROM course WHERE dept_name = i.dept_name)
    EXCEPT 
    (SELECT course_id FROM teaches WHERE teaches.id = i.id)
)
ORDER BY name ASC;
-- check chatgpt for explanation

