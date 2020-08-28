-- Final Exam Part 2
-- wickham
-- Aug 28, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all flavors of Cookie or Lemon-flavored items of any type that have been purchased on Saturday or Sunday. List each pastry type (food) and flavor once. Sort by food then flavor.
select distinct food, flavor
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where (dayofweek(saledate)=1 or dayofweek(saledate)=7) and (food='Cookie' or flavor='Lemon')
order by food, flavor;


USE `BAKERY`;
-- BAKERY-2
-- For customers who have purchased at least one Cookie, find the customer's favorite flavor(s) of Cookie based on number of purchases.  List last name, first name, flavor and purchase count. Sort by customer last name, first name, then flavor.
with t0(a,b,c) as (select distinct customer, flavor, count(flavor)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where food='Cookie' 
group by customer, flavor),
t1(d,e) as (select a, max(c) from t0 group by a)
select lastname, firstname, b, e from t1
join customers on cid=d 
join t0 on t0.c=t1.e and t0.a=t1.d
order by lastname, firstname, b;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who have purchased a Cookie on two or more consecutive days. List customer Id, first, and last name. Sort by customer id.
with t0(a, b) as (
select customer, saledate
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where food='Cookie'
group by customer, saledate
)
select distinct t0.a, lastname, firstname from t0 as t0
join t0 as t1 on t0.a=t1.a and t1.b=DATE_ADD(t0.b, INTERVAL 1 DAY)
join customers on customers.cid=t0.a
order by t0.a;


USE `INN`;
-- INN-1
-- Find all rooms that are *un*occupied every night between June 1st and June 8th, 2010 (inclusive).  Report room codes, sorted alphabetically.
select roomcode from rooms
where roomcode not in (select distinct room from reservations
join rooms on roomcode=reservations.room
where (checkin >= '2010-06-01' and checkin <= '2010-06-01') or (checkout > '2010-06-01' and checkout  < '2010-06-08') or (checkin < '2010-06-01' and checkout > '2010-06-08'));


USE `INN`;
-- INN-2
-- For calendar year 2010, create a monthly report for room with code AOB. List each calendar month and the number of reservations that began in that month. Include a plus or minus indicating whether the month is at/above (+) or below (-) the average number of reservations per month for this room. Sort in chronological order by month.
with t0(a) as (select count(code) from reservations
join rooms on roomcode=reservations.room
where room='AOB'
group by month(checkin))

select monthname(checkin), count(code),
case
    when count(code)>= (select avg(t0.a) from t0) then "+"
    when count(code) < (select avg(t0.a) from t0) then "-"
end
from reservations
join rooms on roomcode=reservations.room
where room='AOB'
group by monthname(checkin);


USE `AIRLINES`;
-- AIRLINES-1
-- List the name of every airline along with the number of flights  offered by that airline which depart from airport ACV. If an airline does not fly from ACV, show the number 0. Sort alphabetically by airline name.
with t0(a,b) as (select airlines.name, count(flightno)
from flights
join airlines on airlines.Id=airline
where flights.source='ACV'
group by airline)

select airlines.name, 
case
when b is null then 0
when b is not null then b
end
from airlines
left join t0 on t0.a=airlines.name
order by airlines.name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the airports with the highest and lowest percentages of inbound flights on Frontier Airlines. For example, airport ANQ is the destination of 10 flights, 1 of which is a Frontier flight, yielding a "Frontier percentage" of 10. Report airport code and Frontier percentage rounded to two decimal places. Sort by airport code.
with t0(a, b) as (select flights.destination, count(flightno)
from flights
join airlines on airlines.Id=airline
group by flights.destination),
t1(c,d) as (select flights.destination, count(flightno)
from flights
join airlines on airlines.Id=airline
where airlines.name='Frontier Airlines'
group by flights.destination),

t2(e,f) as (select destination, (d/b) 
from flights
join airlines on airlines.Id=airline
join t0 on t0.a=flights.destination
join t1 on t1.c=flights.destination
group by destination),

t3(g) as (select max(f)*100 from t2),
t4(h) as (select min(f)*100 from t2)

select e,g from t3
join t2 on t2.f= (t3.g/100)
union all 
select e,h from t4
join t2 on t2.f=(t4.h/100)
order by e;


