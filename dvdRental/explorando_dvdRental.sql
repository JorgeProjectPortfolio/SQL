------------------------------------
-- CLAUSULA WHERE
-----------------------------------

--obtener el titulo de las peliculas que se publicaron en el año 2006

select
	title
from film
where release_year = 2006 


--obtener peliculas que tengan duracion de mas de 120 minutos y rating de R
 select
	title,
	lenght,
	rating
from film
where length>120 and rating = 'R'


--obtener las peliculas que tengan rating R o PG
select
	title,
	rating
from film
where rating = 'PG' or rating = 'R'


--De la tabla film retorna el titulo de todas las peliculas que se alquilan por 2.99 y se alquilan por mas de 5 dias
select
 title
from film 
where rental_rate = 2.99 and rental_duration > 5

--De la tabla payment retorna el monto de todos los pagos hechos por el cliente 341
select 
	amount
from payment
where customer_id = 341


--De la tabla customer retorna el apellido de todos los clientes con nombre Mary
select
	last_name
from customer
where first_name = 'Mary'


------------------------------------
-- CLAUSULA DISTINCT Y COUNT
-----------------------------------

--tipos de rating existen en tabla film
select
	distinct(rating)
from film


--cuantos peliculas únicas hay
select
	count(distinct(film_id))
from film

--de la tabla payments retorna los valores unicos de pagos  que se han realizado
select
	distinct(amount)
from payment


--de la tabla film retorna todos los valores únicos del costo de reemplazar el dvd
select
	distinct(replacement_cost)
from film

--de la tabla film retorna la cantidad de valores únicos en la columna rental_rate para 
--aquellas peliculas que duren 90 minutos exactamente
select
	count(distinct(rental_rate))
from film
where length = 90


------------------------------------
-- CLAUSULA ORDER BY Y LIMIT
-----------------------------------

--los 10 dvd mas cortos que hay
select
	title,
	length
from film
order by length asc
limit 10


--de la tabla payment retorna  los ultimos 3 pagos menores o iguales a 4.99 
--hechos por el cliente 322
select
	customer_id,
	payment_date,
	amount
from payment
where customer_id = 332 and amount <= 4.99
order by payment_date desc
limit 3


--de la tabla film retorna el titulo y la duracion de las 10 peliculas con mayor duracion ordendas en orden alfabetico
select
	title,
	length
from film
order by length desc, title asc
limit 10



------------------------------------
-- CLAUSULA BETWEEN, IN, LIKE, ILIKE
-----------------------------------

-- alquileres de dvd hubo en el mes de mayo de 2005
select 
	*
from rental
where rental_date between '2005-05-01' and '2005-06-01'


--actores que su nombre empieza con J y apellido empieza con Z
select
	first_name,
	last_name
from actor
where first_name like 'J%' and last_name ilike 'z%'



------------------------------------
-- CLAUSULA GROUP BY
-----------------------------------

--cantidad de alquileres del cliente 148 y con que trabajador lo hizo
select
	customer_id,
	staff_id,
	count(*) as cantidad_alquileres
from rental
where customer_id = 148
group by customer_id,staff_id
order by 2 desc

--Cuanto nos ha pagado cada cliente historicamente
select
	customer_id,
	sum(amount)
from payment
group by customer_id
order by sum desc


--cuales son los 5 clientes que mas nos han pagado en promedio
select
	customer_id,
	avg(amount)
from payment
group by customer_id
order by avg desc
limit 5


--retorna la cantidad de pagos hecha por cada monto del cliente 591
select
	customer_id,
	amount,
	count(*)
from payment
where customer_id = 591
group by customer_id,amount
order by amount desc


--retorna las fechas del primer y ultimo alquiler hecho por cada cliente
select 
	customer_id,
	min(rental_date) as primer_alquiler,
	max(rental_date) as ultimo_alquiler
from rental
group by customer_id



------------------------------------
-- CLAUSULA HAVING
-----------------------------------

--que peliculas tienen mas de 5 copias
select
	film_id,
	count(inventory_id)
from inventory
group by film_id
having count(inventory_id) > 5
order by 2 desc


--clientes que hostoricamente han pagado mas de 200
select
	customer_id,
	sum(amount)
from payment
group by customer_id
having sum(amount) > 200


--retorna todos los clientes que tienen un promedio de pago mayor a 5
select 
	customer_id,
	avg(amount)
from payment
group by customer_id
having avg(amount)>5


--retorna la suma de todos los pagos por cliente, de aquellos clientes que han pagado mas de 7.99 alguna vez
select
	customer_id,
	sum(amount)
from payment
group by customer_id
having max(amount) >7.99


------------------------------------
-- FUNCIONES VENTANA
-----------------------------------
--lead , lag , first, last
--posterior ,anterior, primero, ultimo

--suma acumulada de pago de cada cliente por orden de fecha
select
	customer_id,
	payment_date,
	amount,
	sum(amount) over (partition by customer_id 
					 order by payment_date asc)
from payment

----valor anterior del pago de cada cliente por orden de fecha
select
	customer_id,
	payment_date,
	amount,
	lag(amount,1) over (partition by customer_id 
					 order by payment_date asc)
from payment


----dias que pasan entre pago de cada cliente por orden de fecha
select
	customer_id,
	payment_date,
	amount,
	payment_date - lag(payment_date,1) over (partition by customer_id 
					 order by payment_date asc)
from payment


--que porcentaje del valor total de pagos es cada pago para cada cliente
select
	customer_id,
	amount,
	amount*100/sum(amount) over (partition by customer_id)
from payment


--muestra el historial de pagos del cliente 222 y ademas muestra el acumulado de sus pagos hasta ese momento
select
	customer_id,
	payment_date,
	amount,
	sum(amount) over (partition by customer_id order by payment_date asc)
from payment
where customer_id = 222


--retorna el customer_id , la fecha y el porcentaje acumulado que representa cada pago del total de pagos hecho por el cliente 341
select
	customer_id,
	payment_date,
	amount,
	sum(amount) over (partition by customer_id),
	sum(amount) over (partition by 
					  customer_id order by payment_date asc)* 100 
					  /sum(amount) over (partition by customer_id)
from payment
where customer_id = 341



------------------------------------
-- LEFT JOIN
-----------------------------------

select
	payment.payment_id,
	customer.customer_id,
	customer.first_name,
	customer.last_name
from payment left join customer on payment.customer_id = customer.customer_id

--cuantas copias de una pelicula tenemos en total
select 
	film.title,
	count(*) as stock
from inventory left join film on inventory.film_id = film.film_id
group by film.title
order by 2 desc

--peliculas que no tiene copia
select 
	title,
	inventory_id
from film left join inventory on inventory.film_id = film.film_id
where inventory_id is null


--retorna todos los alquileres junto con la informacion del respectivo pago si es que existe
select
	rental.rental_id,
	amount
from rental
left join payment on rental.rental_id = payment.rental_id
where amount is not null


--retorna todos los alquileres que no han sido pagados
select
	rental.rental_id,
	amount
from rental
left join payment on rental.rental_id = payment.rental_id
where amount is null


------------------------------------
-- INNER JOIN
-----------------------------------

--alquileres hechos por Barbara Jones
select
	*
from customer
inner join rental on customer.customer_id = rental.customer_id
where first_name='Barbara' and last_name='Jones'


--para cada alquiler encuentra el nombre del cliente que alquilo y el empleado que proceso la transaccion 
select
	rental_id,
	customer.first_name,
	customer.last_name,
	staff.first_name,
	staff.last_name
from rental
inner join customer on customer.customer_id = rental.customer_id
inner join staff on staff.staff_id = rental.staff_id


------------------------------------
-- FULL OUTER JOIN
-----------------------------------

--verificar si todos nuestros pagos tienen un cliente asociado
select
	*
from customer
full outer join payment on customer.customer_id = payment.customer_id
where customer.customer_id is null or payment.customer_id is null

--peliculas que estan en nuestro inventario
select
	*
from film full outer join inventory on film.film_id = inventory.film_id
where inventory.film_id is not null


--encuentra las direcciones las cuales no tienen un cliente asignado
select
	*
from customer
full outer join address on customer.address_id = address.address_id
where customer_id is null


--retorna todas las peliculas que no tengan el registro de un actor en la tabla actor
select 
	*
from film_actor 
full outer join film on film.film_id = film_actor.film_id
full outer join actor on film_actor.actor_id = actor.actor_id
where actor.actor_id is null and film_actor.actor_id is null



------------------------------------
-- CLAUSULA CASE
-----------------------------------
--crear nuevas columnas en base a condiciones


--conocer cuando un cliente nos ha pagado mas que una vez anterior
select 
	amount,
	lag(amount) over (partition by customer_id order by payment_date asc),
	case
		when amount > lag(amount) over (partition by customer_id order by payment_date asc) then 1
		else 0
	end as logica
From payment


--escribe una consulta que clasifique cada pelicula como "costosa" si su costo de reemplazo es mayor  o
--igual a 10.99 y barata si es menor a ese valor
select
	title,
	replacement_cost,
	case
		when replacement_cost >=10.99 then 'costosa'
		else 'barata'
	end as logica
from film


--identifica con un 2 todos los pagos que han sido mayores a los 2 pagos anteriores hechos por el mismo cliente
-- y con 1 todos los que sean mayores al pago anterior
select
	*,
	amount,
	lag(amount) over (partition by customer_id order by payment_date asc) as ant_1,
	lag(amount,2) over (partition by customer_id order by payment_date asc) as ant_2,
	case
		when amount > lag(amount) over (partition by customer_id order by payment_date asc) and
			 amount > lag(amount,2) over (partition by customer_id order by payment_date asc) then 2
		when amount > lag(amount) over (partition by customer_id order by payment_date asc) then 1
		else 0
	end as logica
from payment


------------------------------------
-- FUNCIONES NULLIF Y COALESCE
-----------------------------------
--COALESCE -> para reemplazar datos nulos de otras columnas
--NULL IF ->inversa de COALESCE

select
	film.title,
	coalesce(inventory.inventory_id,0)
from film
left join inventory on film.film_id = inventory.film_id
where inventory_id is null



------------------------------------
-- DATE_PART Y DATE_TRUNC
-----------------------------------
select
	age('2020-04-30', '2020-04-23')

--

select
	age('01-01-1990'::date) -- dia-mes-año

--

select
	age('2020-04-30'::date) -- año-mes-dia

--
select
	DATE_PART('day','2020-04-30'::DATE) AS DIA,
	date_part('month','2020-03-30'::DATE) AS MES
	
--trunc
select 
	date_trunc('day','2020-04-03'::date),
	date_trunc('month','2020-04-03'::date),
	date_trunc('year','2020-04-03'::date)

--interval
select
	'2020-04-01'::date +interval '1 day',
	'2020-04-01'::date +interval '1 month',
	'2020-04-01'::date +interval '1 year',
	'2020-04-01'::date +interval '2 years'
	
--
select
	current_date, --fecha actual
	now()  -- fecha completa con hora
	

--cuanto nos han pagado por dia
select
	date_trunc('day',payment_date),
	sum(amount)
from payment
group by 1
order by 1 desc


------------------------------------
-- SUBQUERY
-----------------------------------

--peliculas que el costo de alquiler sea mayor al promedio
select
	film_id
from film
where rental_rate >(
	select
		avg(rental_rate)
	from film)
	
-----
	
WITH T1 AS (
	SELECT 
		customer_id,
		amount
	FROM PAYMENT
)


select 
	*
from T1


--CASO
--EL GERENTE QUIERE EXPANDIR EL INVENTARIO DE DVD PERO NO SABE QUE GENERO ES MEJOR

-cantidad de ventas por genero y monto generado
select 
	category.name,
	count(rental.rental_id) as total_alquileres,
	sum(amount) as monto_total
from category
inner join film_category on category.category_id = film_category.category_id
inner join inventory on inventory.film_id = film_category.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join payment on payment.rental_id = rental.rental_id
group by category.name
order by 2 desc
limit 5

--que pasa si un solo cliente tiene muchas compras. verificar cuantas alquileres hay de distintos clientes
--no se junta con payment ya que con inner join solo se mostraria las rentas que han sido pagadas. y dejaria excluidas las
--que no fueron pagadas.
select 
	category.name,
	count(distinct(rental.customer_id)) as total_alquileres
from category
inner join film_category on category.category_id = film_category.category_id
inner join inventory on inventory.film_id = film_category.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by category.name
order by 2 desc
limit 5



--tipos de datos
--integer
--float
--text
--date
--timestamp
--booles
--char
--varchar
--number


--copiar datos de un archivo
--copy nombre_tabla from 'ruta_del _archivo' delimiter ',' header csv