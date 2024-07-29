# The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
# facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
insert into cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
values 
  (9, 'spa', 20, 30, 100000, 800);

# Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
# Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
insert into cd.facilities 
values 
  (
    (
      select 
        max(facid) 
      from 
        cd.facilities
    ) + 1, 
    'spa', 
    20, 
    30, 
    100000, 
    800
  );
# We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
update 
  cd.facilities 
set 
  initialoutlay = 10000 
where 
  facid = 1;
  
# We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
update 
  cd.facilities 
set 
  membercost = 1.1* (select membercost from cd.facilities where facid =0),
  guestcost = 1.1* (select guestcost from cd.facilities where facid=0)
where 
  facid = 1;

  
