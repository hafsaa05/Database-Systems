

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

-- Add f_id column to Students table and add foreign key constraint
ALTER TABLE Students 
ADD (f_id INT, 
     CONSTRAINT fk_students_faculty FOREIGN KEY (f_id) REFERENCES Faculty(faculty_id));

-- Update Students table to set f_id = 1 for student_id = 2
UPDATE Students 
SET f_id = 1 
WHERE student_id IN (2);

ALTER TABLE Faculty
ADD city VARCHAR(50);
ALTER TABLE Students
ADD city VARCHAR(50);
UPDATE Students
SET city = 'karachi'
WHERE student_name IN ('Ali', 'Aisha', 'Farhan');
select * from Students;
SELECT s.student_id AS id, 
       s.student_name AS std_name, 
       f.faculty_name AS faculty_name
FROM Students s
INNER JOIN Faculty f ON s.f_id = f.faculty_id
WHERE s.city = 'karachi';  -- assuming 'city' is a column in Students table

select s.student_id, s.student_name,  f.faculty_name AS faculty_name
FROM Students s 
right outer join
Faculty F 
on s.f_id = f.faculty_id;
alter table Faculty add mentor_id int;
update Faculty set mentor_id = 1 where faculty_id in (2,3);

select s.f.faculty_id , f.faculty_name,  m.faculty_name as mentor_name
FROM Faculty f 
inner join
Faculty m 
on f.mentor_id = m.faculty_id;

 --cross join returns all possible outcomes (multiplys table)
 --Q1
 select s.*, f.faculty_name as faculty_name from Students s cross join Faculty f;
 
 --Q2
 select 
