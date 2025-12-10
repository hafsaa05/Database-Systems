--task 1
--task 1
-- Create table and insert sample data
create table bank_accounts (
    account_no number primary key,
    holder_name varchar2(50),
    balance number
);

insert into bank_accounts values (101, 'John Smith', 50000);
insert into bank_accounts values (102, 'Jane Doe', 75000);
insert into bank_accounts values (103, 'Bob Wilson', 30000);
commit;

-- Start transaction
select * from bank_accounts; -- Original values

-- 1. Deduct 5000 from account A
update bank_accounts set balance = balance - 5000 where account_no = 101;

-- 2. Credit 5000 to account B
update bank_accounts set balance = balance + 5000 where account_no = 102;

-- 3. Before committing, update balance of account C by mistake
update bank_accounts set balance = balance - 10000 where account_no = 103;

-- Check changes before rollback
select 'Before ROLLBACK' as status, account_no, holder_name, balance 
from bank_accounts;

-- 4. Use ROLLBACK to undo all changes
rollback;

-- 5. Show that balances returned to original values
select 'After ROLLBACK' as status, account_no, holder_name, balance 
from bank_accounts;

--task 2
-- Create table and insert sample data
create table inventory (
    item_id number primary key,
    item_name varchar2(50),
    quantity number
);

insert into inventory values (1, 'Laptop', 100);
insert into inventory values (2, 'Mouse', 200);
insert into inventory values (3, 'Keyboard', 150);
insert into inventory values (4, 'Monitor', 80);
commit;

-- Start transaction
select * from inventory;

-- 1. Reduce quantity of item 1 by 10
update inventory set quantity = quantity - 10 where item_id = 1;

-- 2. Create SAVEPOINT sp1
savepoint sp1;

-- 3. Reduce quantity of item 2 by 20
update inventory set quantity = quantity - 20 where item_id = 2;

-- 4. Create SAVEPOINT sp2
savepoint sp2;

-- 5. Reduce quantity of item 3 by 5
update inventory set quantity = quantity - 5 where item_id = 3;

-- Check before rollback to sp1
select 'Before rollback to sp1' as status, item_id, item_name, quantity 
from inventory;

-- 6. Rollback to sp1
rollback to sp1;

-- Check after rollback to sp1
select 'After rollback to sp1' as status, item_id, item_name, quantity 
from inventory;

-- 7. Commit the remaining changes
commit;

-- Final state
select 'Final state' as status, item_id, item_name, quantity 
from inventory;

## Task 4
-- Create table and insert sample data
create table fees (
    student_id number primary key,
    name varchar2(50),
    amount_paid number,
    total_fee number
);

insert into fees values (1, 'Alice', 5000, 10000);
insert into fees values (2, 'Bob', 7000, 12000);
insert into fees values (3, 'Charlie', 3000, 8000);
commit;

-- Start transaction
select * from fees;

-- 1. Update amount_paid for Student 1
update fees set amount_paid = amount_paid + 2000 where student_id = 1;

-- 2. Savepoint halfway
savepoint halfway;

-- 3. Update amount_paid for Student 2 (but with wrong amount)
update fees set amount_paid = amount_paid - 3000 where student_id = 2; -- Error: negative amount

-- Check before rollback
select 'Before rollback' as status, student_id, name, amount_paid, total_fee 
from fees;

-- 4. Due to error → rollback to halfway
rollback to halfway;

-- 5. Commit the correct part
commit;

-- Final state
select 'Final state' as status, student_id, name, amount_paid, total_fee 
from fees;

-- task 4
create table products (
    product_id number primary key,
    product_name varchar2(50),
    stock number
);

create table orders (
    order_id number primary key,
    product_id number,
    quantity number,
    order_date date default sysdate,
    foreign key (product_id) references products(product_id)
);

insert into products values (1, 'Laptop', 50);
insert into products values (2, 'Mouse', 100);
insert into products values (3, 'Keyboard', 75);
commit;

-- Start first transaction (with mistake)
select 'Products before transaction' as status, product_id, product_name, stock 
from products;
select 'Orders before transaction' as status, order_id, product_id, quantity 
from orders;

-- 1. Reduce stock for product_id 1
update products set stock = stock - 5 where product_id = 1;

-- 2. Insert a row into orders
insert into orders (order_id, product_id, quantity) values (1001, 1, 5);

-- 3. Delete a product by mistake
delete from products where product_id = 2; -- Oops! Mistake

-- 4. Use ROLLBACK
rollback;

-- Verify rollback
select 'After ROLLBACK' as status, product_id, product_name, stock 
from products;
select 'Orders after ROLLBACK' as status from orders where 1=0; -- Should be empty

-- 5. Repeat the correct transaction
-- 1. Reduce stock for product_id 1
update products set stock = stock - 5 where product_id = 1;

-- 2. Insert a row into orders (correct order)
insert into orders (order_id, product_id, quantity) values (1001, 1, 5);

-- 6. Use COMMIT
commit;

-- Final state
select 'Products final state' as status, product_id, product_name, stock 
from products;
select 'Orders final state' as status, order_id, product_id, quantity, order_date 
from orders;

-- task 5
create table employees (
    emp_id number primary key,
    emp_name varchar2(50),
    salary number
);

insert into employees values (1, 'John', 50000);
insert into employees values (2, 'Sarah', 60000);
insert into employees values (3, 'Mike', 55000);
insert into employees values (4, 'Lisa', 65000);
insert into employees values (5, 'David', 70000);
commit;

-- Start transaction
select * from employees;

-- 1. Increase salary of emp 1
update employees set salary = salary + 5000 where emp_id = 1;

-- 2. SAVEPOINT A
savepoint A;

-- 3. Increase salary of emp 2
update employees set salary = salary + 3000 where emp_id = 2;

-- 4. SAVEPOINT B
savepoint B;

-- 5. Increase salary of emp 3
update employees set salary = salary + 4000 where emp_id = 3;

-- Check before rollback
select 'Before rollback to A' as status, emp_id, emp_name, salary 
from employees order by emp_id;

-- 6. Rollback to SAVEPOINT A
rollback to A;

-- Check after rollback
select 'After rollback to A' as status, emp_id, emp_name, salary 
from employees order by emp_id;

-- 7. Commit
commit;

-- Final state
select 'Final state' as status, emp_id, emp_name, salary 
from employees order by emp_id;

