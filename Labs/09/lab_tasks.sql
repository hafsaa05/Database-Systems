-- salary audit table
create table log_salary_audit (
    audit_id     number primary key,
    emp_id       number,
    old_salary   number,
    new_salary   number,
    changed_by   varchar2(30),
    changed_at   timestamp
);

create sequence log_salary_audit_seq start with 1 increment by 1;

create or replace trigger trg_log_salary_audit_seq
before insert on log_salary_audit
for each row
begin
    if :new.audit_id is null then
        select log_salary_audit_seq.nextval into :new.audit_id from dual;
    end if;
end;
/

-- sales audit table
create table sales_audit (
    audit_id     number primary key,
    total_before number,
    total_after  number,
    audited_at   timestamp
);

create sequence sales_audit_seq start with 1 increment by 1;

create or replace trigger trg_sales_audit_seq
before insert on sales_audit
for each row
begin
    if :new.audit_id is null then
        select sales_audit_seq.nextval into :new.audit_id from dual;
    end if;
end;
/

-- schema ddl log
create table schema_ddl_log (
    log_id       number primary key,
    username     varchar2(30),
    event_type   varchar2(30),
    object_type  varchar2(30),
    object_name  varchar2(128),
    ddl_text     clob,
    event_time   timestamp
);

create sequence schema_ddl_log_seq start with 1 increment by 1;

create or replace trigger trg_schema_ddl_log_seq
before insert on schema_ddl_log
for each row
begin
    if :new.log_id is null then
        select schema_ddl_log_seq.nextval into :new.log_id from dual;
    end if;
end;
/

-- login audit
create table login_audit (
    id          number primary key,
    username    varchar2(30),
    login_time  timestamp,
    machine     varchar2(64)
);

create sequence login_audit_seq start with 1 increment by 1;

create or replace trigger trg_login_audit_seq
before insert on login_audit
for each row
begin
    if :new.id is null then
        select login_audit_seq.nextval into :new.id from dual;
    end if;
end;
/

commit;

create or replace trigger trg_students_upper
before insert on students
for each row
begin
    if :new."NAME" is not null then
        :new."NAME" := upper(:new."NAME");
    end if;
end;

--2
create or replace trigger trg_emp_no_delete_weekend
before delete on employees
for each row
begin
    if to_char(sysdate, 'dy', 'nls_date_language=english') in ('sat', 'sun') then
        raise_application_error(-20001, 'cannot delete employees on weekends');
    end if;
end;
/

--3
alter table employees add salary number;
create or replace trigger trg_salary_audit
after update of salary on employees
for each row
begin
    if nvl(:old.salary,-1) <> nvl(:new.salary,-1) then
        insert into log_salary_audit(
            audit_id,
            emp_id,
            old_salary,
            new_salary,
            changed_by,
            changed_at
        ) values (
            log_salary_audit_seq.nextval,
            :old.emp_id,
            :old.salary,
            :new.salary,
            sys_context('userenv','session_user'),
            systimestamp
        );
    end if;
end;
/

-- 4. before update trigger - prevent negative price
-- first, create the products table
create table products (
    product_id number primary key,
    product_name varchar2(100),
    price number
);

-- now creating the trigger
create or replace trigger trg_products_no_negative_price
before update on products
for each row
begin
    if :new.price < 0 then
        raise_application_error(-20002, 'price cannot be negative');
    end if;
end;
/

-- 5. before insert trigger - audit courses insertion
create table courses (
    course_id number primary key,
    course_name varchar2(100),
    created_by varchar2(30),
    created_at timestamp
);

create table emp (
    emp_id number primary key,
    emp_name varchar2(100),
    department_id number
);

create table sales (
    sale_id number primary key,
    amount number,
    sale_date date default sysdate
);

create table order_table (
    order_id number primary key,
    order_status varchar2(20),
    order_date date default sysdate
);
create or replace trigger trg_courses_audit_insert
before insert on courses
for each row
begin
    :new.created_by := sys_context('userenv','session_user');
    :new.created_at := systimestamp;
end;
/

--6
create or replace trigger trg_emp_default_dept
before insert on emp
for each row
begin
    if :new.department_id is null then
        :new.department_id := 99;
    end if;
end;
/

-- 7. compound trigger for sales table
create or replace trigger trg_sales_bulk_audit
for insert on sales
compound trigger

    total_before number;
    total_after number;
    
    before statement is
    begin
        select nvl(sum(amount),0) into total_before from sales;
    end before statement;
    
    after statement is
    begin
        select nvl(sum(amount),0) into total_after from sales;
        
        insert into sales_audit(
            audit_id,
            total_before,
            total_after,
            audited_at
        ) values (
            sales_audit_seq.nextval,
            total_before,
            total_after,
            systimestamp
        );
    end after statement;
    
end trg_sales_bulk_audit;  -- REMOVED THE SLASH HERE
/

-- TASK 8: DDL trigger for schema audit
create or replace trigger trg_audit_ddl
after ddl on schema
declare
    v_sql_text ora_name_list_t;
    v_ddl_text clob;
    v_items pls_integer;
begin
    v_items := ora_sql_txt(v_sql_text);
    v_ddl_text := '';
    
    for i in 1..v_items loop
        v_ddl_text := v_ddl_text || v_sql_text(i);
    end loop;
    
    insert into schema_ddl_log(
        username,
        event_type,
        object_type,
        object_name,
        ddl_text,
        event_time
    ) values (
        ora_login_user,
        ora_sysevent,
        ora_dict_obj_type,
        ora_dict_obj_name,
        v_ddl_text,
        systimestamp
    );
end;
/

-- TASK 9: Check if order_table exists first
DECLARE
    v_table_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_table_exists 
    FROM user_tables 
    WHERE table_name = 'ORDER_TABLE';
    
    IF v_table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        create table order_table (
            order_id number primary key,
            order_status varchar2(20),
            order_date date default sysdate,
            customer_name varchar2(100)
        )';
    END IF;
END;
/

-- Now create the trigger for Task 9
create or replace trigger trg_order_no_update_shipped
before update on order_table
for each row
begin
    if :old.order_status = 'SHIPPED' then
        raise_application_error(-20003, 'Error: Cannot update shipped orders.');
    end if;
end;
/

-- TASK 10: Check if login_audit exists first
DECLARE
    v_table_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_table_exists 
    FROM user_tables 
    WHERE table_name = 'LOGIN_AUDIT';
    
    IF v_table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        create table login_audit (
            id          number primary key,
            username    varchar2(30),
            login_time  timestamp,
            machine     varchar2(64)
        )';
        
        EXECUTE IMMEDIATE '
        create sequence login_audit_seq start with 1 increment by 1';
    END IF;
END;
/

-- Create trigger to auto-increment id for login_audit
create or replace trigger trg_login_audit_seq
before insert on login_audit
for each row
begin
    if :new.id is null then
        select login_audit_seq.nextval into :new.id from dual;
    end if;
end;
/

-- Now create Task 10 Logon trigger
create or replace trigger trg_audit_logon
after logon on database
declare
    v_username varchar2(30);
    v_host varchar2(64);
begin
    v_username := sys_context('userenv', 'session_user');
    v_host := sys_context('userenv', 'host');
    
    insert into login_audit(
        username,
        login_time,
        machine
    ) values (
        v_username,
        systimestamp,
        v_host
    );
end;
/

commit;
