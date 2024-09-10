-- JOIN OPERATIONS -cartesian products
-- natural, inner, outer join

-- NATURAL JOIN
-- combines on all common attributes without specifying any attributes
-- from clause can have multiple relations natural joined tgt

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
-- this doesnt work

-- ON VS USING CLAUSE
-- ON is the more general of the two. One can join tables ON a column, a set of columns and even a condition. For example:
SELECT * FROM world.City JOIN world.Country ON (City.CountryCode = Country.Code) WHERE ...

-- USING is useful when both tables share a column of the exact same name on which they join. In this case, one may say:
SELECT ... FROM film JOIN film_actor USING (film_id)