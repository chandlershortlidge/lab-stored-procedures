use sakila;

-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers
-- that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.


DELIMITER $$
CREATE PROCEDURE genre_email_contact_list (in genre varchar(20))
BEGIN
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = genre
  group by first_name, last_name, email;
END$$

DELIMITER ;

CALL genre_email_contact_list("Animation");
CALL genre_email_contact_list("Children");
CALL genre_email_contact_list("Documentary");
CALL genre_email_contact_list("Documentary");

-- Write a query to check the number of movies released in each movie category. 

select 
c.name as genre,
count(fc.film_id) as films_per_genre
from category as c
join film_category as fc on c.category_id = fc.category_id
join film as f on fc.film_id = f.film_id
group by c.name;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 

DELIMITER $$
CREATE PROCEDURE genre_count_filter (in p_films_per_genre int) 
BEGIN
select 
c.name as genre,
count(fc.film_id) as films_per_genre
from category as c
join film_category as fc on c.category_id = fc.category_id
join film as f on fc.film_id = f.film_id
group by c.name
having count(fc.film_id) >= p_films_per_genre;
END$$ 

call genre_count_filter(60);

-- Error Code: 1052. Column 'film_id' in having clause is ambiguous


