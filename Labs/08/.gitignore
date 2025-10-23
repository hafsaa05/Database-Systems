SET SERVEROUTPUT ON;

DECLARE
    sec_name VARCHAR2(20) := 'SEC-5A';
    course_name VARCHAR2(30) := 'Database Systems Lab';
BEGIN
    DBMS_OUTPUT.put_line('WELCOME ' || sec_name || ' TO THE ' || course_name);
END;
/
-- ↑ This slash executes the first block

DECLARE
    a INT := 10;
    b INT := 20;
    c INT;
    f REAL;
BEGIN
    c := a + b;
    DBMS_OUTPUT.put_line('Value of c is ' || c);
    f := 70.0 / 3.0;
    DBMS_OUTPUT.put_line('Value of f is ' || f);
END;
/
-- ↑ Slash again for the second block

DECLARE
--global variables
    num1 number := 21;
    num2 number := 22;
BEGIN
    DBMS_OUTPUT.put_line('Outer Variable num1 ' || num1);
    DBMS_OUTPUT.put_line('Outer Variable num2 ' || num2);
END;
/

DECLARE
--local variables
    n1 int := 21;
    n2 int := 22;
BEGIN
    DBMS_OUTPUT.put_line('local Variables n1 and n2 are ' || n1 || ' and ' || n2);
END;
/

DECLARE
e_name varchar(20);
BEGIN
    select first_name into e_name from employees where employee_id = 101;
    DBMS_OUTPUT.put_line('Employee name is ' || e_name);
EXCEPTION
WHEN
NO_DATA_FOUND THEN
DBMS_OUTPUT.put_line('no employee found');
END;
/

DECLARE
BEGIN
    update employees set salary = salary*0.1 where
    department_id = (SELECT department_id FROM departments WHERE department_name = 'Administration');
    DBMS_OUTPUT.put_line('salary update successfully');
END;
/

declare
e_id employees.employee_id%type;
e_name employees.first_name%type;-- assigns the type of var from the table(col mentioned)
d_name departments.department_name%type;
begin
select employee_id,first_name,department_name into e_id,e_name,d_name from employees inner join DEPARTMENTS on employees.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID where employee_id=100;
DBMS_OUTPUT.PUT_LINE('emp id: '|| e_id);
DBMS_OUTPUT.PUT_LINE('emp name: '|| e_name);
DBMS_OUTPUT.PUT_LINE('dep name: '|| d_name);
end;
/

DECLARE
    e_id   employees.employee_id%TYPE := 100;       -- pick which employee to update
    e_sal  employees.salary%TYPE;                   -- variable to store salary
    e_did  employees.department_id%TYPE;            -- store department_id (not department_name!)
BEGIN
    -- Get current salary and department of that employee
    SELECT salary, department_id 
    INTO e_sal, e_did
    FROM employees 
    WHERE employee_id = e_id;

    -- Use CASE to decide how much to increase
    CASE e_did
        WHEN 90 THEN
            UPDATE employees 
            SET salary = e_sal + 100 
            WHERE employee_id = e_id;
            DBMS_OUTPUT.PUT_LINE('Salary updated: ' || (e_sal + 100));

        WHEN 50 THEN
            UPDATE employees 
            SET salary = e_sal + 200 
            WHERE employee_id = e_id;
            DBMS_OUTPUT.PUT_LINE('Salary updated: ' || (e_sal + 200));

        WHEN 40 THEN
            UPDATE employees 
            SET salary = e_sal + 300 
            WHERE employee_id = e_id;
            DBMS_OUTPUT.PUT_LINE('Salary updated: ' || (e_sal + 300));

        ELSE
            DBMS_OUTPUT.PUT_LINE('No matching department for update.');
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || e_id);
END;
/
