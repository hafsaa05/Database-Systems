select lpad(first_name, 15, '*') from employees;

select ltrim(' Oracle') from dual;

select INITCAP(first_name), INITCAP(last_name) from employees ;

select next_day('20-aug-2022', 'monday') from dual;

select to_char(to_date('25-Dec-2023', 'DD-MM-YY')) from dual;

select distinct salary from employees order by (salary) asc ;

select first_name, last_name, round(salary, -2) as rounded_salary from employees;

select department_id from employees group by department_id having count(*) = (select max(count(*)) from employees group by department_id);

select department_id, sum(salary) as total_salary_expense from employees group by department_id order by total_salary_expense desc;

select department_id from employees group by department_id having count(*) = ( select max(count(*)) from employees group by department_id)


