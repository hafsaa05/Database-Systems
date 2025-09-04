create table Students(
id int primary key,
std_name varchar(30),
email varchar(30),
age int ,
check ( age >= 18 )

);


select * from Students;
alter table Students add salary int ;
alter table Students add (city varchar(20) default 'Karachi' , dept_id int ); -- coloumn level constraint
alter table Students add constraint unique_email unique(email); -- sdd single constraint
alter table Students modify(std_name varchar(20) not null, email varchar(20) not null); -- modify multiple  constraint

-- another method/structure for adding multiple constraints  
*alter table Students add ( constraint
check_age check ( age between 18 and 30 ),
constraint unique_email unique(email)
);
CREATE TABLE Departments (
    id INT PRIMARY KEY,
    dept_name VARCHAR(30) NOT NULL
);

INSERT INTO Departments(id, dept_name) VALUES (4, 'AI');
SELECT * FROM Departments;

SELECT * FROM Students;
alter table Students drop column dept_id;

Students add (dept_id int, foreign key(dept_id) references departments(id));
insert into Students (id, std_name, email, age, salary, city ) values( 3, 'sana khan' , 'sana@gmail.com', 21 , 2300 , 'Karachi');
alter table Students rename column email to std_email;

delete from Students where id in (1,2,3,4);
insert into Students (id, std_name, std_email, age, salary, city ) values( 5, 'amna khan' , 'amnakhan@gmail.com', 22 , 8000 , 'Islamabad');
insert into Students (id, std_name, std_email, age, salary, city ) values( 4, 'hafsa rashid' , 'hafsa@gmail.com', 20 , 100000 , 'Rawalpindi');


