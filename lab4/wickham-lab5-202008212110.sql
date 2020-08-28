-- Lab 5
-- wickham
-- Aug 21, 2020

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
select source, name 
from flights, airports
where airports.Code=source
group by source
having count(source)=17;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
select count(distinct f1.source)
from flights as f0
join flights as f1 on f1.destination=f0.source
where f0.destination='ANP' and f1.source!='ANP';


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
select count(distinct f1.source) + 3
from flights as f0
join flights as f1 on f1.destination=f0.source
join flights as f2 on f2.destination='ATE'
where f0.destination='ATE' and f1.source!='ATE';


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select airlines.name, count(distinct destination)
from flights
join airlines on airlines.Id=airline
group by airline
order by count(distinct destination) desc, airlines.name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
select flavor, round(avg(price),2), count(flavor) 
from goods
group by flavor
having count(flavor) > 3;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
select sum(price) 
from receipts
join items on items.Receipt=receipts.RNumber
join goods on items.Item=goods.GId
where receipts.SaleDate >= '2007-10-00' and receipts.SaleDate <= '2007-10-31'
and goods.Food='Eclair';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
select RNumber, SaleDate, count(ordinal), round(sum(price),2)
from receipts
join items on items.Receipt=receipts.RNumber
join goods on items.Item=goods.GId
and receipts.customer=19
group by receipts.RNumber
order by sum(price) desc;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
select DAYNAME(SaleDate), saledate, count(distinct receipt), count(item), round(sum(price),2)
from receipts
join items on items.Receipt=receipts.RNumber
join goods on items.Item=goods.GId
where receipts.saledate >= '2007-10-08' and receipts.saledate <= '2007-10-14'
group by SaleDate
order by SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
select SaleDate
from receipts
join items on items.Receipt=receipts.RNumber
join goods on items.Item=goods.GId
group by SaleDate, Food
having count(item) > 10 and Food='Tart'
order by SaleDate, food;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
select campus, sum(fee)
from campuses
join fees on fees.CampusId=campuses.id
where fees.year >= 2000 and fees.year <= 2005 
group by campus
having avg(fee) > 2500
order by sum(fee);


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
select campuses.campus, avg(enrolled), min(enrolled), max(enrolled) 
from campuses
join enrollments on campuses.Id=enrollments.campusId
group by campuses.campus
having count(enrollments.year) > 60
order by avg(enrolled);


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

select campus, sum(degrees)
from campuses
join degrees on campuses.Id=degrees.campusId
where (degrees.year >= 1998 and degrees.year <= 2002) and (county='Los Angeles' or county='Orange')
group by campuses.campus
order by sum(degrees) desc;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
select Campus,  count(gr)
from campuses
join discEnr on campuses.Id=discEnr.campusId
join enrollments on enrollments.campusId=discEnr.campusId
where discEnr.year=2004 and discEnr.Gr > 0 and enrollments.year=2004 and enrollments.enrolled > 20000
group by campus
order by campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November. Sort output in descending order by total revenue. Output full room names.
select distinct roomname, sum(datediff(checkout, checkin)*rate), round(avg(datediff(checkout, checkin)*rate), 2)
from reservations
join rooms on rooms.roomcode=reservations.room
where checkin >= '2010-09-00' and checkin <= '2010-12-00'
group by roomname
order by sum(datediff(checkout, checkin)*rate) desc;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
select count(code), sum(datediff(checkout, checkin)*rate)
from reservations
join rooms on rooms.roomcode=reservations.room
where dayofweek(reservations.checkin) = 6;


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
select dayname(checkin), count(code), sum(datediff(checkout, checkin)*rate)
from reservations
join rooms on rooms.roomcode=reservations.room
group by dayofweek(checkin), dayname(checkin)
order by dayofweek(checkin);


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
select roomname, max(rate)-baseprice,  min(rate)-baseprice
from reservations
join rooms on rooms.roomcode=reservations.room
group by roomcode
order by max(rate)-baseprice desc, roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
-- No attempt


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
select Band.FirstName, count(VocalType)
from Band
join Vocals on Vocals.Bandmate=Band.Id
where vocaltype='lead'
group by FirstName, VocalType
order by count(vocaltype) desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
select FirstName, Count(distinct instrument)
from Instruments
join Tracklists on Instruments.Song=Tracklists.Song
join Band on Band.Id=Instruments.Bandmate
where Album=1
group by FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

select stageposition, count(stageposition)
from Performance
where Bandmate=4
group by stageposition
order by count(stageposition);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

select Firstname
from Performance as p0
join Performance as p1 on p0.Song=p1.Song
join Instruments on Instruments.Song=p0.Song
join Band on Instruments.Bandmate=Band.Id
where p0.Bandmate=3 and p0.StagePosition='left' and p1.Instrument='bass balalaika'
group by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
select instrument
from Instruments
group by instrument
having count(distinct bandmate) >= 3;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
select distinct firstname, 
        count(*) over (partition by Firstname)
from Band 
join Songs
join Instruments
where Bandmate=id and Songid=song
group by firstname, song
having count(distinct instrument) > 1;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
select agegroup, sex, count(FirstName), min(place), max(place)
from marathon
group by agegroup, sex
order by agegroup, sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
select count(*)
from marathon as m1
join marathon as m2 on m1.groupplace=1 and m2.groupplace=2 and m1.agegroup=m2.agegroup and m1.sex=m2.sex and m1.state=m2.state;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select extract(minute from pace), count(FirstName)
from marathon
group by extract(minute from pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
select state, count(groupplace)
from marathon
where groupplace < 11
group by state
order by count(groupplace) desc;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
select town, round(avg(time_to_sec(runtime)),1)
from marathon
where state='CT'
group by town
having count(Place) >= 3
order by avg(time_to_sec(runtime));


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
select Last, First 
from list
join teachers on teachers.classroom=list.classroom
group by teachers.classroom
having count(LastName) >= 7 and count(LastName) <= 8
order by Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

select grade,  count(distinct list.classroom), count(LastName)
from list
join teachers on teachers.classroom=list.classroom
group by list.grade
order by count(distinct list.classroom) desc, grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
select list.classroom, count(LastName)
from list
join teachers on teachers.classroom=list.classroom
where grade=0
group by list.classroom
order by count(LastName) desc;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
select list.classroom, Max(LastName)
from list
join teachers on teachers.classroom=list.classroom
where grade=4
group by list.classroom
order by list.classroom;


