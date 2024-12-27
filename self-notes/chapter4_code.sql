##############################################################
# code on Page 36 of the slides
##############################################################
drop database if exists testdb;
create database testdb; 
use testdb;

create table bankaccount
	(account_id varchar(10),
     account_name varchar(20),
	 balance numeric(10,2) check (balance >= 0),
     primary key (account_id)
    );
insert into bankaccount values 
	('ACC0001', 'Arnold', 50),('ACC0002', 'Brown', 500);

create table shoeshop
	(shoe_id varchar(10),
     stock_number int check (stock_number >= 0),
     unit_price numeric(10,2),
     primary key (shoe_id)
    );
insert into shoeshop values ('SHOE0001', 20, 100);

start transaction;
	update shoeshop set stock_number = stock_number-1 where shoe_id = 'SHOE0001';
	-- @variable_name is a user-defined variable (prefixe with @)
    -- two ways to set it value:
    -- select @price := unit_price from shoeshop where shoe_id = 'SHOE0001');
	set @price = (select unit_price from shoeshop where shoe_id = 'SHOE0001');
    update bankaccount set balance = balance-@price where account_id = 'ACC0001';
commit;
-- if you get an error in the above code, it will not reach "commit", you can run rollback
select * from shoeshop; -- to see what is wrong before rolling back
rollback;
select * from shoeshop; -- things are now fixed



##############################################################
# code on Page 38 of the slides
##############################################################
drop procedure if exists buy_one_shoes;

/*
In MySQL, the delimiter is changed in procedures to avoid syntax errors and to 
set custom delimiters. The default delimiter in MySQL is a semicolon (;), but 
if a semicolon is used within a statement, it can be interpreted as the end of 
the statement. This can cause syntax errors or incorrect execution.
*/
delimiter //
create procedure buy_one_shoes(in _account_id varchar(10), in _shoe_id varchar(10))
begin
	declare price numeric(10,2); -- price is a local variable
    
	declare continue handler for 3819 -- Error Code: 3819. Check constraint '...' is violated.
		begin 
			rollback;
		end;
        
	start transaction;         
		update shoeshop set stock_number = stock_number-1 where shoe_id = _shoe_id;
		set price = (select unit_price from shoeshop where shoe_id = _shoe_id); 
		update bankaccount set balance = balance-price where account_id = _account_id;
	commit;
end; //
-- the above line can be either end; // or end //
delimiter ;

call buy_one_shoes('ACC0002','SHOE0001');
select * from bankaccount;
select * from shoeshop;

call buy_one_shoes('ACC0001','SHOE0001');
select * from bankaccount;
select * from shoeshop;



##############################################################
# code on Page 44 of the slides
##############################################################
use testdb;
drop table if exists faculty; 
create table faculty
	(faculty_id int,
     name varchar(50) not null,
     address varchar(500),
     email varchar(50),
     salary numeric(10,2) check (salary>30000),
     primary key (faculty_id),
     -- a unique constraint on the 'email' column
     unique(email),
     -- name a unique constraint on (name, address) 
     constraint nameaddr_constr unique(name, address)
	);
insert into faculty values(001,'Holmes','221B B Street', 'info@s-h.co.uk',80000);
insert into faculty values(002,'Holmes','221B B Street', 'sh221B@gmail.com',80000);
insert into faculty values(003,'Holmes',null,'info@s-h.co.uk',80000); 
insert into faculty values(004,'Holmes',null,null,80000); 
insert into faculty values(005,null,null,'sh221B@gmail.com',80000);
insert into faculty values(006,'Holmes',null,'sh221B@gmail.com',20000); 
select * from faculty;



##############################################################
# code on Page 48 of the slides
##############################################################
use testdb;
drop table if exists advisor2;
create table student2
    (ID 	varchar(5), 
	 primary key (ID)
	);
insert into student2 values('11111');    
create table instructor2
	(ID 	varchar(5), 
	 primary key (ID)
	);
insert into instructor2 values('AAAAA');    
create table advisor2
	(s_ID			varchar(5),
	 i_ID			varchar(5),
	 primary key (s_ID),
	 foreign key (i_ID) references instructor2 (ID)
		on delete set null,
	 foreign key (s_ID) references student2 (ID)
		on delete cascade
	);  
insert into advisor2 values('11111','AAAAA'); 
     
select constraint_name, constraint_type
from information_schema.table_constraints
where table_schema='testdb' and table_name='advisor2';
 
alter table advisor2 drop constraint advisor2_ibfk_2;
alter table advisor2 add constraint 
	foreign key (s_ID) references student2 (ID) on delete cascade on update cascade;

select constraint_name, constraint_type
from information_schema.table_constraints
where table_schema='testdb' and table_name='advisor2';

select * from advisor2;      
update student2 set ID='22222' where ID='11111'; 
select * from advisor2;   



##############################################################
# code on Page 51 of the slides
##############################################################
create table person (
	ID int,
    name varchar(10),
    spouse varchar(10),
    primary key (ID),
    unique (name),
    foreign key (spouse) references person (name) ); 
insert into person values (1, 'John', 'Mary');    
insert into person values (1, 'John', null);  
insert into person values (2, 'Mary', null);
update person set spouse = 'Mary' where ID = 1;
update person set spouse = 'John' where ID = 2;
select * from person;