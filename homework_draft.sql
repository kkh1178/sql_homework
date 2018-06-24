-- 1a. Using sakila, Display the first and last names of all actors from the table actor.
SET SQL_SAFE_UPDATES = 0;
Use sakila;
Select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select * from actor;

Alter table actor
 add actor_name VARCHAR(50);
 update actor set actor_name = CONCAT(first_name, ' ', last_name);
 
--  --2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
-- "Joe." What is one query would you use to obtain this information? 

Select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN-- 


Select *
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

Select last_name, first_name
from actor
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country 
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
-- Hint: you will need to specify the data type.

ALTER table actor 
ADD column middle_name VARCHAR(50) 
AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.

ALTER table actor
modify column middle_name blob;

-- 3c. Now delete the middle_name column.

ALTER table actor
 drop middle_name;
 
--  4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name)
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

select last_name, count(last_name)
from actor
group by last_name
having count(last_name)>=2;