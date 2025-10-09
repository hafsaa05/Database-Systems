--------------------------------------------LAB 2--------------------------------------------
--Q1. Find the total salary of all employees.
select salary as total_salaries from employees;
select sum(salary) as total_salaries from employees;

--Q2. Find the average salary of employees.
select avg(salary) as avg_salaries from employees;

--Q3. Count the number of employees reporting to each manager.
select manager_id, count(employee_id) as num_of_emp from employees group by manager_id;

--Q4. Select * employees who has lowest salary.
select min(salary) as min_salaries from employees;

--Q5. Display the current system date in the format DD-MM-YYYY.
select to_char(sysdate, 'DD-MM-YYYY') from dual;

--Q6. Display the current system date with full day, month, and year (e.g.,MONDAY AUGUST 2025).
select to_char(sysdate, 'DAY MONTH YYYY') from dual;

--Q7. Find all employees hired on a Wednesday.
select first_name, hire_date from employees where to_char(hire_date, 'Day') = 'Wednesday';

--Q8. Calculate months between 01-JAN-2025 and 01-OCT-2024.
select MONTHS_BETWEEN('01-JAN-2025' , '01-OCT-2024' ) from dual;
--Q9. Find how many months each employee has worked in the company (usinghire_date).
select first_name, last_name, floor(months_between(sysdate, hire_date)) as months_worked from employees;

--Q10.Extract the first 5 characters from each employee’s last name.
select substr(last_name, 1 , 5) from employees;

--Q11. Pad employee first names with * on the left side to make them 15 characters wide.
select lpad(first_name, 15, '*') from employees;

--Q12. Remove leading spaces from ' Oracle';.
select trim(' Oracle') from dual;

--Q13. Display each employee’s name with the first letter capitalized.
select initcap(first_name), initcap(last_name) from EMPLOYEES;

--Q14. Find the next Monday after 20-AUG-2022.
select next_day('20-AUG-2022', 'Monday') from dual;

--Q15. Convert '25-DEC-2023' (string) to a date and display it in MM-YYYY format.
select to_char(to_date('25-DEC-2023', 'DD_MM_YYYY')) from dual;

--Q16. Display all distinct salaries in ascending order.
select distinct salary from employees order by salary desc;

--Q17. Display the salary of each employee rounded to the nearest hundred.
select round(salary) from employees ;

--Q18. Find the department that has the maximum number of employees.
select department_id from employees group by department_id having count(*) = (select max(count(*)) from employees group by department_id);

--Q19. Find the top 3 highest-paid departments by total salary expense.
select department_id,total_salary from(select department_id, sum(salary) as total_salary from employees group by department_id order by sum(salary) DESC) where rownum <=3;

--Q20. Find the department that has the maximum number of employees.

--------------------------------------------LAB 3--------------------------------------------
--Q4. Create a table departments with columns 
--dept_id (PK), dept_name
--(UNIQUE). Insert 3 records.
create table departments (
    dept_id int constraint pk_dept primary key ,
    dept_name varchar(50)
    );
    
INSERT INTO departments(dept_id, dept_name) VALUES (5, 'Sales');
INSERT INTO departments(dept_id, dept_name) VALUES (123, 'Sales');
INSERT INTO departments(dept_id, dept_name) VALUES (13, 'Finance');
select * from departments; 


--Q1. create a table named employees with the following columns, emp_id ,
--emp_name , salary(should be greater than 20000) , dept_id(reference) from
--departments table.
create table employees (
    emp_id int constraint pk_emp primary key,
    emp_name varchar(50),
    salary int constraint chk_salary check (salary > 20000),
    dept_id int constraint fk_dept references departments(dept_id),
    );
    
select * from employees; 

--Q2. Change column name from emp_name to full_name.
alter table employees rename column emp_name to full_name;

--Q3. Drop the check constraint on salary and try inserting an employee
--with salary = 5000.
alter table employees drop constraint chk_salary;

insert into employees(emp_id,full_name,salary,dept_id) values (2,'hafsa',5000,5);
insert into employees values (5, 'Lucy', 5000, 123);

--Q5. Add a foreign key from employees.dept_id to departments.dept_id.
/*if fk not created while creating table then,
ALTER TABLE employees
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id)
REFERENCES departments(dept_id);
*/

--Q6. Add a new column bonus NUMBER(6,2) in employees with a default value of 1000.
alter table employees add bonus number(6,2) default 1000;
--Q7. Forgot to add city have default value Karachi and age column(should be greater
--than 18).
alter table employees add (
city varchar(30) default 'karachi' ,
age int constraint chk_age check (age>18)
);
select * from employees;

--Q8. Delete records have id 1 and id 3.
delete from employees where emp_id in (1,3);;

--Q9. Change the length of full_name and city column length must be 20 characters.
alter table employees modify(
    full_name varchar(20),
    city varchar(20)
    );

--10.Add email column and set unique constraint.
alter table employees add(
    email varchar(20) constraint uq_email unique
    );
--Q11. A company policy says no employee can have the same bonus amount. Add a
--UNIQUE constraint on bonus and test it with two records.
/*a unique constraint can only be added if all existing rows have 
different bonus values (or nulls). Therefore, changes the duplicate bonus value of table*/
update employees set bonus = 1500 where emp_id = 5;
alter table employees add constraint uq_bonus unique(bonus);
    
--Q12. Add a dob DATE column in staff and add a constraint that ensures employees
--must be at least 18 years old.
alter table employees add(
    dob date ,
    constraint chk_ check (age >= 18)
    );
select * from employees;

--Q13. Insert an employee with invalid date of birth (less than 18 years old) and check the
--error
insert into employees(emp_id, full_name, salary, dept_id, bonus, city, age, email, dob) values (6, 'amna', 3000, 8, 1200, 'lahore', 15, 'amna@gmail.com', date '2010-21-08');

--Q14. Drop the dept_id foreign key and insert an employee with a non-existing
--department. Then re-add the constraint and check again.

alter table employees drop constraint fk_dept;
insert into employees (emp_id, full_name, salary, dept_id, bonus, city, age, email, dob)
values (6, 'Ahad', 4000, 8, 1700, 'Lahore', 12, 'ahad@gmail.com', date '2013-05-25');

/*i need to remove references before removing fk_dept , so do the following if the only removal of fk_dept constrainr doesnt worl
select constraint_name, constraint_type, r_constraint_name
from user_constraints
where table_name = 'EMPLOYEES';
alter table employees drop constraint SYS_C007252;
*/
alter table employees add constraint fk_dept foreign key (dept_id) references departments(dept_id);

--Q15. Drop age and city columns.
alter table employees drop column age;
alter table employees drop column city;

--Q16. Display departments and employees of that departments.
SELECT d.dept_name, e.full_name
FROM departments d, employees e
WHERE d.dept_id = e.dept_id;

--Q17. Rename the column salary to monthly_salary and ensure constraints remain intact
alter table employees rename column salary to mothly_salary;

--Q18. Write a query to display all departments that have no employees.
select dept_id, dept_name from departments where dept_id not in (
    select dept_id from employees 
    where dept_id is not null
);

--Q19.Write a query to empty the table of students .
-- step 1: create the students table
create table students (
    student_id int primary key,
    student_name varchar2(50),
    age int,
    grade varchar2(5)
);
insert into students (student_id, student_name, age, grade)
values (1, 'Hafsa', 21, 'A');
select * from students;
-- step 2: empty the table (remove all rows)
truncate table students;


--Q20. Find the department that has the maximum number of employees.
select dept_id, count(*) as emp_count 
from employees group by dept_id 
having count(*) = (
    select max(count(*)) from employees group by dept_id
);    

--------------------------------------------LAB 4--------------------------------------------

CREATE TABLE stdepartments (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL
);

-- Insert Departments
INSERT INTO stdepartments (dept_id, dept_name) VALUES (1, 'Computer Sci');
INSERT INTO stdepartments (dept_id, dept_name) VALUES (2, 'Mathematics');
INSERT INTO stdepartments (dept_id, dept_name) VALUES (3, 'Physics');
INSERT INTO stdepartments (dept_id, dept_name) VALUES (4, 'Chemistry');

-- =========================
-- 2️⃣ Create Students Table
-- =========================
CREATE TABLE studs (
    student_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(50) NOT NULL,
    dept_id NUMBER,
    gpa NUMBER(3,2),
    fee NUMBER(6,2),
    CONSTRAINT fk_student_dept FOREIGN KEY (dept_id) REFERENCES stdepartments(dept_id)
);

-- Insert Students
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (1, 'Ali', 1, 3.6, 5000);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (2, 'Hafsa', 1, 3.9, 5500);
INSERT INTO students (student_id, full_name, dept_id, gpa, fee) VALUES (3, 'Sara', 2, 2.8, 4000);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (4, 'Omar', 3, 3.2, 4500);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (5, 'Amna', 1, 3.1, 5000);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (6, 'Zain', 2, 3.4, 4200);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (7, 'Aisha', 4, 2.9, 4800);
INSERT INTO students (student_id, full_name, dept_id, gpa, fee) VALUES (8, 'Bilal', 3, 3.7, 4600);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (9, 'Sana', 1, 3.8, 5300);
INSERT INTO studs (student_id, full_name, dept_id, gpa, fee) VALUES (10, 'Aliya', 4, 3.0, 4700);
-- =========================
-- 3️⃣ Create Courses Table
-- =========================
CREATE TABLE courses (
    course_id NUMBER PRIMARY KEY,
    course_name VARCHAR2(50) NOT NULL,
    dept_id NUMBER,
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id) REFERENCES stdepartments(dept_id)
);

-- Insert Courses
INSERT INTO courses (course_id, course_name, dept_id) VALUES (101, 'Programming', 1);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (102, 'Data Structures', 1);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (201, 'Calculus', 2);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (202, 'Algebra', 2);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (301, 'Mechanics', 3);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (302, 'Optics', 3);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (401, 'Organic Chem', 4);
INSERT INTO courses (course_id, course_name, dept_id) VALUES (402, 'Inorganic Chem', 4);

-- =========================
-- 4️⃣ Create Enrollments Table
-- =========================
CREATE TABLE enrollments (
    student_id NUMBER,
    course_id NUMBER,
    CONSTRAINT pk_enrollment PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES studs(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert Enrollments
INSERT INTO enrollments VALUES (1, 101);
INSERT INTO enrollments VALUES (1, 102);
INSERT INTO enrollments VALUES (2, 101);
INSERT INTO enrollments VALUES (2, 102);
INSERT INTO enrollments VALUES (3, 201);
INSERT INTO enrollments VALUES (3, 202);
INSERT INTO enrollments VALUES (4, 301);
INSERT INTO enrollments VALUES (4, 302);
INSERT INTO enrollments VALUES (5, 101);
INSERT INTO enrollments VALUES (6, 201);
INSERT INTO enrollments VALUES (6, 202);
INSERT INTO enrollments VALUES (7, 401);
INSERT INTO enrollments VALUES (8, 301);
INSERT INTO enrollments VALUES (8, 302);
INSERT INTO enrollments VALUES (9, 101);
INSERT INTO enrollments VALUES (9, 102);
INSERT INTO enrollments VALUES (10, 401);
INSERT INTO enrollments VALUES (10, 402);

CREATE TABLE faculty (
    faculty_id NUMBER PRIMARY KEY,
    faculty_name VARCHAR2(50) NOT NULL,
    dept_id NUMBER,
    salary NUMBER(8,2),
    CONSTRAINT fk_faculty_dept FOREIGN KEY (dept_id) REFERENCES stdepartments(dept_id)
);

-- Insert Faculty
INSERT INTO faculty VALUES (1, 'Dr. Khan', 1, 8000);
INSERT INTO faculty VALUES (2, 'Dr. Ahmed', 1, 9000);
INSERT INTO faculty VALUES (3, 'Dr. Ali', 2, 7000);
INSERT INTO faculty VALUES (4, 'Dr. Farah', 3, 8500);
INSERT INTO faculty VALUES (5, 'Dr. Sana', 4, 7500);

--Q1. List each department and the number of students in it.

select * from stdepartments;
select * from studs;
select d.dept_name , (select count(*) from studs s where s.dept_id = d.dept_id group by s.dept_id) as num_students from stdepartments d; 

--Q2. Find departments where the average GPA of students is greater than 3.0.
SELECT dept_name
FROM stdepartments d
WHERE 3.0 < (
    SELECT AVG(s.gpa)
    FROM studs s
    WHERE s.dept_id = d.dept_id
);
 
--Q3. Display the average fee paid by students grouped by course.
SELECT c.course_name,
       (SELECT AVG(fee)
        FROM studs s, enrollments e
        WHERE s.student_id = e.student_id
          AND e.course_id = c.course_id) AS avg_fee
FROM courses c;

select * from courses;
select * from studs;
select * from faculty;
select * from stdepartments;

--Q4.Count how many faculty members are assigned to each department.
select d.dept_name  , (select count(*) from faculty f where f.dept_id = d.dept_id) as num_faculty from stdepartments d;

--Q5.Find faculty members whose salary is higher than the average salary.
select faculty_name, salary from faculty where salary > (SELECT AVG(salary) FROM faculty);

--Q6. Show students whose GPA is higher than at least one student in the CS
--department.
select full_name, gpa from studs s where gpa > (
    select min(gpa) from studs where dept_id = (
        SELECT dept_id FROM stdepartments WHERE dept_name = 'Computer Sci')
     );
     
--Q7. Display the top 3 students with the highest GPA.
SELECT full_name, gpa
FROM (
    SELECT full_name, gpa
    FROM studs
    ORDER BY gpa DESC
)
WHERE ROWNUM <= 3;

--Q8. Find students enrolled in all the courses that student Ali is enrolled in.
SELECT s.full_name
FROM studs s
WHERE (SELECT COUNT(*)
       FROM enrollments e1
       WHERE e1.student_id = (SELECT student_id FROM studs WHERE full_name = 'Ali')
         AND e1.course_id NOT IN (
             SELECT course_id
             FROM enrollments e2
             WHERE e2.student_id = s.student_id
         )
      ) = 0;


--Q9. Show the total fees collected per department.
SELECT dept_name,
       (SELECT SUM(fee)
        FROM studs s
        WHERE s.dept_id = d.dept_id) AS total_fees
FROM stdepartments d;

--Q10. Display courses taken by students who have GPA above 3.5.
SELECT course_name
FROM courses c
WHERE course_id IN (
    SELECT course_id
    FROM enrollments e
    WHERE student_id IN (
        SELECT student_id
        FROM studs
        WHERE gpa > 3.5
    )
);
--Q11. Show departments where the total fees collected exceed 1 million.
SELECT dept_name
FROM stdepartments d
WHERE (SELECT SUM(fee)
       FROM studs s
       WHERE s.dept_id = d.dept_id) > 1000000;

--Q12. Display faculty departments where more than 5 faculty members earn above
--100,000 salary.
SELECT dept_name
FROM stdepartments d
WHERE (SELECT COUNT(*)
       FROM faculty f
       WHERE f.dept_id = d.dept_id
         AND f.salary > 100000) > 5;

--Q13. Delete all students whose GPA is below the overall average GPA.
/*First, remove all enrollments of the students you want to delete.

Then delete the students themselves.*/
DELETE FROM enrollments
WHERE student_id IN (
    SELECT student_id
    FROM studs
    WHERE gpa < (SELECT AVG(gpa) FROM studs)
);

DELETE FROM studs
WHERE gpa < (SELECT AVG(gpa) FROM studs);

--Q14. Delete courses that have no students enrolled.
DELETE FROM courses
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

--Q15. Copy all students who paid more than the average fee 
--into a new table HighFee_Students.
CREATE TABLE HighFee_Students AS
SELECT *
FROM studs
WHERE fee > (SELECT AVG(fee) FROM studs);
/*
Constraints are not copied (like primary key, foreign key, or check constraints). Only columns and data types are copied.

You can later add constraints if needed:

ALTER TABLE HighFee_Students ADD CONSTRAINT pk_highfee PRIMARY KEY (student_id);


Very useful for creating subset tables for analysis.
*/


--Q16. Insert faculty into Retired_Faculty if their joining date is earlier than the minimum
--joining date in the university.
ALTER TABLE faculty
ADD joining_date DATE;

create table Retired_Faculty as
SELECT *
FROM faculty
WHERE joining_date < (SELECT MIN(joining_date) FROM faculty);
select * from faculty;

--Q17. Find the department having the maximum total fee collected.
SELECT dept_name
FROM stdepartments d
WHERE (SELECT SUM(fee)
       FROM studs s
       WHERE s.dept_id = d.dept_id) = 
      (SELECT MAX(total_fee) 
       FROM (SELECT SUM(fee) AS total_fee
             FROM studs
             GROUP BY dept_id));
select * from enrollments;
--Q18. Show the top 3 courses with the highest enrollments using ROWNUM or LIMIT.
SELECT course_name, total_enroll
FROM (
    SELECT c.course_name, COUNT(e.student_id) AS total_enroll
    FROM courses c, enrollments e
    WHERE c.course_id = e.course_id
    GROUP BY c.course_name
    ORDER BY COUNT(e.student_id) DESC
) ranked_courses
WHERE ROWNUM <= 3;

--Q19 Display students who have enrolled in more than 3 courses and have GPA greater
--than the overall average .
SELECT full_name
FROM studs s
WHERE (SELECT COUNT(*)
       FROM enrollments e
       WHERE e.student_id = s.student_id) > 3
  AND gpa > (SELECT AVG(gpa) FROM studs);

--Q20. Find faculty who do not teach any course and insert them into Unassigned_Faculty.
-- Step 1: Insert faculty members
-- Faculty 1, 2, 3 already exist or you can insert them first
INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (1, 'Ali', 100000, 1, TO_DATE('01-JAN-2010','DD-MON-YYYY'));

INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (2, 'Nina', 95000, 2, TO_DATE('10-FEB-2012','DD-MON-YYYY'));

INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (3, 'John', 90000, 3, TO_DATE('05-MAR-2011','DD-MON-YYYY'));

-- Faculty who teach no course
INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (4, 'Ahmed', 90000, 1, TO_DATE('15-JAN-2015','DD-MON-YYYY'));

INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (5, 'Sara', 85000, 2, TO_DATE('01-FEB-2016','DD-MON-YYYY'));

INSERT INTO faculty (faculty_id, faculty_name, salary, dept_id, joining_date) 
VALUES (6, 'Hafsa', 95000, 3, TO_DATE('10-MAR-2014','DD-MON-YYYY'));

-- Step 2: Create faculty_courses table
CREATE TABLE faculty_courses (
    faculty_id NUMBER,
    course_id NUMBER,
    CONSTRAINT fk_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Step 3: Assign courses to faculty
INSERT INTO faculty_courses (faculty_id, course_id) VALUES (1, 101);
INSERT INTO faculty_courses (faculty_id, course_id) VALUES (2, 102);
INSERT INTO faculty_courses (faculty_id, course_id) VALUES (3, 101);
INSERT INTO faculty_courses (faculty_id, course_id) VALUES (3, 103);

-- Step 4: Create Unassigned_Faculty table
CREATE TABLE Unassigned_Faculty AS
SELECT *
FROM faculty f
WHERE f.faculty_id NOT IN (SELECT DISTINCT faculty_id FROM faculty_courses);

-- Step 5: Optional - check contents
SELECT * FROM Unassigned_Faculty;


--Q8. Delete records have id 1 and id 3.
delete from employees where emp_id in (1,3);;

--Q9. Change the length of full_name and city column length must be 20 characters.
alter table employees modify(
    full_name varchar(20),
    city varchar(20)
    );

--10.Add email column and set unique constraint.
alter table employees add(
    email varchar(20) constraint uq_email unique
    );
--Q11. A company policy says no employee can have the same bonus amount. Add a
--UNIQUE constraint on bonus and test it with two records.
/*a unique constraint can only be added if all existing rows have 
different bonus values (or nulls). Therefore, changes the duplicate bonus value of table*/
update employees set bonus = 1500 where emp_id = 5;
alter table employees add constraint uq_bonus unique(bonus);
    
--Q12. Add a dob DATE column in staff and add a constraint that ensures employees
--must be at least 18 years old.
alter table employees add(
    dob date ,
    constraint chk_ check (age >= 18)
    );
select * from employees;

--Q13. Insert an employee with invalid date of birth (less than 18 years old) and check the
--error
insert into employees(emp_id, full_name, salary, dept_id, bonus, city, age, email, dob) values (6, 'amna', 3000, 8, 1200, 'lahore', 15, 'amna@gmail.com', date '2010-21-08');

--Q14. Drop the dept_id foreign key and insert an employee with a non-existing
--department. Then re-add the constraint and check again.

alter table employees drop constraint fk_dept;
insert into employees (emp_id, full_name, salary, dept_id, bonus, city, age, email, dob)
values (6, 'Ahad', 4000, 8, 1700, 'Lahore', 12, 'ahad@gmail.com', date '2013-05-25');

/*i need to remove references before removing fk_dept , so do the following if the only removal of fk_dept constrainr doesnt worl
select constraint_name, constraint_type, r_constraint_name
from user_constraints
where table_name = 'EMPLOYEES';
alter table employees drop constraint SYS_C007252;
*/
alter table employees add constraint fk_dept foreign key (dept_id) references departments(dept_id);

--Q15. Drop age and city columns.
alter table employees drop column age;
alter table employees drop column city;

--Q16. Display departments and employees of that departments.
SELECT d.dept_name, e.full_name
FROM departments d, employees e
WHERE d.dept_id = e.dept_id;

--Q17. Rename the column salary to monthly_salary and ensure constraints remain intact
alter table employees rename column salary to mothly_salary;

--Q18. Write a query to display all departments that have no employees.
select dept_id, dept_name from departments where dept_id not in (
    select dept_id from employees 
    where dept_id is not null
);

--Q19.Write a query to empty the table of students .
-- step 1: create the students table
create table students (
    student_id int primary key,
    student_name varchar2(50),
    age int,
    grade varchar2(5)
);
insert into students (student_id, student_name, age, grade)
values (1, 'Hafsa', 21, 'A');
select * from students;
-- step 2: empty the table (remove all rows)
truncate table students;


--Q20. Find the department that has the maximum number of employees.
select dept_id, count(*) as emp_count 
from employees group by dept_id 
having count(*) = (
    select max(count(*)) from employees group by dept_id
);    
---------------------LAB 5---------------
--Q1. Write a query to display all possible pairs of employees and departments
SELECT e.emp_name, d.dept_name
FROM employees e
CROSS JOIN departments d;

--Q2. Show all departments and employees, even if no employees are assigned to a
--department
SELECT d.dept_name, e.emp_name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id;

--Q3. Display employee names along with their manager names.
SELECT e.emp_name AS employee,
       m.emp_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;

--Q4. Find employees who have not been assigned any project.
SELECT e.emp_name
FROM employees e
LEFT JOIN employee_projects ep
ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;

--Q5. Display student names with their enrolled course names using.
select s.student_name, c.course_name from stuents s join enrollments e 
on s.student_id = e.student.id join courses c on e.course_id = .course_id;

--Q6. Display all customers with their orders, even if some customers have not
--placed any order.
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

--Q8. Display all pairs of teachers and subjects (whether taught or not).
SELECT t.teacher_name, s.subject_name
FROM teachers t
CROSS JOIN subjects s
LEFT JOIN teacher_subjects ts
ON t.teacher_id = ts.teacher_id AND s.subject_id = ts.subject_id;
/*CROSS JOIN gives all possible teacher-subject combinations.

LEFT JOIN shows whether that teacher actually teaches the subject.
*/

--Q9. Show all departments along with total employees.
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
/*
COUNT(e.emp_id) counts employees per department.
*/

--Q10.Show each student, their course, and their teacher.
SELECT s.student_name, c.course_name, t.teacher_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id
JOIN teachers t
ON c.teacher_id = t.teacher_id;

---------------------------------POST LAB-----------------
-- q11: Q11. Show all students and teachers where student city = teacher city.
select s.student_name, f.faculty_name, s.city
from students s join faculty f
on s.city = f.city;

-- q12:List all employees and their manager names; also include employees without
--managers. 
select e.faculty_name employee, m.faculty_name mentor
from faculty e left join faculty m on e.mentor_id = m.faculty_id;

-- q13:13. Find employees who don’t belong to any department. 
select f.faculty_name 
from faculty f left join department d on f.dept_id = d.dept_id
where dept_id is null;

-- q14:Show average salary of employees in each department; 
--only display departments where average salary > 50,000. 
select d.dept_name, avg(f.salary) avg_salary
from department d join faculty f on d.dept_id = f.dept_id
group by d.dept_name
having avg(f.salary) > 50000;

-- q15:Show employees who earn more than the average salary in their department 
select faculty_name, salary, dept_id
from faculty f
where salary > (select avg(salary) from faculty where dept_id = f.dept_id);
--if using join:
select f.faculty_name, f.salary, f.dept_id
from faculty f
join (
    select dept_id, avg(salary) as avg_salary
    from faculty
    group by dept_id
) d_avg on f.dept_id = d_avg.dept_id
where f.salary > d_avg.avg_salary;

-- q16:Find departments where no employee earns less than 30,000. 
select d.dept_name
from department d join faculty f on d.dept_id = f.dept_id
group by d.dept_name
having min(salary) >= 30000;

-- q17:Display students and their courses where the student’s city = ‘Lahore’. 
select s.student_name, c.course_name
from students s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id
where s.city = 'Lahore';

-- q18:18. Display all employees along with their manager and department where employee hire
--date BETWEEN ‘2020-01-01’ AND ‘2023-01-01’. 
select e.faculty_name employee, m.faculty_name mentor, d.dept_name dept, e.joining_date
from faculty e
left join faculty m on e.mentor_id = m.faculty_id
left join department d on e.dept_id = d.dept_id
where e.joining_date between date '2020-01-01' and date '2023-01-01';

-- q19: List all students enrolled in courses taught by ‘Sir Ali’.
select s.student_name, c.course_name
from students s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id
join faculty f on s.f_id = f.faculty_id
where f.faculty_name = 'Mr. Ali';

-- q20:Find employees whose manager is from the same department
select e.faculty_name employee, m.faculty_name mentor, e.dept_id
from faculty e 
join faculty m on e.mentor_id = m.faculty_id
where e.dept_id = m.dept_id;
