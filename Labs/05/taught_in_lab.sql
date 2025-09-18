


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
 select s.*, f.faculty_name as faculty_name from Students s cross join Faculty f;
 
