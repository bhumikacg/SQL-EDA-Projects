-- The following questions  are based on 'Maven_movies' database 

-- Question 1 Write an SQL query to count the number of characters except the spaces for each actor. 
--            Return first 10 actors name,length.
SELECT actor_id,first_name,last_name,concat(first_name,last_name)AS  Full_name, char_length(concat(first_name,last_name)) AS Length_Name 
FROM actor LIMIT 10;

-- Question 2. List all Oscar Awardees with their full names and length of their names.
SELECT actor_award_id, actor_id, first_name, last_name,concat(first_name,last_name) AS  Full_name,
  Length(concat(first_name,last_name)) AS Length_Name ,awards 
FROM actor_award
WHERE awards LIKE '%Oscar%';

-- Question 3. Find the actors who have acted in the film ‘Frost Head’.
SELECT f.film_id,f.title,a.actor_id,at.first_name,at.last_name 
FROM film AS f 
INNER JOIN film_actor AS a ON f.film_id = a.film_id 
INNER JOIN  actor AS at ON a.actor_id = at.actor_id 
WHERE title = 'Frost head'; 

-- Question 4. Pull all the films acted by the actor ‘Will Wilson’.
SELECT a.actor_id,a.first_name,a.last_name,fa.film_id,ft.title 
FROM actor AS a 
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
INNER JOIN film_text AS ft ON fa.film_id = ft.film_id 
WHERE first_name LIKE 'WILL%' AND last_name LIKE 'WILSON%';

-- Question 5. Pull all the films which where rented and return in the month of May. 
SELECT * 
FROM rental 
WHERE rental_date LIKE '%-05-%' AND return_date LIKE '%-05-%';  

-- 6. Pull all films with ‘Comedy’ category.
SELECT fc.film_id,fc.category_id,c.name,ft.title 
FROM film_category AS fc 
INNER JOIN category AS c ON fc.category_id= c.category_id
INNER JOIN film_text AS ft ON fc.film_id= ft.film_id 
WHERE name= 'Comedy';
