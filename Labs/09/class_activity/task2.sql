-- Task 2:prevent only students table(ONLY) being deleted;
create or replace trigger prevent_tables
before drop on schema
begin
if ora_dict_obj_type = 'TABLE' and ora_dict_obj_name = 'STUDENTS' then
raise_application_error(
num => -20000,
msg => 'cannot drop object'
);
end if;
end;
/
drop table student_logs;
