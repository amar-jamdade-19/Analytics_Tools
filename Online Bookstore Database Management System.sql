-- create database
create database onlinebookstore;

-- create table
drop table if exists books;
create table books(
Book_ID	serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);


drop table if exists customers;
create table customers(
Customer_ID	serial primary key,
Name varchar(100),
Email varchar(100),
Phone int,
City varchar(100),
Country	varchar(100)
);

drop table if exists orders;
create table orders(
Order_ID serial primary key,
Customer_ID	int references customers(Customer_ID),
Book_ID	int references books(Book_ID),
Order_Date date,
Quantity int,
Total_Amount int
);

select*from books;
select*from customers;
select*from orders;

-- import data into books table
COPY books (Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'E:\temp\Books.csv'
DELIMITER ','
CSV HEADER;


-- import data into customers table
copy customers(Customer_ID, Name, Email, Phone, City, Country)
from 'E:\temp\Customers.csv'
DELIMITER ','
csv header;

-- import data into orders table
ALTER TABLE orders
ALTER COLUMN total_amount TYPE DECIMAL(10,2);


copy orders (Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
from 'E:\temp\Orders.csv'
DELIMITER ','
csv header;



-- 1. retrieve all books in the "fiction" genre

select*from books
where genre='Fiction';

-- 2. find books published after the year 1950

select*from books
where published_year>1950;

-- 3. list all customers from the canda

select*from customers
where country='Canda';

-- 4. show orders placed in november 2023

select*from orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5. retrieve the total stock of books available

select sum(stock) as total_stock
from books;

-- 6. find the details of the most expensive book

select*from books 
order by price desc 
limit 1;

-- 7. show all customers who ordered more than 1 quantity of a book

select*from orders
where quantity>1;

-- 8. retrieve all orders where the total amount exceeds 20

select*from orders
where total_amount>20;

-- 9. list all genres available in the books table

select distinct genre from books;

-- 10. find the book with the lowest stock

select*from books
order by stock asc
limit 1;

-- 11. calculate the total revenue genrated from all orders
select sum(total_amount)
as total_revenue
from orders;



-- Advanced Quetions

-- 1. retrieve the total number of books sold for each gence

select*from orders;
select*from books;

select b.genre, sum(o.quantity) as total_book_sold
from orders o
join books b on o.book_id=b.book_id
group by b.genre;

-- 2. find the average price of books in the "fantasy" genre

select avg(price) as avg_price
from books
where genre='Fantasy';

-- 3. list customers who have placed at least 2 orders

select*from orders;
select*from customers;

select orders.customer_id, customers.name, count(orders.order_id) as order_count
from orders
join customers on orders.customer_id=customers.customer_id
group by orders.customer_id, customers.name
having count(order_id)>=2;


--4. find the most frequnetly ordered books

select*from orders;
select*from books;


select orders.book_id, books.title, count(orders.order_id) as order_count
from orders
join books on orders.book_id=books.book_id
group by orders.book_id, books.title
order by order_count desc limit 1;

-- 5. show the top 3 most expensive books of 'fantacy' genre

select*from books
where genre='Fantasy'
order by price desc limit 3;

-- 6. retrieve the total quantity of books sold by each author

select books.author, sum(orders.quantity) as total_quanity_b_sold
from orders
join books on books.book_id=orders.book_id
group by books.author;

-- 7. list the cities where customers who spent over 30 are located.
select*from customers;
select*from orders;

select distinct customers.city
from orders
join customers on customers.customer_id=orders.customer_id
where orders.total_amount>30;

-- 8. find the customer who spent the most on orders

select customers.customer_id, customers.name, sum(orders.total_amount) as spent
from orders
join customers on customers.customer_id=orders.order_id
group by customers.customer_id, customers.name
order by spent desc limit 1;



