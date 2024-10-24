/*
create table empleado(
    id_empleado int PRIMARY key,
    nombre VARCHAR2(10),
    direccion VARCHAR2(50),
    id_documento VARCHAR2(10),
    fecha_nacimiento date,
    sueldo number(6,2)
)
*/
----------------------------------------
--CREANDO VARIABLES
---------------------------------------

set serveroutput on -- habilitar salida de mensajes

DECLARE
identificador integer := 50;
nombre varchar2(25) := 'Jorge juan de dios';
apodo char(10) := 'george';
sueldo number(5) := 3000;
comision decimal(4,2) := 50.20;
fecha_actual date := (sysdate); --fecha actual
fecha date := to_date('2020/07/09','yyyy/mm/dd');
fecha2 date := '07-02-2023';
saludo varchar2(50) default 'Buenos dias';

BEGIN
dbms_output.put_line('El valor de la variable es: ' || identificador);
dbms_output.put_line('El nombre del usuario es: ' || nombre);
dbms_output.put_line('El apodo del usuario es:' || apodo);
dbms_output.put_line('El sueldo es: ' || sueldo);
dbms_output.put_line('La comision es: ' || comision);
dbms_output.put_line('la fecha actual es: ' || fecha_actual);
dbms_output.put_line('la fecha  es: ' || fecha);
dbms_output.put_line('la fecha2 es: ' || fecha2);
dbms_output.put_line(saludo);

END;



--CONSTANTES

DECLARE 
mensaje constant varchar2(30) := 'buenos dias a todos';
numero constant number(6) := 30000;

BEGIN
dbms_output.put_line(mensaje);
dbms_output.put_line(numero);

END;


-----------------------------------
-----CONDICIONALES IF - ELSE - ELSIF
----------------------------------------

DECLARE
    a number(2) := 10;
    b number(2) := 20;
BEGIN
    if a > b then
        dbms_output.put_line(a || 'es mayor que ' || b);
    else
        dbms_output.put_line(b || ' es mayor que ' || a);
    end if;
END;
      

-----
DECLARE
    numero number(3) := 100;
BEGIN
    if numero= 10 then
        dbms_output.put_line('valor del numero es 10');
    elsif numero = 20 then
        dbms_output.put_line('el valor del numero es 20');
    elsif numero = 30 then
        dbms_output.put_line('el valor del numero es 30');
    else
        dbms_output.put_line('ninguno de los valores fue encontrado');
    end if;
        dbms_output.put_line('El valor exacto de la variable es: ' || numero);
END;


--------------------
------BUCLES LOOP
-----------------------


DECLARE 
    valor number(2) := 10;
BEGIN
    loop
        dbms_output.put_line(valor);
        valor := valor + 10;
        if valor >50 then
        exit;
        end if;
    end loop;
    dbms_output.put_line('valor final de la variables es: ' || valor);
END;    


-----otro metodo de cerrar

DECLARE 
    valor number(2) := 10;
BEGIN
    loop
        dbms_output.put_line(valor);
        valor := valor + 10;
        exit when valor > 50;
    end loop;
    dbms_output.put_line('valor final de la variables es: ' || valor);
END;




--------------STRINGS
DECLARE 
    nombre varchar2(20);
    direccion varchar(20);
    detalles clob; --almacena gran cantidad de texto
    eleccion char(1);
BEGIN
    nombre := 'Pedro Perez';
    direccion := 'av san marcos';
    detalles := 'este es el detalle de la variable clob que iniciamos en la seccion declarativoa';
    eleccion := 'y';
    if eleccion = 'y' then
        dbms_output.put_line(nombre);
        dbms_output.put_line(direccion);
        dbms_output.put_line(detalles);
    end if;
END;


------------------

DECLARE
    saludo varchar2(12):= 'HOLA A TODOS';
BEGIN
    dbms_output.put_line(lower(saludo)); --convierte a minuscula 
    dbms_output.put_line(upper(saludo)); --convierte a mayuscula
    dbms_output.put_line(initcap(saludo)); -- convierte mayuscula la primera letra de cada palabra
    
    dbms_output.put_line(substr(saludo,1,4)); --trae los indices del 1 al 4
    dbms_output.put_line(substr(saludo,2)); --trae los indices del 2 hasta el final
    dbms_output.put_line(substr(saludo,-1)); --trae el ultimo indice
    
    dbms_output.put_line(instr(saludo,'O')); --busca la posicion de la letra
END;


-------------

DECLARE
    saludo2 varchar2(30) := '###Hola a todos###';
BEGIN
    dbms_output.put_line(rtrim(saludo2,'#')); --retira el valor del texto pero solo del lado derecho
    dbms_output.put_line(Ltrim(saludo2,'#')); --retira el valor del texto pero solo del lado izquierdo
    dbms_output.put_line(trim('#' from saludo2)); --retira el valor del texto
END;


---------------
----BUCLE WHILE
-------------------

DECLARE
    valor number(2) := 10;
BEGIN
    while valor < 20 loop
        dbms_output.put_line('El valor es: ' || valor);
        valor := valor + 1;
    end loop;
    dbms_output.put_line('el valor final de la variables es: ' || valor);
END;


----
DECLARE
    numero number :=0;
    resultado number;
BEGIN
    while numero <=10 loop
    resultado := 3*numero;
    dbms_output.put_line('3x' || numero || '=' ||resultado);
    numero := numero +1;
    end loop;
END;


----------------
----BUCLE FOR
------------------

DECLARE
    numero number(2);
BEGIN
    for numero in 10..20 loop
        dbms_output.put_line('valor del numero es: ' || numero);
    end loop;
END;


------IN REVERSE
BEGIN
    for f in reverse 0..5 loop
        dbms_output.put_line('el valor de f es: ' || f);
    end loop;
END;


----
BEGIN
    for f in 0..10 loop 
        dbms_output.put_line('2x' || f || '=' || 2*f);
    end loop;
END;



-----------------------------
---BUCLES ANIDADOS
-------------------------------

DECLARE
    bucle1 number:= 0;
    bucle2 number;
BEGIN
    loop
        dbms_output.put_line('-------------------------');
        dbms_output.put_line('valor del bucle externo = ' || bucle1);
        dbms_output.put_line('-------------------------');
        bucle2 := 0;
        loop
            dbms_output.put_line('Valor del bucle anidado = ' || bucle2);
            bucle2 := bucle2 +1;
            exit when bucle2 = 5;
        end loop;
        bucle1 := bucle1 + 1;
        exit when bucle1 = 3;
    end loop;
END;



-------------------------------------
----MATRICES
-----------------------------------

DECLARE
    type a_paises is varray(5) of varchar2(20);
    nombres a_paises;
BEGIN
    nombres := a_paises('Argentina','Brasil','Perú','Mexico','Honduras');
    for pais in 1..5 loop
        dbms_output.put_line('nombre: ' || nombres(pais));
    end loop;
END;


------
DECLARE
    type matriz_nombres is varray(5) of varchar2(20);
    type matriz_edad is varray(5) of integer;
    nombres matriz_nombres;
    edad matriz_edad;
    total integer;
BEGIN
    nombres := matriz_nombres('Juan','Jorge','Pepe','Pedro','Lucia');
    edad := matriz_edad(12,14,34,45,43);
    total:=nombres.count;
    for f in 1..total loop
        dbms_output.put_line('nombre: ' || nombres(f) || '  edad: ' || edad(f));
    end loop;
END;



-----------------------------
---PROCEDIMIENTOS ALMACENADOS
------------------------------

create or replace procedure saludo
AS
    BEGIN
        dbms_output.put_line('Hola a todos');
    END saludo;
    
    
--invocamos el procedure

BEGIN
    saludo;
END;

--otro metodo
execute saludo;


----------------aumentar sueldo con un procedure
select * from empleado;

---------
create or replace procedure aumento_sueldo
as
    begin
        update empleado set sueldo = sueldo + sueldo*0.1;
end aumento_sueldo;

---

execute aumento_sueldo;


-----------------------------
---PROCEDIMIENTOS ALMACENADOS (PARAMETROS)
------------------------------
--aumentar el sueldo a todos loa empleados que tengan mas de 10 años en la empresa
create table empleados(
    id_empleado int PRIMARY key,
    nombre VARCHAR2(10),
    direccion VARCHAR2(50),
    id_documento VARCHAR2(10),
    fecha_ingreso date,
    sueldo number(6,2)
)
-------

create or replace procedure aumentaSueldo(anio in number, porcentaje in number)
as
    begin
        update empleados set sueldo = sueldo + sueldo*porcentaje/100
        where (extract(year from current_date) - extract(year from fecha_ingreso)) > anio;
end aumentaSueldo;

---
execute aumentaSueldo(10,20);


-------------------
create or replace procedure ingresoemple(id in int,docu in char, nom in varchar2, ape in varchar2)
as
begin
    insert into empleados values(id,nom,null,docu,null,null);
end ingresoemple;

---
execute ingresoemple(2,'96543','fernando','lazo');
---
select * from empleados;



-----------------------------
---PROCEDIMIENTOS ALMACENADOS (VARIABLES)
------------------------------

create table libros( 
   titulo varchar2(40),
   autor varchar2(40),
   precio number(6,2)
  );
  
create table tabla1( 
   titulo varchar2(40),
   precio number(6,2)
  );
---
select * from libros;

------pasar datos de una tabla a otra en base al titulo del libro
create or replace procedure autorlibro(atitulo in varchar2)
as
    v_autor varchar2(20);
begin
    select autor into v_autor from libros where titulo = atitulo;
    insert into tabla1
    select titulo,precio from libros
    where autor = v_autor;
end autorlibro;

--


    
