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
