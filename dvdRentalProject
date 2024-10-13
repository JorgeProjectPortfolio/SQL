/*
¿Cuál es el precio de alquiler promedio para cada género de película?
*/
select
	category.name,
	avg(payment.amount)
from category inner join film_category on category.category_id = film_category.category_id
				inner join film on film.film_id = film_category.film_id
				inner join inventory on inventory.film_id = film.film_id
				inner join rental on rental.inventory_id = inventory.inventory_id
				inner join payment on payment.rental_id = rental.rental_id
group by category.name
order by 2 desc



/*
¿Cuántos clientes hay? y ¿cuál es el valor de todas las ventas en los siguientes países: Perú, México, Brasil, Chile, Colombia?
*/
  
select
	count(distinct(customer_id))
from customer


select
	country.country,
	sum(amount)
from payment inner join customer on payment.customer_id = customer.customer_id
				inner join address on customer.address_id = address.address_id
				inner join city on address.city_id = city.city_id
				inner join country on city.country_id = country.country_id
group by country.country
having country.country in ('Peru','Mexico','Brasil','Chile','Colombia')



------------------------------------
/*
3. ¿Cuántos clientes distintos han alquilado una película en cada género?.
*/

select
	category.name,
	count(distinct(customer.customer_id)),
from rental inner join customer on rental.customer_id = customer.customer_id
			inner join inventory on inventory.inventory_id = rental.inventory_id
			inner join film on film.film_id = inventory.film_id
			inner join film_category on film_category.film_id = film.film_id
			inner join category on category.category_id = film_category.category_id
group by category.name


------------------------------------
/*
4. ¿Cuántas películas se devolvieron a tiempo, o tarde?
*/
  
select
	condicion,
	count(*)
	
from (
	select
	rental.rental_date,
	rental.return_date,
	film.rental_duration,
	case
		when DATE_PART('day',rental.return_date) - DATE_PART('day',rental.rental_date) < film.rental_duration then 'PASO'
		else 'A TIEMPO'
	end as condicion
from rental inner join inventory on rental.inventory_id = inventory.inventory_id
			inner join film on inventory.film_id = film.film_id

)
group by condicion
