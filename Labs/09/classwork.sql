 create table students(
 student_id int primary key,
 student_name varchar(20),
 h_pay int,
 y_pay int
 );
 insert into students values(3, 'sana', 250, 1120);
 select * from students;

 set serveroutput on;
 -- before insert
create or replace trigger insert_data
before insert on students
for each row
begin
IF:NEW.h_pay IS NULL THEN
:NEW.h_pay := 250;
end if;
end;
/
--before update
create or replace trigger update_salary
before update on students
for each row
begin
:NEW.y_pay := :NEW.h_pay*120;
end;
/
update students 
set h_pay = 1233 
where student_id = 3;

select * from students;
