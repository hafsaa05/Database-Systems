create table departments (
    dept_id int constraint pk_dept primary key,
    dept_name varchar(30)
);
select * from departments;

create table employees (
    emp_id int constraint pk_emp primary key,
    emp_name varchar(30),
    salary int constraint chk_salary check (salary > 20000),
    dept_id int
);
select * from employees;

----------------------------------POST LAB--------------------
alter table employees add constraint uq_bonus unique (bonus);
insert into employees (emp_id, full_name, salary, dept_id, bonus, age, city, email)
values (7, 'Amna', 26000, 102, 2000, 24, 'Lahore', 'amna@example.com');
insert into employees (emp_id, full_name, salary, dept_id, bonus, age, city, email)
values (6, 'Hafsa', 26000, 101, 1500, 22, 'Karachi', 'hafsa@example.com');

alter table employees add dob date constraint chk_staff_age check (dob <= date '2007-09-07');

insert into employees (emp_id, full_name, salary, dept_id, bonus, age, city, email, dob)
values (8, 'Zayn', 35000, 101, 1800, 16, 'Islamabad', 'zayn@example.com', date '2015-05-15');

alter table employees drop constraint fk_dept;

insert into employees (emp_id, full_name, salary, dept_id, bonus, age, city, email, dob)
values (9, 'Ahmed', 28000, 999, 2500, 23, 'Karachi', 'ahmed@example.com', date '2000-08-10');
alter table employees add constraint fk_dept foreign key (dept_id) references departments(dept_id);

alter table employees drop column age;
alter table employees drop column city;

select dept_id, full_name from employees where dept_id in (select dept_id from departments);

alter table employees rename column salary to monthly_salary;

select dept_id, dept_name from departments where dept_id not in (
    select dept_id from employees
    where dept_id is not null
);

truncate table students;

select dept_id, count(*) as emp_count
from employees
group by dept_id
having count(*) = (
    select max(count(*))
    from employees
    group by dept_id
);



