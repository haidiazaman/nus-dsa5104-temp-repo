##################################################################################
# Remark
# To facilitate the auto-marking, please start your code
# with "-- begin Qi code", and end your code with "-- end Qi code" 
# where i is from 1 to 12. 
# That opening/closing has been provided after each question.
# If you want to add comment to you code, please use /* ... */
# Do not use -- or # to comment your code inside the region enclosed by
# "-- begin Qi code" and "-- end Qi code"
# You can add any comment in any format outside that region though.
# You will read 3 examples, and then be asked to answer 12 questions.
# If you use several queries to answer a question, please make sure that 
# the last query produces the answer you want to submit.
#
# The tatal mark is 60. 
# Q1-Q9, 4 marks each. 
# Q10-Q12, 8 marks each. 
##################################################################################

use kaggle_car; # run car_prices.sql to create the database

/* the data is obtained from 
https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data

CREATE TABLE car_prices (
	year_manufacture integer, -- The manufacturing year of the vehicle.
	make varchar(20),         -- The brand or manufacturer of the vehicle.
	model varchar(40),        -- The specific model of the vehicle.
	trim varchar(100),        -- Aditional designation for the vehicle model.
	body varchar(40),         -- The body type of the vehicle (e.g., SUV, Sedan).
	transmission varchar(20), -- The type of transmission in the vehicle (e.g., automatic). 
	vin char(17),             -- Vehicle Identification Number, a unique code for each vehicle.
                              -- If a vin appears more than once, 
                              -- it means the car has been sold more than once.
	state char(2),            -- The state where the vehicle is registered.
                              -- We assume that is also the state where the car is sold.
	condition_scale integer,  -- Condition of the vehicle, rated on a scale, from 1 to 49.
	odometer integer,         -- The mileage (in miles) traveled by the vehicle.
	color varchar(20),        -- Exterior color of the vehicle.
	interior varchar(20),     -- Interior color of the vehicle.
	seller varchar(100),      -- The entity selling the vehicle.
	mmr integer,              -- Manheim Market Report, an estimated market value of the vehicle.
	selling_price integer,    -- The price at which the vehicle was sold.
	selling_date char(39)     -- The date and time when the vehicle was sold.
);
*/

#####################################################################################
# Example Question: Find the (make, model, trim, selling_price) of the car which has 
# the highest selling_price in Californa (ca)
# Hint: Exercise 3.1.d
#####################################################################################
-- begin Example code
select 
	make,   /* you can comment your code like this */
    model,  -- but please do not add comment starting with -- in this region
    trim,   # or add comment starting with #
    selling_price
from car_prices
where state = 'ca' 
	and selling_price = (select max(selling_price) from car_prices where state = 'ca');
-- end Example code


##################################################################################
# Example Question: list the top 5 (state, number_of_sells), ordered descendingly 
# by number_of_sells, which is the total number of cars sold in that state. 
# Consider all the states ever appeared in car_prices.state which can be null. 
# Hint: for example, Exercise 3.11.c
##################################################################################
-- begin Example code
select 
	state,
    count(*) as number_of_sells
from car_prices
group by state
order by number_of_sells desc
limit 5;
-- end Example code


#####################################################################################
# Goal: we want to figure out two more attributes for records in the car_prices table, 
# one is selling_year, one is selling_month, both are numeric.
#
# Example Question: Generate a table with attributes 
# (make, model, selling_price, selling_year, selling_month).
# Order it by descending order of selling_price and show only the first 5 rows.
#
# Hint: Use substring function and CASE statement which we have learned in school. 
# E.g., select substring(selling_date,12,4) as selling_year ......
# Use 'CASE' as in Exercise 3.5.a to convert 'Jan' to 1, 'Feb' to 2, and so on.
# https://dev.mysql.com/doc/refman/9.0/en/string-functions.html#function_substring
#####################################################################################
-- begin Example code
select 
	make, 
    model,
    selling_price,
    substring(selling_date,12,4) as selling_year,
    case substring(selling_date,5,3)         /* you can add comment like this */
		when 'Jan' then 1
        when 'Feb' then 2
        when 'Mar' then 3
        when 'Apr' then 4
        when 'May' then 5
        when 'Jun' then 6
        when 'Jul' then 7
        when 'Aug' then 8
        when 'Sep' then 9
        when 'Oct' then 10
        when 'Nov' then 11
        when 'Dec' then 12
	    else NULL
	end as selling_month
from car_prices
order by selling_price desc
limit 5;
-- end Example code



#####################################################################################
#####################################################################################
# Answer Q1 to Q12. 
#####################################################################################
#####################################################################################



#####################################################################################
# Our goal is to
# 1. create a table called us_states that has 2 attributes (full_name, abbreviation) 
# 2. Insert records of the 53 US states (51 states + Puerto Rico and Virgin Islands)
#    using us_states.txt available from canvas. 
# 
# After that, write a query or queries that can answer the following question.
# Q1: How many non-US states (they are actually states in Canada) that have ever 
# appeared in the column of car_prices.state? 
#
# Please note that state can be null. 
# But we assume that null is not a non-US state.
# Hint: Exercise 3.8.a. 
#####################################################################################
-- Please start your code of Q1 after 'drop table if exists us_states;'
-- begin Q1 code. 
drop table if exists us_states;
create table us_states
	(full_name		varchar(30),
	 abbreviation		varchar(2),
	 primary key (full_name)
	);
insert into us_states values ('Alabama', 'AL');
insert into us_states values ('Alaska', 'AK');
insert into us_states values ('Arizona', 'AZ');
insert into us_states values ('Arkansas', 'AR');
insert into us_states values ('California', 'CA');
insert into us_states values ('Colorado', 'CO');
insert into us_states values ('Connecticut', 'CT');
insert into us_states values ('Delaware', 'DE');
insert into us_states values ('District of Columbia', 'DC');
insert into us_states values ('Florida', 'FL');
insert into us_states values ('Georgia', 'GA');
insert into us_states values ('Hawaii', 'HI');
insert into us_states values ('Idaho', 'ID');
insert into us_states values ('Illinois', 'IL');
insert into us_states values ('Indiana', 'IN');
insert into us_states values ('Iowa', 'IA');
insert into us_states values ('Kansas', 'KS');
insert into us_states values ('Kentucky', 'KY');
insert into us_states values ('Louisiana', 'LA');
insert into us_states values ('Maine', 'ME');
insert into us_states values ('Montana', 'MT');
insert into us_states values ('Nebraska', 'NE');
insert into us_states values ('Nevada', 'NV');
insert into us_states values ('New Hampshire', 'NH');
insert into us_states values ('New Jersey', 'NJ');
insert into us_states values ('New Mexico', 'NM');
insert into us_states values ('New York', 'NY');
insert into us_states values ('North Carolina', 'NC');
insert into us_states values ('North Dakota', 'ND');
insert into us_states values ('Ohio', 'OH');
insert into us_states values ('Oklahoma', 'OK');
insert into us_states values ('Oregon', 'OR');
insert into us_states values ('Maryland', 'MD');
insert into us_states values ('Massachusetts', 'MA');
insert into us_states values ('Michigan', 'MI');
insert into us_states values ('Minnesota', 'MN');
insert into us_states values ('Mississippi', 'MS');
insert into us_states values ('Missouri', 'MO');
insert into us_states values ('Pennsylvania', 'PA');
insert into us_states values ('Rhode Island', 'RI');
insert into us_states values ('South Carolina', 'SC');
insert into us_states values ('South Dakota', 'SD');
insert into us_states values ('Tennessee', 'TN');
insert into us_states values ('Texas', 'TX');
insert into us_states values ('Utah', 'UT');
insert into us_states values ('Vermont', 'VT');
insert into us_states values ('Virginia', 'VA');
insert into us_states values ('Washington', 'WA');
insert into us_states values ('West Virginia', 'WV');
insert into us_states values ('Wisconsin', 'WI');
insert into us_states values ('Wyoming', 'WY');
insert into us_states values ('Puerto Rico', 'PR');
insert into us_states values ('Virgin Islands', 'VI');

select 
	count(distinct state) count_state
from car_prices 
where 
	state not in (
		select lower(abbreviation)
		from us_states
	);
-- end Q1 code



#####################################################################################
# First, delete the records in the us_states table whose abbreviation has ever 
# appeared in the column of car_prices.state.
# 
# Now, answer Q2: Find the number of records remaining in us_states.
# This is the number of US states that don't have car selling records in the 
# car_prices table
#
# Please note the role of null:
#    select 'ca' not in (null, 'oh') 
# returns null. Hence the query
#    select 7+3 where 'ca' not in (null, 'oh');
# returns empty. It won't return 10. Pay attention! But the query
#    select 7+3 where 'ca' not in ('tx', 'oh');
# returns 10 as one should expect.
# 
# Hint: Exercise 3.3.b
#####################################################################################
-- begin Q2 code
delete from us_states
where lower(abbreviation) in (
	select distinct state
    from car_prices
);

select count(*) count_remaining
from us_states;
       
-- end Q2 code



#####################################################################################
# We want to find the most popular models in California (ca) when body = 'Sedan'.
#
# Q3: return the top 5 (make, model, body, number_of_sells) with body = 'Sedan'.
# number_of_sells is the total number of sells in California of that particular 
# (make, model, body). Order your result by descending order of number_of_sells.
#
# Hint: In addtion to the example we gone through in class, 
# you can also see Exercise 3.1.e for grouping by using multiple attributes.
#####################################################################################
-- begin Q3 code
select 
	make, 
    model, 
    body, 
    count(vin) number_of_sells
from car_prices
where 
	state='ca' and 
    body='Sedan'
group by make, model, body
order by number_of_sells desc
limit 5;

-- end Q3 code



#####################################################################################
# Q4: list the top 5 most popular (make, model, number_of_sells). 
# Popularity is based on the total number of sells of that particular (make, model) 
#####################################################################################
-- begin Q4 code
select 
	make, 
	model, 
	count(vin) number_of_sells
from car_prices
group by make, model
order by number_of_sells desc
limit 5;

-- end Q4 code



#####################################################################################
# Q5: list the top 5 (state, average_selling_price) in descending order of 
# average_selling_price, which is the average selling price of all cars
# sold in that particular state.
#####################################################################################
-- begin Q5 code
select 
	state, 
    avg(selling_price) average_selling_price
from car_prices
group by state
order by average_selling_price desc
limit 5;

-- end Q5 code



#####################################################################################
# Q6: list the top 5 (state, number_of_sellers), ordered in descending order of 
# number_of_sellers, which is the number of distinct sellers (companies selling cars) 
# in that particular state. Note that it is sellers, not sells.
#####################################################################################
-- begin Q6 code
select 
	state, 
    count(distinct seller) number_of_sellers
from car_prices
group by state
order by number_of_sellers desc
limit 5;

-- end Q6 code



#####################################################################################
# Q7: For each make, find
# (make, num_of_models, num_of_sells, max_price, min_price, avg_price)  
# num_of_model is the number of unque models that belongs to that particular make,
# num_of_sells is the number of sells of that particular make,
# max_price, min_price, avg_price are corresponding selling prices for that make.
# Order your result by num_of_sells in desc order, return only the top 5.
#####################################################################################
-- begin Q7 code
select 
	make, 
    count(distinct model) num_of_models, 
    count(vin) num_of_sells, 
    max(selling_price) max_price, 
    min(selling_price) min_price, 
    avg(selling_price) avg_price
from car_prices
group by make
order by num_of_sells desc
limit 5;


-- end Q7 code



#####################################################################################
# Goal: we want to find the average selling price and number of sells for cars sold 
# in each (selling_month, selling_year), order the result by average selling price.
#
# Q8: You should return a table with the following attributes 
# (average_selling_price, number_of_sells, selling_year, selling_month).
# Hint: Modify the code from the third example above and consider Exercise 3.5.b 
#####################################################################################
-- begin Q8 code

/*  alternative method for getting year and month
select 
	avg(selling_price) average_selling_price, 
	count(vin) number_of_sells, 
	year(str_to_date(selling_date, '%a %b %d %Y %H:%i:%s GMT-0800 (PST)')) selling_year, 
	date_format(str_to_date(selling_date, '%a %b %d %Y %H:%i:%s GMT-0800 (PST)'),'%b') selling_month
from car_prices
group by selling_month, selling_year   
order by average_selling_price desc; 
*/

select 
	avg(selling_price) average_selling_price, 
	count(*) number_of_sells, 
    substring(selling_date,12,4) selling_year,
    case substring(selling_date,5,3)         
		when 'Jan' then 1
        when 'Feb' then 2
        when 'Mar' then 3
        when 'Apr' then 4
        when 'May' then 5
        when 'Jun' then 6
        when 'Jul' then 7
        when 'Aug' then 8
        when 'Sep' then 9
        when 'Oct' then 10
        when 'Nov' then 11
        when 'Dec' then 12
	    else NULL
	end as selling_month		
from car_prices
group by selling_month, selling_year   
order by average_selling_price desc; 

-- end Q8 code



#####################################################################################
# Goal: We want to find the average selling price and number of sells for cars 
# having different "conditions". The "condition" is based on condition_scale.
# After "select min(condition_scale), max(condition_scale) from car_prices",
# we know condtion_scale is between 1 and 49. 
# We hence can divide cars into 5 categories/conditions:
# 	c0: when condition_scale is between 1 and 9
# 	c1: when condition_scale is between 10 and 19
# 	......
# 	c4: when condition_scale is between 40 and 49
#   uknown: otherwise (meaning condition_scale is null)
# 
# Q9: Find all (car_condition, average_price, number_of_sells) 
# where car_condition is from c1 to unknown defined above,
#       average_price is for cars of that particular car_condition,
#       number_of_sells is the number of cars of that particular car_condition.
# Order your result by ascending order of car_condition (c0 < ... < c4 < unknown).
#####################################################################################
-- begin Q9 code
select 
	case 
		when condition_scale>=1 and condition_scale<=9 then 'c0'
        when condition_scale>=10 and condition_scale<=19 then 'c1'
        when condition_scale>=20 and condition_scale<=29 then 'c2'
        when condition_scale>=30 and condition_scale<=39 then 'c3'
        when condition_scale>=40 and condition_scale<=49 then 'c4'
        else 'uknown'
	end as car_condition,
    avg(selling_price) average_price,
    count(vin) number_of_sells
from car_prices
group by car_condition
order by car_condition asc;


-- end Q9 code


#####################################################################################
# Goal: We want to find how cars of different odometers are sold.
# By "select min(odometer), max(odometer) from car_prices",
# we know odometer is between 1 and 999999. 
# We hence can divide cars into 11 categories:
#   m0: when odometer is between 1 and 99999
# 	m1: when condition_scale is between 100000 and 199999
# 	......
# 	m9: when condition_scale is between 800000 and 999999
#   uknown: otherwise (`else` if using `case`)
#
# Q10: Find (odometer_condition, average_price, number_of_sells) 
# where odometer_condition is from m0 to unknown defined above,
#       average_price is for cars of that particular odometer_condition,
#       number_of_sells is the number of cars of that particular odometer_condition.
# Order your result by ascending order of odometer_condition (m0<...<m9<unknown).
#####################################################################################
-- begin Q10 code
select 
	case 
		when odometer>=1 and odometer<=99999 then 'm0'
        when odometer>=100000 and odometer<=199999 then 'm1'
		when odometer>=200000 and odometer<=299999 then 'm2'
        when odometer>=300000 and odometer<=399999 then 'm3'
        when odometer>=400000 and odometer<=499999 then 'm4'
        when odometer>=500000 and odometer<=599999 then 'm5'
        when odometer>=600000 and odometer<=699999 then 'm6'
        when odometer>=700000 and odometer<=799999 then 'm7'
        when odometer>=800000 and odometer<=899999 then 'm8'
        when odometer>=900000 and odometer<=999999 then 'm9'
        else 'uknown'
	end as odometer_condition, 
    avg(selling_price) average_price, 
    count(vin) number_of_sells
from car_prices 
group by odometer_condition
order by odometer_condition asc;    


-- end Q10 code



#####################################################################################
# Goal: There are cars that have been sold more than once in car_prices table, i.e., 
# whose vin appeared >= 2 times. Those cars will be called cars_that_have_been_resold.
# We want to know which (make, model) is mostly re-sold among different (make, model)'s. 
#
# Q11: return the top 5 (make, model, num_of_cars_that_have_been_resold),
# ordered by num_of_cars_that_have_been_resold descendingly. 
# num_of_cars_that_have_been_resold is the number of cars that belong to the type 
# specified by (make, model) and have been sold more than once in car_prices. 
# 
# Hint: Use subqueries. 
# Hint: You may want to use the aggregate function ANY_VALUE() when grouping by vin
# https://dev.mysql.com/doc/refman/9.0/en/miscellaneous-functions.html#function_any-value
#####################################################################################
-- begin Q11 code
select 
	make, 
	model, 
    count(vin) num_of_cars_that_have_been_resold
from (
		select 
			make, 
			model, 
			vin, 
			count(vin) num_times_sold
		from car_prices
		group by vin, make, model
		having num_times_sold >=2
	) as make_model_vin_num_times_sold
group by make, model
order by num_of_cars_that_have_been_resold desc
limit 5;

    
-- end Q11 code



#####################################################################################
# Q12: find the number of sells whose selling_price is bigger than 3 times the 
# average selling price of the same (make, model). 
#
# Hint: Use CTE (Common Table Expressions). See Section 3.8.6.
#
# Don't use the following code which is too slow for this data (it uses subqueries
# in the where clause similar to the queries on Page 98-103 of the textbook)
# select 
#     count(c1.selling_price)
# from car_prices as c1
# where c1.selling_price > 3 * (
# 	  select avg(c2.selling_price) 
#     from car_prices c2 
#     where c2.make=c1.make and c2.model=c1.model
#     );
#
# Don't run the above code, run the following to see how slow it can be
#
# select count(c1.selling_price)
# from car_prices as c1
# where c1.selling_price > 1.2 * (
# select avg(c2.selling_price) 
#     from car_prices c2 
#     where c2.make=c1.make and c2.model=c1.model
#     ) and c1.state = 'md' and c1.make='kia' and c1.color='white';
#####################################################################################
-- begin Q12 code

/* alternative method using joins

select count(*) number_of_sells
from car_prices A inner join (
	select make, model, avg(selling_price) avg_selling_price
    from car_prices
    group by make, model
    ) B on A.make=B.make and A.model=B.model
where selling_price > 3*avg_selling_price;

*/

with make_model_avg_price as (
    select 
        make, 
        model, 
        avg(selling_price) avg_selling_price
    from car_prices
    group by make, model
)
select 
    count(*) number_of_sells
from car_prices
where car_prices.selling_price > 3 * (
    select avg_selling_price 
    from make_model_avg_price 
    where 
		make_model_avg_price.make = car_prices.make and
        make_model_avg_price.model = car_prices.model
);

-- end Q12 code