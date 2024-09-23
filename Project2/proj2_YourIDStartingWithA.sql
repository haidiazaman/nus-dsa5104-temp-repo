#####################################################################################
# Project 2 has two parts.
# Part 1: Q1-7: 4 marks each 
#         Q8-9: 6 marks each
# Part 2: php file to insert a record into the student table in university database. 
#         20 marks. See the last 4 pages of the slides of chapter6 for more details.
#####################################################################################

use chicago; 
# which contains three tables: chicago_school, chicago_crime, chicago_socioeconomic
#####################################################################################
# Q1: Write a single query to produce a table whose first few rows look like the following
#
#   community_area_name, ES, MS, HS
#   ALBANY PARK,         6,  1,  1  
#   ARCHER HEIGHTS,      1,  0,  1
#   ARMOUR SQUARE,       2,  0,  1
#   .......
#
# Strings in the first column are community_area_name; the second column are the number 
# of elementary schools in that area; the third and fourth columns are the number of 
# middle schools and high schools in that area. Order your result in ascending order of
# community_area_name. Return only the first 7 rows
# Hint: Use 'case' statement. See chapter3 slides, page 88; chapter 5 slides, page 54.
#       Use chicago_school
#####################################################################################
-- begin Q1 code 

-- end Q1 code



#####################################################################################
# When you run the following query
# 
# 	select location_description, primary_description, count(*) as number_of_crimes
# 	from chicago_crime
# 	where location_description in ('STREET', 'RESIDENCE', 'APARTMENT', 'SIDEWALK', 'RESTAURANT', 'GROCERY FOOD STORE', 'GAS STATION')
# 		and primary_description in ('THEFT', 'BATTERY', 'NARCOTICS', 'CRIMINAL DAMAGE', 'BURGLARY')
# 	group by location_description, primary_description
# 	order by number_of_crimes desc;
#
# you obtain
#
# location_description, primary_description, number_of_crimes
# SIDEWALK,             NARCOTICS,           2514
# APARTMENT,            BATTERY,             2235
# STREET,               THEFT,               2144
# STREET,               NARCOTICS,           1936
# STREET,               CRIMINAL DAMAGE,     1760
# ......                ......               ...... 
# SIDEWALK,             BURGLARY,            4
# GAS STATION,          BURGLARY,            2
#
# which is a table with 35 records.
# Now, I want you to generate the assocaited pivot table of the above results, namely,
# it is a 7 by 5 table (if you only look at the numbers) that looks like the following
#
# location_description, THEFT, BATTERY, NARCOTICS, CRIMINAL DAMAGE, BURGLARY
# STREET,               2144,  993,    1936,       1760,            10
# SIDEWALK,             303,   1203,   2514,       50,              4
# RESTAURANT,           306,   81,     25,         69,              37
# ......                ...... ......  ......      ......           ......
# 
# Q2: Write a single query to generate the above pivot table.
# Order your result by desc order of location_description.
# Hint: use chicago_crime
#####################################################################################
-- begin Q2 code

-- end Q2 code



#####################################################################################
# Q3. Write a single query that uses left joint to produce a table 
# that lists the number of crimes and number of schools in each ward.
# You whole table should look like the following
#   ward, number_of_crimes, number_of_schools
#   1,    913,              14
#   2,    1839,             21  
#   .......
#   50,   492,              7
#   NULL, 2,                NULL
# where number_of_crimes and number_of_schools are for the corresponding ward.
# Order your result by ascending order of ward with NULL considered to be the largest.
# Show only the first 7 rows.
# Hint: Use tables chicago_crime and chicago_school
#####################################################################################
-- begin Q3 code 

-- end Q3 code



#####################################################################################
# Q4: Suppose you live in 'Lincoln Square' (which is the name of a community area). 
# Write a single query to find the top 5 most common crimes in this area, 
# namely, find top 5 (primary_description, number_of_crimes) in 'Lincoln Square'.
# primary_description determines crime type. number_of_crimes is the reported 
# number of cases for the crime of the type determined by primary_description.
# Hint: Use tables chicago_crime and chicago_socioeconomic
#####################################################################################
-- begin Q4 code 

-- end Q4 code



#####################################################################################
# Q5: Suppose you concern about the safety in school. 
# Write a single query to find the top 5 
# (community_area_name, number_of_crimes)
# for crimes committed in any school related area. 
# number_of_crimes refers to number of crimes in school related areas in 
# community_area_name. A crime happens in a school related area if the 
# location_description contains string 'school'. 
# Order your result by descending order of number_of_crimes.
# Hint: Use tables chicago_crime and chicago_socioeconomic
#####################################################################################
-- begin Q5 code

-- end Q5 code



#####################################################################################
# Q6: Write a single SQL query to find 
# (community_area_name, hardship_index, number_of_schools, average_school_performance, average_safety_score)
# for all communities with a hardship index either >=90 or <=10.
#
# In chicago_socioeconomics, each community area has a hardship_index.
# number_of_schools is the number of schools in that community area.
#
# average_school_performance is based on cps_performance_policy_level as follows:  
# shcool performance = k if cps_performance_policy_level is 'Level k' with k = 1, 2 or 3. 
# Otherwise, school performance is null. 
#
# average_school_performance should be based on those non-null shcool performance values.
# 
# average_safety_score is based on safety_score in chicago_school 
#
# Hint: Use tables chicago_school and chicago_socioeconomic.
#####################################################################################
-- begin Q6 code 

-- end Q6 code



#####################################################################################
# Did you see anything unusual when executing the following query
# 
#   select teachers_icon, 
#          min(teachers_score) as min_score, 
#          max(teachers_score) as max_score
#   from chicago_school 
#   group by teachers_icon
#   order by min_score;
#
# Q7: Don't modify the chicago_school table. Write a single query that produce the 
#     right result. Your result should still include the NDA case in the last row. 
#     But now it is fine to say that when teachers_icon is NDA, the min_score and 
#     max_score are both null. 
#####################################################################################
-- begin Q7 code

-- end Q7 code



#####################################################################################
# In chicago_school table, the icon fields are calculated based on the value in 
# the corresponding score field. You need to make sure that when a score field 
# is updated, the icon field is updated too. To do this, you will write a stored 
# procedure that receives the school id and a teachers score as input parameters, 
# calculates the icon value and updates the fields accordingly.
#
# Q8: Write a stored procedure called procedure_to_update_teachers_score that takes 
# two input paramers in_school_id int and in_teachers_score varchar(3). 
# Inside the stored procedure, use an IF statement to 
# update both the teachers_score and teachers_icon attributes the 
# chicago_school table for the school identified by in_school_id. 
#
# The teachers_score grows from 1 to 99 when it is not 'NDA'.
# Correspondingly, in addition to 'NDA', there are 5 categories 
# of teachers_icon, ranging from 'Very Weak' to 'Very Strong'.
# Use the result of Q7 to figure out the connection between 
# the teachers_score and teachers_icon.
#
# Hint:
# You may try
#   if in_teachers_score > 0 and in_teachers_score < 20 then
# 	    do something
#   elseif in_teachers_score < 40 then
#       do something  
#   ......
#   end if;
#
# Please keep the "drop procedure if exists procedure_to_update_teachers_score;" in the code area
#####################################################################################
-- begin Q8 code 
drop procedure if exists procedure_to_update_teachers_score;
 
-- end Q8 code



#####################################################################################
# Q9: Use trigger to do the same thing as in Q7 whenever someone directly executes 
# statement like the following to update but only update the teachers_score
#    update chicago_school set teachers_score = 62 where school_id = 609676;
#
# For simplicity, in the trigger, you only handle the case when one tries to update 
# only teachers_score and have no attention to update teachers_icon and other attributes
# simultaneously. For more complicated 'update chicago_school', you do nothing in the 
# trigger that you will submit. For example, in the trigger, you will not prevent one from 
# executing (which is inconsistent, by the way)
#    update chicago_school set teachers_score = 63, teachers_icon = 'Weak' where school_id = 609676;
# 
# Hint: For obvious reason, you should not execute 'update chicago_school' inside 
# the trigger which is triggered by 'update chicago_school'. 
# 
# Note that according to https://dev.mysql.com/doc/refman/9.0/en/trigger-syntax.html,
# "A column named with OLD is read only. You can refer to it, but not modify it. 
# You can refer to a column named with NEW. In a BEFORE trigger, you can also 
# change its value with SET NEW.col_name = value. This means you can use a trigger 
# to modify the values to be inserted into a new row or used to update a row. 
# Such a SET statement has no effect in an AFTER trigger because the row change 
# has already occurred."
# 
# Read the above remark and decide if you should use 'before update on chicago_school'
# or 'after update on chicago_school' in your trigger definition.

# Please keep 'drop trigger if exists trigger_update_chicago_school_teachers_score_only;'
# in the code area.
#####################################################################################
-- begin Q9 code 
 
-- end Q9 code


