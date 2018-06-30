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

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

select * from actor
where last_name = 'WILLIAMS';

UPDATE actor
 SET first_name = 'HARPO', actor_name='HARPO WILLIAMS'
 WHERE actor_id = 172;
 
--  4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name 
-- after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
-- change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
-- (Hint: update the record using a unique identifier.)

-- I'm not sure what this is asking me to do.

select * from actor
where actor_name like '%HARPO%';

UPDATE actor
 SET first_name = 'GROUCHO', actor_name='GROUCHO WILLIAMS'
 WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
select * from staff;
select * from address;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;

-- 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select * from payment;

select staff_id, count(amount)
from payment
where payment_date like '2005%'
group by staff_id;

-- 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;


SELECT film.title, count(film_actor.actor_id) as 'Count_Actor'
FROM film_actor
INNER JOIN film ON film.film_id = film_actor.film_id
group by film.title;
-- 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film;

SELECT film.title, count(inventory.film_id)
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
where film.title like 'Hunchback Impossible'
group by film.title;

-- 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;

Select customer.last_name, sum(payment.amount)
from payment
inner join customer on payment.customer_id = customer.customer_id
group by customer.customer_id
order by customer.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the 
-- letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from film;
select * from language;

Select language.name, film.title 
from language
inner join film on language.language_id = film.language_id
where film.title in (
	select title
	from film
	where title like 'K%' or title like 'Q%'
    )
AND language.name like 'English';


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select * from actor;
select * from film;
select * from film_actor;

Select actor_name
from actor
where actor_id in (
	select actor_id
	from film_actor
	where film_id in (
		select film_id
		from film
		where title like 'Alone Trip'
		)
	);


-- 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
select * from customer;
select * from address;
select * from country;
select * from city;

Select c.first_name, c.last_name, c.email, country.country 
from customer as c
inner join address as a on a.address_id = c.address_id
inner join city on city.city_id = a.city_id
inner join country on country.country_id = city.country_id
where country.country like 'Canada';


-- 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
-- 

select * from film_category;
select * from category;
select * from film;

Select category.name, film.title
from film_category
inner join film on film.film_id = film_category.film_id
inner join category on category.category_id = film_category.category_id
where category.name = 'Family';


-- 7e. Display the most frequently rented movies in descending order.

select * from film;
select * from payment;
select * from rental;
select * from inventory;

Select count(f.title), f.title
from rental as r
inner join inventory as i on r.inventory_id = i.inventory_id
inner join film as f on f.film_id = i.film_id
group by f.title
order by 1 desc;

-- 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- 

select * from payment;
select * from staff;

select sum(p.amount), s.store_id 
from payment as p
inner join staff as s on p.staff_id = s.staff_id
group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

select * from store;
select * from address;
select * from city;
select * from country;

select s.store_id, c.city, y.country
from store as s
inner join address as a on s.address_id = a.address_id
inner join city as c on a.city_id = c.city_id
inner join country as y on c.country_id = y.country_id;
-- 
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, 
-- payment, and rental.)
-- 

select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select count(c.name), c.name, sum(p.amount)
from payment as p
inner join rental as r on r.rental_id = p.rental_id
inner join inventory as i on r.inventory_id = i.inventory_id
inner join film_category as fc on fc.film_id = i.film_id
inner join category as c on fc.category_id = c.category_id
group by c.name
order by 3 desc
limit 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_five
as select count(c.name), c.name, sum(p.amount)
from payment as p
inner join rental as r on r.rental_id = p.rental_id
inner join inventory as i on r.inventory_id = i.inventory_id
inner join film_category as fc on fc.film_id = i.film_id
inner join category as c on fc.category_id = c.category_id
group by c.name
order by 3 desc
limit 5;
-- 
-- 8b. How would you display the view that you created in 8a?

Select * from Top_five;
-- 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
-- 
Drop view Top_five;