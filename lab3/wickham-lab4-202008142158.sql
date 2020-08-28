-- Lab 4
-- wickham
-- Aug 14, 2020

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
select FirstName, LastName from list where classroom=111 order by LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
select distinct classroom, grade from list order by classroom desc;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
select distinct First, Last, teachers.classroom from teachers join list on teachers.classroom=list.classroom where list.grade=5 order by teachers.classroom desc;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
select FirstName, LastName from list join teachers on teachers.classroom=list.classroom where teachers.Last='Moyer' order by LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
select distinct First, Last, grade from list join teachers on teachers.classroom=list.classroom where grade >= 0 and grade <= 3 order by grade, Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
select Flavor, Food, Price from goods where Price < 5 and Flavor='chocolate' order by Price desc;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
select Flavor, Food, Price from goods where (Food='cookie' and Price>1.10) or (Flavor='lemon') or (Flavor='apple' and Food != 'Pie') order by Flavor, Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
select distinct LastName, FirstName from customers join receipts on receipts.Customer=customers.CId where SaleDate='2007-10-03' order by LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
select distinct Flavor, Food from goods join items on items.Item = goods.GId join receipts on RNumber = Receipt  where SaleDate='2007-10-04' and Food='cake' order by Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
select distinct Flavor, Food, Price from goods join items on items.Item = goods.GId join receipts on RNumber = Receipt join customers on receipts.Customer = customers.CId where SaleDate='2007-10-25' and customers.LastName='Cruzen';


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

select distinct Flavor, Food from goods join items on items.Item = goods.GId join receipts on RNumber = Receipt join customers on receipts.Customer = customers.CId where SaleDate <= '2007-10-31' and SaleDate >= '2007-10-01' and customers.LastName='Arnn' and Food='Cookie' order by Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
select Campus from campuses where county='Los Angeles' order by Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
select degrees.year, degrees from degrees join campuses on CampusId=Id where degrees.year >= 1994 and degrees.year <= 2000 and Campus='California Maritime Academy' order by degrees.year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
select campuses.Campus, disciplines.Name, discEnr.Gr, discEnr.Ug from campuses join discEnr on discEnr.CampusId=campuses.Id join disciplines on discEnr.discipline=disciplines.Id where (campuses.campus like '%Poly%') and (discEnr.Discipline =7 or Discipline=17 or Discipline=9) and (discEnr.year=2004) order by campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
select Campus, d1.Gr, d2.Gr from campuses
join discEnr as d1 on d1.CampusId=campuses.Id
join discEnr as d2 on d2.CampusId=campuses.Id
where d1.Discipline=1 and d1.Gr>0 and d2.Discipline=4 and d2.Gr > 0
order by d1.Gr desc;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
select campuses.Campus, disciplines.Name, ug, gr from campuses join discEnr on discEnr.CampusId=campuses.Id join disciplines on discEnr.discipline=disciplines.Id where discEnr.Gr > 3* discEnr.Ug order by Campus, Name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
select fees.year, (fees.fee * enrollments.fte) as Collected, ROUND(((fees.fee * enrollments.fte)/faculty.fte),2) as `Per Factulty` from fees join campuses on CampusId=campuses.id join enrollments on enrollments.CampusId=campuses.Id and enrollments.Year=fees.year join faculty on campuses.Id=faculty.CampusId and enrollments.year=faculty.year where campuses.Campus='Fresno State University' and fees.year >= 2002 and fees.year <= 2004;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
select distinct campuses.campus, enrollments.fte, faculty.fte, ROUND(enrollments.fte/faculty.fte, 1) as RATIO from campuses join enrollments on campuses.Id=enrollments.CampusId join faculty on faculty.year=enrollments.year and faculty.CampusId=campuses.Id where enrollments.FTE>21027 and enrollments.year =2003 order by RATIO;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
select RoomCode, RoomName from rooms where decor='modern' and basePrice<160 and beds=2;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
select LastName, checkin, checkout, (reservations.adults + reservations.kids), rate as Guests from reservations join rooms on rooms.RoomCode=reservations.Room where (CheckIn between '2010/07/01' and '2010/07/31') and (Checkout between '2010/07/01' and '2010/07/31') and roomname='Convoke and sanguine' order by checkin;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
select distinct rooms.roomname, reservations.checkin, reservations.checkout from reservations join rooms on rooms.RoomCode=reservations.Room where '2010/02/06' >= checkin and '2010/02/06' < checkout order by roomname;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

select distinct code, roomname, checkin, checkout, rate*DATEDIFF(checkout, checkin) from reservations join rooms on rooms.RoomCode=reservations.Room where LastName='KNERIEN';


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
select distinct roomname, rate, DATEDIFF(checkout, checkin), rate*DATEDIFF(checkout, checkin) from reservations join rooms on rooms.RoomCode=reservations.Room where checkin='2010/12/31' order by datediff(checkout, checkin) desc;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
select distinct code, room, roomname, checkin, checkout from reservations join rooms on rooms.RoomCode=reservations.Room where  beds=2 and adults=4 and bedtype='double' order by checkin, room;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
select Place, runtime, pace from marathon where LastName='Brasel';


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
select firstname,lastname, place, runtime, Groupplace from marathon where sex='F' and Town='Qunicy' order by place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
select firstname, lastname, town, runtime from marathon where sex='f' and State='CT' and age=34 order by runtime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
select distinct m.bibnumber from marathon as j join marathon as m on j.bibnumber=m.bibnumber and m.Firstname!=j.firstname order by m.bibnumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
select m.sex, m.agegroup, m.firstname, m.lastname, m.age, j.firstname, j.lastname, j.age from marathon as m join marathon as j on (m.agegroup=j.agegroup and m.sex=j.sex) where m.groupplace=1 and j.groupplace=2 order by m.sex, m.agegroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select distinct airlines.Name, airlines.abbr from flights join airlines on airlines.id=flights.airline where source='AXX' order by name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

select distinct flightno, destination, airports.name from flights join airlines on airlines.id=flights.airline join airports on airports.code=flights.destination where source='AXX' and airlines.name='Northwest Airlines' order by flightno;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
select f0.flightno, f1.flightno, f1.destination, airports2.name  from flights as f0 join airlines as airline0 on airline0.id=f0.airline join airports as a0 on a0.code=f0.destination join flights as f1 on f1.source=f0.destination join airlines as a1 on a1.id=f1.airline join airports as airports2 on f1.destination=airports2.code where f0.source='AXX' and airline0.name='Northwest Airlines' and a1.name = 'Northwest Airlines' and f1.destination != 'AXX';


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
select distinct 'ANB', 'ANP' from airports;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
select distinct f1.destination from flights as f0 join flights as f1 on f0.destination=f1.destination and f1.airline=3 join flights as f2 on f2.destination=f1.destination and f2.airline = 2 join flights as f3 on f3.destination=f1.destination and f3.airline=1 join flights as f4 on f4.destination=f1.destination and f4.airline=4 where f0.airline=9 order by f1.destination;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
select distinct f0.destination from flights as f0 

join flights as f1 on f0.destination=f1.destination and f1.airline=4 and f0.flightno != f1.flightno 

join flights as f2 on f2.destination=f1.destination and f2.airline=4 and f2.flightno != f1.flightno and f2.flightno != f0.flightno

where f0.airline=4 order by f0.destination;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
select Songs.title from Songs join Tracklists on Tracklists.Song=SongId join Albums on Albums.Aid=Tracklists.Album where Albums.title='Le Pop';


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
select Firstname, Instrument from Instruments, Songs, Band

where Songs.songid=Instruments.Song and Songs.Title='Mother Superior' and Band.Id=Instruments.Bandmate
order by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instrument from Performance, Instruments, Band
where Performance.Song=Instruments.Song and Band.Id=Instruments.Bandmate and Band.Firstname='Anne-Marit' order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
select distinct Title from Performance, Instruments, Band, Songs
where Performance.Song=Instruments.Song and Songs.SongId=Performance.Song and Band.Id=Instruments.Bandmate and Instrument='ukalele' order by Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instrument from 
Performance
join Instruments as i0 on i0.Song=Performance.Song 
join Band as b0 on b0.Id=i0.Bandmate
join Songs as s0 on s0.SongId=Performance.Song
join Vocals as v0 on v0.Song=s0.SongId
Join Band as b1 on b1.Id=v0.Bandmate
where b0.Firstname='Turid' and v0.Vocaltype='lead' and b1.Firstname='Turid' order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
select distinct Title, Band.Firstname, StagePosition from Performance, Vocals, Songs, Band
where Vocals.Song=Performance.Song and Vocals.Bandmate=Performance.Bandmate and Performance.Stageposition!='center' and Vocals.VocalType='lead' and Songs.SongId=Vocals.Song and Band.Id=Vocals.Bandmate order by Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
select distinct Title
from Instruments i0, 
Instruments i1,
Instruments i2,
Songs s1
where i0.Bandmate = i1.Bandmate and i1.Bandmate = i2.Bandmate 
and i0.Instrument != i1.Instrument and i1.Instrument != i2.Instrument and i0.Instrument != i2.Instrument
and i0.Song = i1.Song and i1.Song = i2.Song
and s1.SongId=i0.Song;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
select b1.Firstname, b2.Firstname, b3.Firstname, b0.Firstname
from Performance as pLeft,
    Performance as pRight,
    Performance as center,
    Performance as Back,
    Band b0,
    Band b1,
    Band b2,
    Band b3,
    Songs s
    where pLeft.Song = s.SongId and pRight.Song = s.SongId and center.Song = s.SongId and Back.Song=s.SongId
    and s.Title = 'A Bar in Amsterdam'
    and pLeft.StagePosition = 'left'
    and pRight.stageposition = 'right'
    and center.stageposition = 'center'
    and Back.stageposition = 'back'
    and b0.Id=pLeft.Bandmate
    and b1.Id=pRight.Bandmate
    and b2.Id=center.Bandmate
    and b3.Id=Back.Bandmate;


