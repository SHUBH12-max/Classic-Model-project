/*
  Name: MySQL Sample Database classicmodels
  Link: http://www.mysqltutorial.org/mysql-sample-database.aspx
*/
-- CLASSIC MODELS PROJECT--
show databases;
use classicmodels;
show tables;

-- display all customers. 

select * from customers ;

-- Display only the following columns:
-- customerName
-- city
-- country 
select customerName,city,country from  customers; 

-- Show customers who are from USA.
select * from customers where country="usa"; 

-- customers from France or Germany.
select * from customers where country in ("france","germany"); 

-- Total payment amount received. 
select sum(amount) as Total_payment from payments;

-- Average payment amount.
select round(avg(amount),2) as Avg_amount from payments;

-- Count customers in each country.
select country,count(customername) as total_customer from customers group by country;

-- Average credit limit by country.
select country,round(avg(Creditlimit),3) as Avg_CreditLimits from customers group by country;

-- Customer name with sales representative name. 
select c.customerName,concat(e.FirstName,' ',e.LastName) as Sales_Representative 
from Customers c join employees e on c.salesRepEmployeeNumber=e.employeeNumber; 

-- Customers name with office city. 
select c.customerName,o.City as Office_city from customers c join
employees e on c.salesRepEmployeeNumber=e.employeeNumber
join offices o on e.officeCode=o.officeCode ; 

-- Orders Number with Customer Name.
select o.orderNumber,c.CustomerName from orders o join customers c 
on o.CustomerNumber=c.CustomerNumber; 

-- Showing customer name, product name, and quantity ordered:--
select c.customerName,p.productName,od.quantityOrdered from customers c
join orders o on c.customerNumber=o.customerNumber  
join orderDetails od on od.orderNumber=o.orderNumber 
join products p on p.productCode=od.productCode; 

-- customers who have never placed an order.
select c.customerName from customers c left join
orders o on c.customerNumber=o.customerNumber where o.orderNumber is null; 

-- Employee Name and Manager Name.
select concat(e.firstName," ",e.lastName) as EmployeeName,
concat(m.firstName," ",m.lastName) as ManagerName from employees 
e left join employees m on e.reportsTo = m.employeeNumber;

-- Customers whose credit limit is above average.
select customerName,creditLimit from customers where creditLimit >(
select avg(CreditLimit) from customers);

-- Customers who paid the highest amount.
select c.customerName,p.amount from
customers c join payments p on c.customerNumber=p.CustomerNumber 
where p.amount=(select max(amount) from payments);

-- Find products whose MSRP is greater than the average MSRP.

select productName,MSRP from products where MSRP >(
select Avg(MSRP) from products)order by MSRP desc;

-- Rank customers by total payment.
select c.customerName,sum(p.amount) as total_amount,rank() over (
order by sum(p.amount) desc ) as ranks from customers c join payments p
on c.customerNumber=p.customerNumber group by c.customerName;

-- previous payment using Lag().

select customerNumber,paymentdate,amount,lag(amount) over 
(partition by customerNumber order by Paymentdate) as previous_payment 
from payments;

-- Next payment using LEAD().
select customerNumber,paymentDate,amount,lead(amount) over
(partition by customerNumber order by paymentDate) as next_payment 
from payments;

-- View showing customerName,country,payment.

create view Customer_details as (
select c.customerName,c.country,p.amount as payment from customers c join
payments p on c.customerNumber=p.customerNumber);

select * from customer_details;

-- Top 10 Customers by Revenue. 
select c.customerNumber,c.customerName,SUM(p.amount) AS Total_Revenue
from customers c join payments p on c.customerNumber = p.customerNumber
group by c.customerNumber,c.customerName order by Total_Revenue desc limit 10;

-- Top 10 Products by Revenue.
select p.productCode,p.productName,SUM(od.quantityOrdered * od.priceEach) AS Total_Revenue
from products p join orderdetails od on p.productCode = od.productCode
group by p.productCode, p.productName order by Total_Revenue desc
LIMIT 10;