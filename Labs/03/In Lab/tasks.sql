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

alter table employees rename column emp_name to full_name;

alter table employees drop constraint chk_salary;
insert into employees (emp_id, full_name, salary, dept_id) values (5, 'Lucy', 5000, 123);
insert into employees (emp_id, full_name, salary, dept_id) values (1, 'Hafsa', 6000, 101);
insert into employees (emp_id, full_name, salary, dept_id) values (3, 'Amna', 2800, 102);

insert into departments values (123, 'Finance');
insert into departments values (101, 'Marketing');
insert into departments values (102, 'IT');

alter table employees add constraint fk_dept foreign key (dept_id) references departments(dept_id);

alter table employees add bonus number(6,2) default 1000;

alter table employees 
add (
    city varchar(30) default 'Karachi',
    age int constraint chk_age check (age > 18)
);

delete from employees where emp_id in (1, 3);

alter table employees 
modify (
    full_name varchar(20),
    city varchar(20)
);

alter table employees add email varchar(50) constraint uq_email unique;
