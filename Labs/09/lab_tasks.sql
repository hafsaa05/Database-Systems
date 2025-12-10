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
