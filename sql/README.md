# Introduction
The goal of the project is to help a newly opened analyze the usage patterns and demand for the club’s facilities. The database provided consists of three datasets including member, facility and booking information. In this project, we will use SQL (Structured Query Language), a specialized language to access and manipulate databases.
# SQL Quries

### Table Setup (DDL)
```
CREATE TABLE cd.members
    (
       memid integer NOT NULL, 
       surname character varying(200) NOT NULL, 
       firstname character varying(200) NOT NULL, 
       address character varying(300) NOT NULL, 
       zipcode integer NOT NULL, 
       telephone character varying(20) NOT NULL, 
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );
```
```  
 CREATE TABLE cd.facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );
```
```
  CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );
```
###### Question 1: Show all members 

-- Modifying Data
-- The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
insert into cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
values 
  (9, 'spa', 20, 30, 100000, 800);

-- Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
-- Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
insert into cd.facilities 
values 
  (
    (select max(facid) from cd.facilities) + 1, 
    'spa', 20, 30, 100000, 800
  );
-- We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
update 
  cd.facilities 
set 
  initialoutlay = 10000 
where 
  facid = 1;
  
-- We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
update 
  cd.facilities 
set 
  membercost = 1.1* (select membercost from cd.facilities where facid =0),
  guestcost = 1.1* (select guestcost from cd.facilities where facid=0)
where 
  facid = 1;
  
-- As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?
delete from cd.bookings; 
-- We want to remove member 37, who has never made a booking, from our database. How can we achieve that?
delete from 
  cd.members 
where 
  memid = 37
  
-- Basic
-- Control which rows are retrieved - part 2
select facid, name, membercost, monthlymaintenance from cd.facilities
where membercost<monthlymaintenance/50 and membercost!=0
--Basic string searches
select * from cd.facilities 
where name like '%Tennis%'
-- Retrieve the start times of members' bookings
select 
  starttime 
from 
  cd.bookings 
  inner join cd.members on members.memid = bookings.memid 
where 
  firstname = 'David' 
  and surname = 'Farrell'
  
-- Work out the start times of bookings for tennis courts
select bookings.starttime as start, facilities.name as name
from cd.bookings
inner join cd.facilities 
on facilities.facid=bookings.facid
where facilities.name in ('Tennis Court 2','Tennis Court 1') 
and bookings.starttime::date = '2012-09-21'
order by starttime
-- Matching against multiple possible values
select * from cd.facilities
where facid in (1,5)
--Working with dates
select memid, surname, firstname, joindate
from cd.members 
where joindate >= '2012-09-01'
-- union vs join
select distinct surname as surname from cd.members
union select distinct name from cd.facilities
--Produce a list of all members, along with their recommender
select members.firstname as memfname, members.surname as memsname,
recommender.firstname as recfname, recommender.surname as recsname
from cd.members
left join cd.members as recommender
on members.recommendedby=recommender.memid
order by memsname,memfname
--Produce a list of all members who have recommended another member
select distinct recommender.firstname as firstname, recommender.surname as surname
from cd.members
left join cd.members as recommender
on members.recommendedby=recommender.memid
where recommender.firstname is not null
order by surname,firstname
--Produce a list of all members, along with their recommender, using no joins.
select distinct members.firstname || ' ' || members.surname as member,
	(select distinct recommender.firstname || ' ' || recommender.surname as recommender
 		from cd.members as recommender
 		where recommender.memid=members.recommendedby
 	)
 	from cd.members
 order by member
--Count the number of recommendations each member makes.
select recommender.memid as recommendedby, count(recommender.memid) as count
from cd.members
left join cd.members as recommender
on members.recommendedby=recommender.memid
where recommender.memid is not null
group by recommender.memid
order by recommender.memid
--List the total slots booked per facility
select bookings.facid, sum(slots) as "Total Slots"
from cd.bookings
inner join cd.facilities
on bookings.facid=facilities.facid
group by bookings.facid
order by bookings.facid
-- List the total slots booked per facility in a given month
select bookings.facid, sum(slots) as "Total Slots"
from cd.bookings
where bookings.starttime between '2012-09-01' and'2012-10-1'
group by bookings.facid
order by sum(slots)
--List the total slots booked per facility per month
select bookings.facid, extract(month from starttime) as month, sum(slots) as "Total Slots"
from cd.bookings
where extract(year from starttime)=2012
group by bookings.facid, extract(month from starttime)
order by bookings.facid, extract(month from starttime)
--Find the count of members who have made at least one booking
select count(distinct bookings.memid) as "count"
from cd.bookings
--List each member's first booking after September 1st 2012
select surname, firstname, members.memid, min(bookings.starttime) as starttime
from cd.members
full join cd.bookings
on members.memid=bookings.memid
where starttime>'2012-09-01'
group by surname, firstname, members.memid
order by members.memid
--Produce a list of member names, with each row containing the total member count
select count(*) over(), firstname, surname
from cd.members
order by joindate
--Produce a numbered list of members
select row_number() over(order by joindate), firstname, surname
from cd.members
order by joindate
-- Output the facility id that has the highest number of slots booked, again
select facid, total from(
select bookings.facid, sum(slots) as total, rank() over (order by sum(slots) desc) as count
from cd.bookings
group by facid
order by sum(slots) desc) as subquery
where count =1
--Format the names of members
select surname || ', ' || firstname as name from cd.members  
--Find telephone numbers with parentheses
select memid, telephone from cd.members
where telephone like '(%)%-%'
-- Count the number of members whose surname starts with each letter of the alphabet
select substr(surname, 1,1) as letter, count(*) as count
from cd.members
group by letter
order by letter

###### Questions 2: Lorem ipsum...



