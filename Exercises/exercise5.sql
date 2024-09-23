-- 5.8

select student, total_marks, rank() over (order by total_marks desc) as s_rank
from 
(
select student, sum(marks) total_marks
from S
group by student
) A;


-- SOLUTION -- need the s_rank <=10
select * 
from 
(
select student, total_marks, rank() over (order by (total_marks) desc) as s_rank
from 
(
select student, sum(marks) total_marks
from S
group by student
) A
) B
where s_rank<=10;

-- 5.9

select year,month,day,shares_traded,rank() over (order by (shares_traded) desc) as shares_rank
from nyse;

-- 5.22 - ntile and partition
-- 1. divide a into 20 equal sized paritions using CTE, then use the table
-- 2. show sum of c values for each partition id

with a_partitioned_s (a,b,c,a_partitions) as
(
	select a,b,c,ntile(20) over (order by (a) asc) as a_partitions
    from s
)
select a_partitions,sum(c)
from a_partitioned_s
group by a_partitions
order by a_partitions;

-- 5.23 - partition thing
-- Given a relation nyse(year,month,day,shares_traded,dollar_volume) 

-- for each month+year, create average dollar_volume as CTE, then use the table
-- to get the average value for that month + 2 pre months -> partition? ntile?

with nyse_monthly (year,month,monthly_dollar_volume) as 
(
	select year,month,sum(dollar_volume) monthly_dollar_volume
    from nyse
    group by year,month
)
select year,month,monthly_dollar_volume,
	avg(monthly_dollar_volume) over (order by (year,month) asc rows 2 preceding) as three_month_average
from nyse_monthly

