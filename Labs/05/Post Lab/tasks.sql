---------------------------------POST LAB-----------------
-- q11: 
select s.student_name, f.faculty_name, s.city
from students s, faculty f
where s.city = f.city;

-- q12: 
select e.faculty_name employee, m.faculty_name mentor
from faculty e left join faculty m on e.mentor_id = m.faculty_id;

-- q13: 
select faculty_name 
from faculty 
where dept_id is null;

-- q14: 
select d.dept_name, avg(f.salary) avg_salary
from department d join faculty f on d.dept_id = f.dept_id
group by d.dept_name
having avg(f.salary) > 50000;

-- q15: 
select faculty_name, salary, dept_id
from faculty f
where salary > (select avg(salary) from faculty where dept_id = f.dept_id);

-- q16: 
select d.dept_name
from department d join faculty f on d.dept_id = f.dept_id
group by d.dept_name
having min(salary) >= 30000;

-- q17: 
select s.student_name, c.course_name
from students s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id
where s.city = 'Lahore';

-- q18: 
select e.faculty_name employee, m.faculty_name mentor, d.dept_name dept, e.joining_date
from faculty e
left join faculty m on e.mentor_id = m.faculty_id
left join department d on e.dept_id = d.dept_id
where e.joining_date between date '2020-01-01' and date '2023-01-01';

-- q19: 
select s.student_name, c.course_name
from students s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id
join faculty f on s.f_id = f.faculty_id
where f.faculty_name = 'Mr. Ali';

-- q20:
select e.faculty_name employee, m.faculty_name mentor, e.dept_id
from faculty e 
join faculty m on e.mentor_id = m.faculty_id
where e.dept_id = m.dept_id;
