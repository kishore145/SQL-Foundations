# Homework assignment on SQL for UC Berkeley Bootcamp
# Completed by : Kishore Ramakrishnan using MySQL and Sakila sample DB

# Specify the db to use
USE sakila;

# 1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.
# Step 1: Query table to view the schema for actor table
SELECT * FROM actor LIMIT 5; 
# Query to view first_name and last_name of all actors in the actor table
SELECT
	first_name, last_name 
FROM actor; 

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT 
	UPPER(CONCAT(first_name, " ", last_name)) AS Actor_Name
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT
	actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
# View the table layout of country table
SELECT * FROM country LIMIT 5;

# Query to view country_id and country column
SELECT 
	country_id, country 
FROM country 
WHERE 
	country IN ('Afghanistan', 'Bangladesh','China');

# 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
 ADD middle_name VARCHAR(50);
# Right click on the table and select alter table and the mySQL workbench gives you the query to place the column location
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` VARCHAR(50) NULL DEFAULT NULL AFTER `first_name`;
# view the table to ensure the new column is added in correct position.
SELECT * FROM actor LIMIT 5;

# 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
	CHANGE COLUMN middle_name middle_name BLOB NULL DEFAULT NULL;
# view actor table. 
DESCRIBE actor;
SELECT * FROM actor LIMIT 5;

#3c. Now delete the middle_name column.
ALTER TABLE actor
	DROP COLUMN middle_name;
SELECT * FROM actor LIMIT 5;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name) > 1;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
#Find out how many records are in actor table with name GROUCHO WILLIAMS
SELECT * FROM actor WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
# use update command to rename first_name and use actor_id as well to avoid any accidental update. 
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS' AND actor_id = 172;
# verify the change
SELECT * FROM actor WHERE actor_id = 172;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 
CASE first_name
	WHEN 'HARPO' THEN 'GROUCHO'
    ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172;
#verify result
SELECT * FROM actor WHERE actor_id = 172;
#verify other rows are not impacted.
SELECT * FROM actor LIMIT 5;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address;
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
#STEP 1: view contents of staff and address table. 
SELECT * FROM staff LIMIT 5;
SELECT * FROM address LIMIT 5;
# Join Query to view the result
SELECT 
s.first_name, s.last_name, a.address
FROM staff s
LEFT OUTER JOIN address a
ON s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
#STEP 1: view contents of staff and payment table. 
SELECT * FROM staff LIMIT 5;
SELECT * FROM payment LIMIT 5;
# Query to view the total amount rung by each staff member for August 2005
SELECT 
s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_amount
FROM staff s
LEFT OUTER JOIN payment p
ON s.staff_id = p.staff_id
WHERE EXTRACT(YEAR_MONTH FROM p.payment_date) = 200508
group by s.staff_id, s.first_name, s.last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM film_actor LIMIT 5;
SELECT * FROM film LIMIT 5;
#Query to view the result
SELECT
f.film_id, f.title, COUNT(fa.actor_id) AS number_of_actors
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM film LIMIT 5;
SELECT * FROM inventory LIMIT 5;
# Query to view the result
SELECT
f.film_id, f.title, COUNT(i.film_id) AS number_of_copies
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.film_id, f.title;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT * FROM payment LIMIT 5;
SELECT * FROM customer LIMIT 5;
# Query to view the result
SELECT
c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount_paid
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name ASC;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT * FROM film LIMIT 5;
# Query to view result
SELECT sq.title FROM
(SELECT * FROM film WHERE 
	title like 'K%' OR title like 'Q%') AS sq;

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM film_actor LIMIT 5;
SELECT * FROM film LIMIT 5;
SELECT * FROM actor LIMIT 5;
# Query to view the result
SELECT 
a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id
IN
(SELECT
fa.actor_id
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
WHERE f.title = 'Alone Trip');

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT * FROM customer LIMIT 5;
SELECT * FROM address LIMIT 5;
SELECT * FROM city LIMIT 5;
SELECT * FROM country LIMIT 5;
#Query to view results. Intentionally putting city and country to verify the results are accurate. 
SELECT 
cr.customer_id, cr.first_name, cr.last_name, cr.email, cy.city, c.country
FROM customer cr
JOIN address a ON cr.address_id = a.address_id
JOIN city cy ON a.city_id = cy.city_id
JOIN country c ON cy.country_id = c.country_id
WHERE c.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM film LIMIT 5;
SELECT * FROM film_category LIMIT 5;
SELECT * FROM category LIMIT 5;
# Query to view results. 
SELECT 
f.film_id, f.title, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

# 7e. Display the most frequently rented movies in descending order.
SELECT * FROM rental LIMIT 5;
SELECT * FROM film LIMIT 5;
SELECT * FROM inventory LIMIT 5;
#Query to view results
SELECT
f.film_id, f.title, count(r.rental_id) AS number_of_times_rented
FROM rental r
JOIN inventory i
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY number_of_times_rented DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM store LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM staff LIMIT 5;
SELECT * FROM address LIMIT 5;
SELECT * FROM rental LIMIT 5;
SELECT * FROM city LIMIT 5;
SELECT * FROM country LIMIT 5;
SELECT * FROM inventory LIMIT 5;
# Query to view the result
SELECT
	st.store_id, 
	CONCAT(ct.city,", ",c.country) AS store, 
    CONCAT(s.first_name, " ", s.last_name) AS manager, 
    SUM(p.amount) AS total_business
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store st ON i.store_id = st.store_id
JOIN address a ON st.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country c ON ct.country_id = c.country_id
JOIN staff s ON st.manager_staff_id = s.staff_id 
GROUP BY st.store_id
ORDER BY store, manager;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT * FROM address LIMIT 5;
SELECT * FROM store LIMIT 5;
SELECT * FROM city LIMIT 5;
SELECT * FROM country LIMIT 5;
#Query to view the result
SELECT
s.store_id, ct.city, c.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country c ON c.country_id = ct.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT * FROM category LIMIT 5;
SELECT * FROM film LIMIT 5;
SELECT * FROM inventory LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM rental LIMIT 5;
SELECT * FROM film_category LIMIT 5;
# Query to view the result
SELECT
c.category_id, c.name AS genre, sum(p.amount) AS gross_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON f.category_id = c.category_id
GROUP BY c.category_id
ORDER BY gross_revenue DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW 
	top_five_genres 
AS (
SELECT
c.category_id, c.name AS genre, sum(p.amount) AS gross_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON f.category_id = c.category_id
GROUP BY c.category_id
ORDER BY gross_revenue DESC LIMIT 5);


#8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;
													
