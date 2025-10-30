-- Task 1: prevent table to drop
create or replace trigger prevent_tables
before drop ON database
begin
RAISE_APPLICATION_ERROR(
num=>-20000,
msg => 'cannot drop object'
);
end;
/
DROP table student_logs;
