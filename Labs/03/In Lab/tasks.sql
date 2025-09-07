create table departments (
    dept_id int constraint pk_dept primary key,
    dept_name varchar(30)
);
select * from departments;

create table employees (
    emp_id int constraint pk_emp primary key,
    full_name varchar(30),
    salary int constraint chk_salary check (salary > 20000),
    dept_id int,
    constraint fk_dept foreign key (dept_id) references departments(dept_id)
);
select * from employees;

alter table employees drop constraint chk_salary;

insert into departments values (123, 'Finance');

insert into employees (emp_id, full_name, salary, dept_id) values (5, 'Lucy', 5000, 123);

alter table departments add constraint unique_dept_name unique (dept_name);
insert into departments values (101, 'Marketing');
insert into departments valueas (102, 'Sales');
insert into departments values (103, 'IT');

alter table employees add foreign key (dept_id) references departments(dept_id);

alter table employees add bonus number(6,2) default 1000;

alter table employees add (
    city varchar2(30) default 'Karachi',
    age int constraint chk_age check (age > 18)
);

delete from employees where emp_id in (1,3);

alter table employees modify (full_name varchar2(20), city varchar2(20) );

alter table employees add (email varchar2(50) constraint uq_email unique);
