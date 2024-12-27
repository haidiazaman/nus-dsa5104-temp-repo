use university;
select * from takes;

create TABLE AB (
  	dept varchar(20),
  	position varchar(20)
);
create TABLE BC (
  	position varchar(20),
  	wage varchar(20)
);
insert into AB (dept,position)
values 
	('math','student'),
    ('sci','student'),
    ('econs','teacher'),
    ('english','dean');
    
insert into BC (position,wage)
values 
	('student','10'),
    ('student','20'),
    ('teacher','30'),
    ('dean','40');    
    
select * from AB;
select * from BC;
select a.dept, a.position, b.wage from AB a natural join BC b;

    