query1 = 'select id, name from instructor'
query2 = 'select id, upper(name) name from (select * from instructor)'
print(query2.upper())
print(query2.upper().index('FROM'))
a = query2.upper().index('FROM')
print(query2[a:])
print(query2[7:a])
column_names = query2[7:a]
print(column_names.split(','))
column_names = column_names.split(',')
column_names = [s.strip() for s in column_names]
print(column_names)
column_names = [s.split(' ')[-1] for s in column_names]
print(column_names)
print('id'.split(' ')[-1])


create procedure procedure_to_update_teachers_score(in in_school_id int, in in_teachers_score varchar(3))
begin
	declare new_icon varchar(11);
    
	update chicago_school set teachers_score = in_teachers_score where school_id = in_school_id;
    
    if in_teachers_score > 0 and in_teachers_score < 20 then
		set new_icon = 'Very Weak';
	elseif in_teachers_score < 40 then
		set new_icon = 'Weak';
	elseif in_teachers_score < 60 then
		set new_icon = 'Average';
	elseif in_teachers_score < 80 then
		set new_icon = 'Strong';
	elseif in_teachers_score < 100 then
		set new_icon = 'Very Strong';
	end if;
    update chicago_school set teachers_icon = new_icon where school_id = in_school_id;
end
$$
delimiter ;  