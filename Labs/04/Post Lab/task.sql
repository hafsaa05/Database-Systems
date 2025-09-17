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

CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES Course(course_id)
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

INSERT INTO Enrollment VALUES (1, 201);
INSERT INTO Enrollment VALUES (1, 202);
INSERT INTO Enrollment VALUES (2, 201);
INSERT INTO Enrollment VALUES (3, 203);
INSERT INTO Enrollment VALUES (4, 204);
INSERT INTO Enrollment VALUES (5, 203);
INSERT INTO Enrollment VALUES (6, 201);
INSERT INTO Enrollment VALUES (6, 202);
INSERT INTO Enrollment VALUES (6, 205);
select * FROM Enrollment;

select dept_id, sum(fee) as total_fee from Students group by dept_id having sum(fee) > 1000000;

select dept_id, count(*) as fac_count from Faculty where salary > 100000 group by dept_id having count(*) > 5;

delete from Enrollment e where exists ( select 1 from Students s where s.student_id = e.student_id and s.gpa < (select avg(gpa) from Students));
delete from Students s where s.gpa < (select avg(gpa) from Students);

delete from Course where course_id not in (select course_id from Enrollment);

create table HighFee_Students as select * from Students where fee > (select avg(fee) from Students);

create table Retired_Faculty as select * from Faculty where joining_date < (select min(joining_date) from Faculty); select * from Retired_Faculty;

select dept_id, sum(fee) as total_fee from Students group by dept_id having sum(fee) = ( select max(sum_fee) from (select sum(fee) as sum_fee from Students group by dept_id));

select * from ( select course_id, count(*) as total_enroll from Enrollment group by course_id order by count(*) desc) where ROWNUM <= 3;

select s.student_id, s.student_name from Students s where s.gpa > (select avg(gpa) from Students) and (select count(*) from Enrollment e where e.student_id = s.student_id) > 3;

create table Unassigned_Faculty as select * from Faculty f where f.dept_id not in (select dept_id from Course); select * from Unassigned_Faculty;
