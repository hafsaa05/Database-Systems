-- Aggregate Functions

select count(*) as total_employees from EMPLOYEES;
SELECT count(*) as total_employees, manager_id from employees group by(manager_id);
select distinct manager_id from EMPLOYEES;
select manager_id from EMPLOYEES group by (manager_id);
select sum(salary) as TOTAL_SALARY from employees;
select min(salary) as minimum_salary from employees;
select max(salary) as max_salary from employees;
select avg(salary) as average_salary from employees;

--Concatenation 
select first_name || salary as first_name_and_salary from employees;
select ALL salary from employees;
select salary from employees;
select salary from employees order by (salary) asc ; --ascending order
select first_name , hire_date from employees order by (first_name) asc ; --ascending order
select first_name , hire_date from employees order by (hire_date) desc ; --descending order

-- like operation : used for searching purpose
select first_name from employees where first_name like 'A__s%'; 
select first_name from employees where first_name like '%H%'; -- % means zero or more

-- Numeric Funtions Functions
-- DUAL : dummy table (just used for calculations)
select * from DUAL;
select abs(-90.8) from dual; --returns positive number
select ceil(-90.8) from dual; -- returns one greater number
select floor(90.8) from dual; -- returns one smaller number
select floor(-90.8) from dual; -- returns one smaller number
select trunc(90.123456 , 3) from dual; 
select round(90.8) from dual; -- rounds off the number
select round(-90.8) from dual; -- rounds off the number
select greatest(9,8,7) from dual;-- returns greatest number
select least(9,8,7) from dual;-- return least number

--String functions
select lower('hafsa') from dual; -- lower case
select first_name, lower(last_name) from employees; --LOWERCASE
select INITCAP('hafsa') from dual; -- first letter upper case
select first_name, upper(last_name) from employees; -- upper case
select length('hafsa') from dual; --returns length
select first_name, length(first_name) from employees; -- returns length
select ltrim(' hafsa rashid ') from dual; --trims spaces front and back
select substr('hafsa rashid',7,6) from dual; -- 7 is position counter , 6 is char length
select lpad('yay',5,'*') from dual; -- 5 is char length , * is appended onto left side
select rpad('yay',5,'*') from dual; -- 5 is char length , * is appended onto right side

-- date functions
select add_months('28-aug-2025', 2) from dual;
select months_between('28-aug-2025' , '14-jul-2025') from dual;
select next_day('14-jul-2025', 'wednesday') from dual;
select last_day('14-jul-2025') from dual;
select new_time('14-jul-2025', 'PST', 'EST') from dual;
 
 --Conversion functions
select to_char(sysdate, 'DD-MM-YY') from dual;
select to_char(sysdate, 'Day') from dual;
  
select first_name , hire_date from employees where to_char(hire_date, 'Day') = 'Wednesday';
 
