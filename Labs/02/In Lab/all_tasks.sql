select sum(salary) as total_salary from employees;

select avg(salary) as average_salary from employees;

select manager_id, count(*) as employee_count from employees group by manager_id;

select min(salary) as minimum_salary from employees;

select to_char(sysdate, 'DD-MM-YY') as current_date from dual;

select to_char(sysdate, 'day month yyyy') as full_date from dual;

select first_name , hire_date from employees where to_char(hire_date, 'Day') = 'Wednesday';

select months_between('01-Jan-2025' , '01-Oct-2024') from dual;

select first_name, last_name, floor(months_between(sysdate, hire_date)) as months_worked from employees;

select substr(last_name, 1, 5) as first_five_chars from employees;


