-- Lab 6
-- wickham
-- Aug 28, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select distinct firstname, lastname
from receipts
join customers on cid=customer
where lastname not in
(select lastname
from receipts
join customers on cid=customer
where saledate >= '2007-10-05' and saledate <= '2007-10-11');


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with t(a, b) as (select customer, round(sum(price),2)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where saledate >='2007-10-00' and saledate <='2007-11-31'
group by customer), 

tbl(c) as (select max(b) from t)

select firstname, lastname,c from tbl
join t on c=b
join customers on customers.cid=a;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

select firstname, lastname 
from customers
where cid not in (select customer
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where saledate >='2007-10-00' and saledate <='2007-11-31' and goods.Food = 'Twist');


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
with t(a,b,c) as (select flavor, food, round(sum(price), 2)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
group by food, flavor),
tbl(d) as (select max(c) from t)
select a,b from tbl
join t on d=c;


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with t(a,b,c) as (select flavor, food, count(gid)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
group by food, flavor),
tbl(d) as (select max(c) from t)
select a,b, c from tbl
join t on d=c;


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
with t(a,b) as (select saledate, sum(price)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
group by saledate),
tbl(d) as (select max(b) from t)
select a from tbl
join t on d=b;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
with t(a,b,c) as (select flavor, food, count(gid)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where saledate='2007-10-12'
group by food, flavor),
tbl(d) as (select max(c) from t)
select a,b, c from tbl
join t on d=c;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with t(a,b,c,d) as (select customer, food, flavor, count(gid)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where food='Cake' and saledate >='2007-10-00' and saledate <='2007-11-31' 
group by flavor, customer),
tbl(e, f) as (select max(d), c  from t group by c)
-- select * from tbl
select distinct c, b, firstname, lastname, d from tbl
join t on e=d and c=f
join customers on cid=a
order by d desc, lastname;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

SELECT GId, Food, Flavor, SUM(Price)
FROM customers c
   JOIN receipts r on CId = Customer 
   JOIN items i on Receipt = RNumber 
   JOIN goods g on GId = Item 
WHERE Food IN (
  SELECT Food 
  FROM goods g2
  GROUP BY Food
  HAVING COUNT(*) > 5
)
GROUP BY GId
HAVING COUNT(DISTINCT DAYOFWEEK(SaleDate)) = 7;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

select 
case 
when (select sum(price)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where food='Croissant' and saledate >='2007-10-00' and saledate <='2007-11-31'
) < (select sum(price)
from customers
join receipts on receipts.customer=customers.cid
join items on items.Receipt=receipts.RNumber
join goods on goods.GId=items.Item
where flavor='chocolate' and saledate >='2007-10-00' and saledate <='2007-11-31'
)
then 'Chocolate'
end;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with t0(a, b) as (select room, count(code)
from reservations
join rooms on rooms.roomcode=reservations.room
group by room),
t1(c) as (select max(b) from t0)
select roomname, a,c from t1
join t0 on c=b
join rooms on a=rooms.roomcode;


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with t0(a, b) as (select roomcode, datediff(checkout, checkin)
from reservations
join rooms on rooms.roomcode=reservations.room
group by roomcode, datediff(checkout, checkin)),
t1(c) as (select max(b) from t0)
select roomname, a, c from t1
join t0 on c=b
join rooms on a=rooms.roomcode;


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
with t0(a, b, c) as (
select code, roomcode, round(datediff(checkout, checkin)*rate,2)
from reservations
join rooms on rooms.roomcode=reservations.room
group by roomcode, code
),

t1(d, e) as (select b, max(c) from t0 group by b)

select distinct roomname, checkin, checkout, lastname, rate, e from t1
join t0 on t1.e=t0.c and t0.b=d
join rooms on t0.b=rooms.roomcode
join reservations on a=code
order by e desc;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
select code, roomcode
from reservations
join rooms on rooms.roomcode=reservations.room
where '2010-07-04' between checkin and checkout
group by roomcode, code;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
with t0(a, b, c) as (
select monthname(checkin),sum(datediff(checkout, checkin)*rate), count(code)
from reservations
join rooms on rooms.roomcode=reservations.room
group by monthname(checkin)
),

t1(d) as (select max(b) from t0 )

select a,c,b from t1
join t0 on t1.d=t0.b;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

with t0 (a, b) as (select last, count(lastname) from teachers
join list on teachers.classroom=list.classroom
group by last),

t1(c) as (select max(b) from t0)

select last, first, c from t1
join t0 on t0.b=t1.c
join teachers on t0.a=teachers.last;


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
with t0 (a, b) as (select grade, count(lastname)
from teachers
join list on teachers.classroom=list.classroom
where lastname like 'A%' or lastname like 'B%' or lastname like 'C%'
group by grade
),

t1(c) as (select max(b) from t0)

select a, c from t1
join t0 on t0.b=t1.c;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
with t(a) as (select count(lastname) from teachers
join list on teachers.classroom=list.classroom
group by teachers.classroom)

select teachers.classroom, count(lastname) 
from teachers
join list on teachers.classroom=list.classroom
group by teachers.classroom
having count(lastname) < (select avg(a) from t);


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with t(a,b) as (select teachers.classroom, count(lastname) from teachers
join list on teachers.classroom=list.classroom
group by teachers.classroom)

select t0.a, t1.a, t1.b from t as t0
join t as t1 on t1.b=t0.b and t1.a != t0.a and t1.a > t0.a
order by t1.b;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teachers the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with t(a,b,c) as (select teachers.classroom, grade, count(lastname)
from teachers
join list on teachers.classroom=list.classroom
group by teachers.classroom, grade),

t0(c,d) as (select b, max(c) from t group by b having count(b) > 1)


select t0.c, Last from t0
join t on t.b=t0.c and t.c=t0.d
join teachers on teachers.classroom=t.a
order by t0.c;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

with t0(a,b) as (select campusid, enrolled
from enrollments
where year=2000),
t1(c) as (select max(b) from t0)

select campus, c from t1
join t0 on t0.b=t1.c
join campuses on id=a;


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

with t0(a,b) as (select campusid, avg(degrees) from degrees
group by campusid),
t1(c) as (select max(b) from t0)

select campus from t1
join t0 on t0.b=t1.c
join campuses on id=a;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
with t0(a,b) as (
select faculty.campusid, enrollments.fte/faculty.fte
from enrollments
join faculty on faculty.campusid=enrollments.campusid
where faculty.year=2003 and enrollments.year=2003
group by campusid),
t1(c) as (select min(b) from t0)

select campus, round(b,1) from t1
join t0 on t0.b=t1.c
join campuses on id=a;


USE `CSU`;
-- CSU-4
-- Find the university where, in the year 2004, undergraduate students in the discipline 'Computer and Info. Sciences'  represented the largest percentage out of all enrolled students (use the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
with t0(a,b) as (select enrollments.campusid,  round(((ug)/enrolled) * 100, 1) from discEnr
join enrollments on enrollments.campusid=discEnr.campusid
where discEnr.year=2004 and discipline=7 and enrollments.year=2004),

t1(c) as (select max(b) from t0)
select campus, b from t1, t0
join campuses on t0.a=id
where t0.b=t1.c;


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
with t0(a,b,c) as (
select degrees.campusid, round(degrees.degrees/enrollments.enrolled,4), degrees.year
from enrollments
join degrees on degrees.campusid=enrollments.campusid and degrees.year=enrollments.year
where degrees.year >=1997 and degrees.year <= 2003),
t1(d,e) as (select max(b),c from t0 group by c)

select c, campus, b from t1, t0
join campuses on id=a
where d=b and c=e
order by c;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
with t0(a,b,c) as (
select degrees.campusid, round(enrollments.fte/faculty.fte,2), degrees.year
from enrollments
join degrees on degrees.campusid=enrollments.campusid and degrees.year=enrollments.year
join faculty on faculty.campusid=enrollments.campusid and faculty.year=enrollments.year
),
t1(d,e) as (select max(b),a from t0 group by a)

select campus, c, b from t1, t0
join campuses on id=a
where d=b and a=e
order by campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

-- No attempt


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with t(a,b)  as (select state, count(Place) from marathon
group by state),
t1(c) as (select max(b) from t)

select a from t1
join t on t.b=t1.c
order by a;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

with t0(a,b) as (
select town, count(sex)
from marathon
where state='RI' and sex='M'
group by town
having count(sex)>0),

t1(a,b) as (
select town, count(place)
from marathon
where state='RI' and sex='F' 
group by town
having count(town)>0)

select t1.a from t0
join t1 on t1.a=t0.a
where t1.b>t0.b
order by t1.a;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with t(a,b,c, d)  as (
select state, agegroup, count(Place), sex
from marathon
group by state, agegroup, sex),

t1(e,f) as (select a,max(c) from t
group by a
)

select a, b, d, c from t1
join t on t.a=t1.e and t.c=t1.f
where f>1
order by a, b, d;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select sex
from marathon 
group by sex
having count(sex)=1;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

with t0 as (
select * 
from marathon
where sex='M' and state='CT'),
t1 as (
select * 
from marathon
where sex='F' and state='CT'),

t2 as (
select t0.town, count(t0.place)
from t0
group by t0.town),
t3 as (
select t1.town, count(t1.place)
from t1
group by t1.town
)

select * from t2
union all
select * from t3;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select firstname 
from Band
where id not in (select bandmate from Instruments
where Instrument='accordion');


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select Title from Songs
where songid not in (select song from Vocals);


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with t0(a,b) as (select song, count(Instrument) 
from Instruments
group by song),
t1(c) as (select max(b) from t0)

select title from t1
join t0 on t0.b=t1.c
join Songs on songid=a;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

with t0(a,b,c) as (select bandmate, instrument, count(Instrument) 
from Instruments
group by bandmate, Instrument),
t1(d,e) as (select a, max(c) from t0 group by a)

select firstname, b, c from t1
join Band on d=id
join t0 on t0.a=t1.d and t1.e=t0.c
order by firstname, c desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
select Instrument 
from Instruments
where bandmate=3 and Instrument not in (
select Instrument from Instruments
where bandmate!=3);


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

with t(a,b) as (select bandmate, count(distinct Instrument)
from Instruments
group by bandmate),
t1(c) as (select max(b) from t)

select Firstname from t1
join t on t1.c=t.b
join Band on id=a
order by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
-- No attempt


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

with t0(a,b) as (select bandmate, count(bandmate) 
from Performance
where stageposition='center'
group by bandmate
),
t1(c) as (select max(b) from t0)

select firstname from t1
join t0 on t0.b=t1.c
join Band on Band.id=a
order by firstname;


