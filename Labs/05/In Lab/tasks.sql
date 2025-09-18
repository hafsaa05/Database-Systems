

create table orders (
    order_id int primary key,
    order_date date,
    amount int,
    customer_id int,
    constraint fk_cust foreign key (customer_id) references customer(customer_id)
);
-- customers
insert into customer values (1, 'ali', 'karachi');
insert into customer values (2, 'sara', 'lahore');
insert into customer values (3, 'hamza', 'islamabad');
insert into customer values (4, 'fatima', 'quetta');
select * from customer;

-- orders
insert into orders values (101, date '2025-09-01', 5000, 1);
insert into orders values (102, date '2025-09-05', 3000, 2);
insert into orders values (103, date '2025-09-10', 7000, 1);
select * from orders;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30)
);

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(30),
    salary INT,
    joining_date DATE,
    dept_id INT,
    CONSTRAINT fk_fac_dept FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(30),
    gpa DECIMAL(3,2),
    fee INT,
    dept_id INT,
    CONSTRAINT fk_std_dept FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(30),
    dept_id INT,
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Department VALUES (1, 'CS');
INSERT INTO Department VALUES (2, 'IT');
INSERT INTO Department VALUES (3, 'SE');
select * FROM DEPARTMENT;

INSERT INTO Faculty VALUES (101, 'Dr. Ahmed', 120000, DATE '2005-01-10', 1);
INSERT INTO Faculty VALUES (102, 'Ms. Anam', 95000, DATE '2010-03-15', 2);
INSERT INTO Faculty VALUES (103, 'Mr. Ali', 150000, DATE '2000-07-21', 1);
INSERT INTO Faculty VALUES (104, 'Dr. Sara', 110000, DATE '2008-09-12', 3);
INSERT INTO Faculty VALUES (105, 'Mr. Bilal', 80000, DATE '2012-02-05', 2);
INSERT INTO Faculty (faculty_id, faculty_name, salary, joining_date, dept_id) VALUES (1, 'Default Faculty', 50000, DATE '2020-01-01', 1);

select * FROM Faculty;

INSERT INTO Students VALUES (1, 'Ali', 3.6, 400000, 1);
INSERT INTO Students VALUES (2, 'Aisha', 2.9, 200000, 1);
INSERT INTO Students VALUES (3, 'Usman', 3.2, 350000, 2);
INSERT INTO Students VALUES (4, 'Hina', 3.8, 500000, 3);
INSERT INTO Students VALUES (5, 'Sara', 2.5, 150000, 2);
INSERT INTO Students VALUES (6, 'Farhan', 3.9, 600000, 1);
select * FROM Students;


INSERT INTO Course VALUES (201, 'DBMS', 1);
INSERT INTO Course VALUES (202, 'AI', 1);
INSERT INTO Course VALUES (203, 'Networking', 2);
INSERT INTO Course VALUES (204, 'Software Engg', 3);
INSERT INTO Course VALUES (205, 'Operating Systems', 1);
select * FROM Course;


-- q1
select f.faculty_name, d.dept_name from faculty f cross join department d;

-- q2
select d.dept_name, f.faculty_name from department d left join Faculty f on d.dept_id = f.dept_id;

-- q3
select f.faculty_name as employee, m.faculty_name as manager from Faculty f left join faculty m on f.mentor_id = m.faculty_id;

-- q4
create table project (
    project_id int primary key,
    project_name varchar(50),
    faculty_id int,
    constraint fk_proj_fac foreign key (faculty_id) references faculty(faculty_id)
);
insert into project values (301, 'library management system', 101);
insert into project values (302, 'ai chatbot', 103);
insert into project values (303, 'network security audit', 102);
insert into project values (304, 'student portal', 104);
select * from project;


select f.faculty_name, p.project_name from faculty f inner join project p on f.faculty_id = p.faculty_id;

-- q5
select s.student_name, c.course_name
from students s
inner join course c on s.dept_id = c.dept_id;

-- q6
create table customer (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(30)
);

select c.customer_name, c.customer_id, o.order_id from customer c left join orders o on c.customer_id = o.customer_id;

-- q7
select d.dept_name, f.faculty_name from department d left join Faculty f on d.dept_id = f.dept_id;

-- q8
select f.faculty_name, c.course_name from faculty f cross join course c;

-- q9
select d.dept_name, count(f.faculty_id) as total_employees from department d left join faculty f on d.dept_id = f.dept_id group by d.dept_name;

-- q10
select s.student_name, c.course_name, f.faculty_name from students s inner join enrollment e on s.student_id=e.student_id inner join course c on e.course_id=c.course_id inner join faculty f on s.f_id=f.faculty_id;

