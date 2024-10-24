--1. ¿Cuál es el precio de alquiler promedio para cada género de película?

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
--conclusión: En promedio, las películas de la categoria Comedy son las que tienen mayor precio de alquiler y las películas
--de la categoría Children son las que tienen menor precio



-- 2. ¿Cuántos clientes hay? y ¿cuál es el valor de todas las ventas en los siguientes países: Perú, México, Brasil, Chile, Colombia?

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
--conclusión: Mexico es el pais que más ingresos ha generado y Chile es el que menos ha generado


------------------------------------

--3. ¿Cuántos clientes distintos han alquilado una película en cada género?.
select
	category.name,
	count(distinct(customer.customer_id))
from rental inner join customer on rental.customer_id = customer.customer_id
			inner join inventory on inventory.inventory_id = rental.inventory_id
			inner join film on film.film_id = inventory.film_id
			inner join film_category on film_category.film_id = film.film_id
			inner join category on category.category_id = film_category.category_id
group by category.name
order by 2 desc
--conclusión: La categoría que más alquileres tiene de distintos clientes es Sports y la que menor rentas tiene es Travel

------------------------------------

--4. ¿Cuántas películas se devolvieron a tiempo, o tarde?
select
	condicion,
	count(*)	
from (
	select
	rental.rental_date,
	rental.return_date,
	film.rental_duration,
	case
		when DATE_PART('day',rental.return_date) - DATE_PART('day',rental.rental_date) < film.rental_duration then 'PASÓ'
		else 'A TIEMPO'
	end as condicion
from rental inner join inventory on rental.inventory_id = inventory.inventory_id
			inner join film on inventory.film_id = film.film_id
)
group by condicion
--conclusión: Se devolvierón a tiempo 6774 películas y no se devolvieron a tiempo 9270 peliculas. Por lo tanto, la mayoría de películas
--no se devuelven a tiempo.


---En inventario, ¿Cuántas películas hay en cada categoría y cuál es la duración promedio de las películas por categoría?
select
	category.name,
	count(*) cantidad_peliculas,
	avg(film.length) as duracion_promedio
from category
join film_category on category.category_id = film_category.category_id
join inventory on film_category.film_id = inventory.film_id
join film on inventory.film_id = film.film_id
group by category.name
order by 2 desc
--conclusión: La categoria que tiene más películas es Sport y la que tiene menos películas es Music
 

---¿Cuáles son los 10 clientes que más películas han rentado?
select 
	customer.first_name,
	customer.last_name,
	count(rental.rental_id) as peliculas_rentadas
from customer
join rental on customer.customer_id = rental.customer_id
group by 1,2
order by 3 desc
limit 10
--conclusión: Eleanor Hunt es el cliente que más películas ha rentado. 46 películas en total. 


---¿Cuánto ha generado en ingresos cada tienda?
select
	store.store_id,
	sum(payment.amount) as ingresos
from store
join inventory on store.store_id = inventory.store_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by 1
order by 2 desc
--conclusión: Se observa que la tienda con id= 2 ha generado más ingresos que la tienda con id=1 con una diferencia de 54.22


---¿Qué películas ha rentado un cliente específico, dado su nombre y apellido?
--nombre_cliente= Jared , apellido= Ely
select
	customer.first_name,
	customer.last_name,
	film.title
from customer 
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on inventory.film_id = film.film_id
where customer.first_name = 'Jared' and customer.last_name = 'Ely'
--conclusion: Para el cliente Jared Ely, existen 19 peliculas que ha rentado


---¿Cuáles son las películas que nunca han sido rentadas?
select
	film.title
from film 
full outer join inventory on film.film_id = inventory.film_id
full outer join rental on inventory.inventory_id = rental.inventory_id
where rental.rental_id is null
--conclusión: Existen 43 peliculas que no han sido rentadas


---¿Cuáles son las películas en las que han actuado ciertos actores (por ejemplo, 'Johnny Depp' o 'Brad Pitt')?
select
	film.title
from film
join film_actor on film_actor.film_id = film.film_id
join actor on film_actor.actor_id = actor.actor_id
where actor.first_name = 'Brad' and actor.last_name = 'Pitt'
--conclusión: Para los dos actores propuesto no existe pelicula registrada donde hayan actuado


---¿Cuál es la duración promedio de las películas por cada clasificación (rating)?
select
	rating,
	avg(length) as length_promedio
from film
group by rating
---conclusión: la clasificación con mayor duracion promedio es PG-13.


---¿Qué clientes nunca han rentado películas?
select
	customer.customer_id,
	count(rental_id)
from customer
full outer join rental on customer.customer_id = rental.customer_id
group by customer.customer_id
having count(rental_id) is null
--conclusión: todos los clientes registrados han rentado al menos una vez


---¿Cuáles son las 5 películas más rentadas en cada tienda?
select
	film.title,
	count(rental.rental_id) as total_alquileres
from film 
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
group by film.title
order by 2 desc
limit 5
--conclusión: las peliculas mas rentadas son Bucket Brotherhood, Rocketeer Mother, Grit Clockwork, Forward Temple y Juggler Hardly

