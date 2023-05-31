-- РЕЙТИНГОВЫЕ 
/* Задание: 4 (Serge I: 2009-04-17)
Посчитать сумму цифр в номере каждой модели из таблицы Product
Вывод: номер модели, сумма цифр

Для этой задачи запрещено использовать:
CTE */
SElECT
	model,
	Try_CAST(SUBSTRING(model, 1, 1) AS int) + Try_CAST(SUBSTRING(model, 2, 1) AS int) + Try_CAST(SUBSTRING(model, 3, 1) AS int) + Try_CAST(SUBSTRING(model, 4, 1) AS int)
FROM	
	Product
	-- TRY_CAST(LEFT(model, 1) AS int) as first,
	-- TRY_CAST(RIGHT(model, 1) AS int) as last
____________________________________________________________
не мое верное решение

SELECT model, 
    1 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '1', ''))) +
    2 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '2', ''))) +
    3 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '3', ''))) +
    4 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '4', ''))) +
    5 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '5', ''))) +
    6 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '6', ''))) +
    7 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '7', ''))) +
    8 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '8', ''))) +
    9 * (DATALENGTH(model) - DATALENGTH(REPLACE(model, '9', ''))) AS 'qty'
FROM product

-- я бы решала с помощью цикла https/stackoverflow.com/questions/38665486/sum-of-digits-in-sql

/* Задание: 3 (Serge I: 2007-08-03)
Для таблицы Product получить результирующий набор в виде таблицы со столбцами maker, pc, laptop и printer, в которой для каждого производителя требуется указать, производит он (yes) или нет (no) соответствующий тип продукции.
В первом случае (yes) указать в скобках без пробела количество имеющихся в наличии (т.е. находящихся в таблицах PC, Laptop и Printer) различных по номерам моделей соответствующего типа. */

SElECT
	model,
	maker
FROM
Product
GROUP_CONCAT(maker)







-- Задание: -7 (Serge I: 2009-07-19)
-- В таблице Product найти модели, у которых первый символ представляет собой четную цифру, а последний - нечетную.
При этом первый символ должен быть меньше последнего.
Вывод: номер модели, тип модели, произведение первой и последней цифр в номере модели


!! С ЧИСЛОВЫМИ ЗНАЧЕНИЯМИ НЕРАБОЧАЯ ТЕМА - меньше на 3 записи
SElECT 
	model,
	type,
	(Try_CAST(model AS int) / POWER(10, len(model) - 1)) * (Try_CAST(model AS int) % 10)
	--
	-- CAST(model AS int) / POWER(10, len(model) - 1) as first,
	-- CAST(model AS int) % 10 as last
FROM 
	Product
WHERE
	Try_CAST(model AS int) / POWER(10, len(model) - 1) % 2 = 0 AND -- / Целочисленное деление для int
	Try_CAST(model AS int) % 2 = 1 AND
	Try_CAST(model AS int) / POWER(10, len(model) - 1) < Try_CAST(model AS int) % 10

-- Целочисленное деление
-- http://www.sql-tutorial.ru/ru/book_integer_division.html

_______________________________________________
РЕШЕНИЕ С ТЕКСТОВЫМИ ФУНКЦИЯМИ - больше на 1 запись

SElECT 
	model,
	type,
	CAST(SUBSTRING(model, 1, 1) AS int) * CAST(SUBSTRING(model, len(model), len(model)) AS int)
	--
	-- CAST(SUBSTRING(model, 1, 1) AS int) as first,
	-- CAST(SUBSTRING(model, len(model), len(model)) AS int) as last
FROM 
	Product
WHERE
	Try_CAST(SUBSTRING(model, 1, 1) AS int) % 2 = 0 AND -- 
	Try_CAST(SUBSTRING(model, len(model), len(model)) AS int) % 2 = 1 AND
	Try_CAST(SUBSTRING(model, 1, 1) AS int) < Try_CAST(SUBSTRING(model, len(model), len(model)) AS int)
_
____________________________________________________________
ЗАМЕНИМ SUBSTRING НА RIGHT & LEFT
SElECT 
	model,
	type,
	TRY_CAST(LEFT(model, 1) AS int) * TRY_CAST(RIGHT(model, 1) AS int)
	--
	-- TRY_CAST(LEFT(model, 1) AS int) as first,
	-- TRY_CAST(RIGHT(model, 1) AS int) as last
FROM 
	Product
WHERE
	TRY_CAST(LEFT(model, 1) AS int) % 2 = 0 AND -- 
	TRY_CAST(RIGHT(model, 1) AS int) % 2 = 1 AND
	TRY_CAST(LEFT(model, 1) AS int) < TRY_CAST(RIGHT(model, 1) AS int)












SELECT T3.country, IIF(T2.Qty = 0, NULL, MIN(T2.Qty)), MIN(T3.launched) AS Year
FROM (
    SELECT country, MAX(Qty) AS Qty 
    FROM (
        SELECT country, launched, COUNT(ships.name) AS Qty 
        FROM classes
        LEFT JOIN ships
        ON classes.class = ships.class
        GROUP BY country, launched
    ) AS T1
    GROUP BY country
) AS T2
INNER JOIN (
    SELECT country, launched, COUNT(ships.name) AS Qty 
    FROM classes
    LEFT JOIN ships
    ON classes.class = ships.class
    GROUP BY country, launched
) AS T3
ON T2.country = T3.country AND T2.Qty = T3.Qty
GROUP BY T3.country, T2.Qty


-- Задание: 32 (Serge I: 2003-02-17)
-- Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.

SELECT country, cast(avg( POWER(bore, 3) / 2) AS NUMERIC(6,2)) as mw FROM(
SELECT country, bore, ship FROM Classes
	INNER JOIN Outcomes
	ON Outcomes.ship= Classes.class

	UNION 

	SELECT country, bore, Ships.name as ship FROM Classes
	INNER JOIN Ships
	ON Ships.class = Classes.class

	) as T1
GROUP BY country

-- CAST для отображения опр разрядности (ROUND косячный) 
-- http://www.sql-tutorial.ru/ru/book_type_conversion_and_cast_function/page2.html


-- Задание: 40 (Serge I: 2012-04-20)
Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type

SELECT maker, type FROM product
WHERE maker IN (
     SELECT maker FROM (
       -- все выпускаемые производителем модели являются продуктами одного типа
       SELECT maker, COUNT(DISTINCT type) FROM product
       GROUP BY maker
       HAVING COUNT(DISTINCT type) = 1) T1  
     INTERSECT
     SELECT maker FROM (
       -- производители, которые выпускают более одной модели
       SELECT maker, COUNT(DISTINCT model) FROM product
       GROUP BY maker
       HAVING COUNT(DISTINCT model) > 1) T2 )


-- Задание: 41 (Serge I: 2019-05-31)
-- Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
определить максимальную цену на его продукцию.
Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
иначе максимальную цену.

WITH all_model AS (
SELECT model, price FROM pc
UNION
SELECT model, price FROM laptop
UNION
SELECT model, price FROM printer) 
SELECT maker, 
CASE 
WHEN COUNT(price) = COUNT(*) 
THEN MAX(all_model.price)  
END 
FROM all_model 
RIGHT JOIN product
on product.model = all_model.model
GROUP BY maker


-- Задание: 46 (Serge I: 2003-02-14)
-- Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.

SELECT ship, displacement, numGuns FROM Outcomes
LEFT JOIN ships
ON Outcomes.ship = Ships.name
LEFT JOIN classes
ON Ships.class= classes.class
   OR  Outcomes.ship = classes.class -- в той ситуации, когда в Outcomes имеется головной корабль, которого нет в Ships
WHERE battle = 'Guadalcanal'

Задание: 47 (Serge I: 2019-06-07)
Определить страны, которые потеряли в сражениях все свои корабли.

WITH 
ship_class_country AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		country 
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	UNION
	SELECT  
		o.ship    AS ship,
		c.class   AS class,
		c.country AS country
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class),
Sunk_ships_qt_by_country AS (
-- число потопленных кораблей по странам
	SELECT  
		country,
		COUNT(*) AS count
	FROM
		ship_class_country
	JOIN
		Outcomes
	ON 
		ship_class_country.ship = Outcomes.ship
	WHERE 
		result = 'sunk'
	GROUP BY  country),
ships_qt_by_country AS (
-- число кораблей по странам
	SELECT  
		ship_class_country.country AS country,
		COUNT(*)  AS count
	FROM 
		ship_class_country
	GROUP BY  country)

---------------------------------------------
SELECT  
	Sunk_ships_qt_by_country.country
FROM
	Sunk_ships_qt_by_country
JOIN
	ships_qt_by_country
ON Sunk_ships_qt_by_country.country = ships_qt_by_country.country
WHERE 
	Sunk_ships_qt_by_country.count = ships_qt_by_country.count


--48  Задание: 48 (Serge I: 2003-02-16)
-- Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.

WITH 
ship_class_outcome AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		result
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	JOIN
		Outcomes o
	ON o.ship = s.name	
	UNION
	
	SELECT  
		o.ship    AS ship,
		class,
		result
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class)

--------------------------------------------------------------------
SELECT  DISTINCT
	class
FROM
	ship_class_outcome
WHERE 
	result = 'sunk'

Задание: 49 (Serge I: 2003-02-17)
Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).

WITH 
ship_class_bore AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		bore
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	UNION
	SELECT  
		o.ship    AS ship,
		c.class   AS class,
		c.bore AS ore
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class)

--------------------------------------------------------------------
SELECT  
	ship
FROM
	ship_class_bore
WHERE 
	bore = 16
	

--Задание: 50 (Serge I: 2002-11-05)
-- Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

SELECT DISTINCT
	battle
FROM
	Outcomes
JOIN
	Ships
ON Outcomes.ship = Ships.name
WHERE 
        Ships.class = 'Kongo'


--- Задание: 51 (Serge I: 2003-02-17)
---Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей 
----такого же водоизмещения (учесть корабли из таблицы Outcomes).
WITH 
ship_class_guns_displ AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		numGuns,
		displacement
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	UNION
	SELECT  
		o.ship    AS ship,
		c.class   AS class,
		numGuns,
		displacement
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class),
ship_class_guns_displ_window AS (
	SELECT  
		*,
		MAX(numGuns) OVER (PARTITION BY displacement) AS max_guns
FROM
	ship_class_guns_displ)

--------------------------------------------------------------------
SELECT  
	ship
FROM
	ship_class_guns_displ_window
WHERE
        numGuns = max_guns
	
-- Задание: 52 (qwrqwr: 2010-04-23)
-- Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

SELECT 
	name 
FROM Ships
JOIN Classes
	ON Ships.class = Classes.class

WHERE 
	(type = 'bb' OR type IS Null) AND     --НЕ ИСПОЛЬЗУЕМ ДЛЯ ПОИСКА NULL =, ТОЛЬКО IS
	(country = 'Japan' OR country IS Null) AND
	(numGuns >= 9  OR numGuns IS Null) AND
	(bore < 19  OR bore IS Null) AND
	(displacement <= 65000 OR displacement IS Null)


-- Задание: 53 (Serge I: 2002-11-05)
-- Определите среднее число орудий для классов линейных кораблей.
Получить результат с точностью до 2-х десятичных знаков.

SELECT 
	CAST(AVG(numGuns *1.0) AS NUMERIC(4,2))
FROM
	Classes
WHERE
    type = 'bb'

-- Задание: 54 (Serge I: 2003-02-14)
-- С точностью до 2-х десятичных знаков определите среднее число орудий всех 
линейных кораблей (учесть корабли из таблицы Outcomes).

WITH 
ship_class_type_guns AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		type,
		numGuns
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	UNION
	SELECT  
		o.ship    AS ship,
		c.class   AS class,
		type,
		numGuns
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class)

--------------------------------------------------------------------
SELECT  
	CAST(AVG(numGuns *1.0) AS NUMERIC(4,2))
FROM
	ship_class_type_guns
WHERE
        type = 'bb'
-- агрегатные функции (за исключением функции COUNT, которая всегда возвращает целое число) наследуют тип данных обрабатываемых значени

-- Задание: 55 (Serge I: 2003-02-16)
Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

WITH 
clas_min_launched AS 
	(SELECT 
		class, 
		MIN(launched) AS minl
	FROM 
		ships
	GROUP BY class)
---------------------------------

SELECT 
	c.class, 
	clas_min_launched.minl
FROM 
	classes c
LEFT JOIN
	clas_min_launched
ON c.class = clas_min_launched.class


-- Задание: 56 (Serge I: 2003-02-16)
-- Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

-- FILTER не особо мачится с COUNT  https://modern-sql.com/feature/filter

WITH 
ship_class_outcome AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		result
	FROM 
		Ships s
	JOIN 
		Classes c
	ON s.class = c.class
	JOIN
		Outcomes o
	ON o.ship = s.name	
	UNION
	
	SELECT  
		o.ship    AS ship,
		class,
		result
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class
	)
	
--------------------------------------------------------------------
SELECT 
	classes.class,
	-- COUNT(ship_class_outcome.ship)  FILTER(WHERE result = 'sunk')
	SUM(CASE WHEN  result = 'sunk' THEN 1 ELSE 0 END) AS qty
FROM
	classes
LEFT JOIN	
	ship_class_outcome
ON classes.class  = ship_class_outcome.class

GROUP BY classes.class



-- Задание: 57 (Serge I: 2003-02-14)
Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, 
вывести имя класса и число потопленных кораблей.

WITH 
ship_class_outcome AS (
	SELECT  
		name AS ship,
		s.class   AS class,
		result
	FROM 
		Ships s
	JOIN  
		Classes c
	ON s.class = c.class
	JOIN
		Outcomes o
	ON o.ship = s.name	
	UNION
	
	SELECT  
		o.ship    AS ship,
		class,
		result
	FROM 
		Outcomes o
	JOIN 
		Classes c
	ON o.ship = c.class
	),
class_sunken AS(
	SELECT 
		classes.class AS class,
		-- COUNT(ship_class_outcome.ship)  FILTER(WHERE result = 'sunk')
		SUM(CASE WHEN  result = 'sunk' THEN 1 ELSE 0 END) AS qty
	FROM
		classes
	LEFT JOIN	
		ship_class_outcome
	ON classes.class  = ship_class_outcome.class

	GROUP BY classes.class
	HAVING SUM(CASE WHEN  result = 'sunk' THEN 1 ELSE 0 END) > 0
),
class_ship AS(
	SELECT 
		class,
		name AS ship
	FROM
		Ships
	UNION
	SELECT 
		ship AS class,
		ship 
	FROM 
		Outcomes
	WHERE ship not in (SELECT name FROM Ships)
),
class_qty_ship AS(
	SELECT 
		class,
		COUNT (ship) AS qty
	FROM
		class_ship
	GROUP BY class
	HAVING COUNT (ship) > 2
)
--------------------------------------------------------------------
SELECT 
	*
FROM 
	class_sunken
WHERE 
	class IN (SELECT class FROM class_qty_ship)

-- Задание: 58 (Serge I: 2009-11-13)
-- Для каждого типа продукции и каждого производителя из таблицы Product c точностью до двух десятичных знаков найти 
-- процентное отношение числа моделей данного типа данного производителя к общему числу моделей этого производителя.
-- Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя



-- не выводяться нули, го ниже просто заджойним с COALESCE
SELECT
	maker,
	type,
	CONVERT(NUMERIC(6,2), 	
		COUNT(model) OVER(PARTITION BY type, maker) *1.0  * 100 / 
		(COUNT(model) OVER(PARTITION BY maker) * 1.0)) as perc
FROM
	product

______________________________________________________________

WITH 
maker_type AS( -- декартово произведение
	SELECT DISTINCT
		p1.maker as maker,
		p2.type as type
	FROM
		Product AS p1
	CROSS JOIN
		Product AS p2	
),
perc AS(
	SELECT DISTINCT
		maker,
		type,
		CONVERT(NUMERIC(6,2), 	
			COUNT(model) OVER(PARTITION BY type, maker) *1.0  * 100 / 
			(COUNT(model) OVER(PARTITION BY maker) * 1.0)) as perc
	FROM
		product
)
------------------------------------------------------------------

SELECT
	mp.maker,
	mp.type,
	COALESCE(perc, 0)
FROM
	maker_type AS mp
LEFT JOIN
	perc
ON mp.maker = perc.maker AND
	mp.type = perc.type


-- Задание: 59 (Serge I: 2003-02-15)
-- Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.

--Использование значения NULL в условиях поиска http://www.sql-tutorial.ru/ru/book_using_null_in_search_conditions.html
-- COALESCE https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/COALESCE.html#GUID-3F9007A7-C0CA-4707-9CBA-1DBF2CDE0C87
WITH
point_income_o AS(
	SELECT 
		point,
		SUM(inc) AS inc
	FROM 
		Income_o
	GROUP BY point
),
point_outcome_o AS(
	SELECT 
		point,
		SUM(out) AS out
	FROM 
		Outcome_o
	GROUP BY point)	
-------------------------------------------------
SELECT
	point_income_o.point,
	COALESCE(inc, 0) - COALESCE(out, 0) AS balance
FROM
	point_income_o
FULL JOIN
	point_outcome_o
ON point_income_o.point = point_outcome_o.point

-- Задание: 60 (Serge I: 2003-02-15)
-- Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
-- Замечание. Не учитывать пункты, информации о которых нет до указанной даты.

WITH
point_income_o AS(
	SELECT 
		point,
		SUM(inc) AS inc
	FROM 
		Income_o
	WHERE date < '2001-04-15' 
	GROUP BY point
),
point_outcome_o AS(
	SELECT 
		point,
		SUM(out) AS out
	FROM 
		Outcome_o
	WHERE date < '2001-04-15' 
	GROUP BY point)	
-------------------------------------------------
SELECT
	point_income_o.point,
	COALESCE(inc, 0) - COALESCE(out, 0) AS balance
FROM
	point_income_o
FULL JOIN
	point_outcome_o
ON point_income_o.point = point_outcome_o.point

-- Задание: 61 (Serge I: 2003-02-14)
-- Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.

WITH
point_income_o AS(
	SELECT 
		point,
		SUM(inc) AS inc
	FROM 
		Income_o
	GROUP BY point
),
point_outcome_o AS(
	SELECT 
		point,
		SUM(out) AS out
	FROM 
		Outcome_o
	GROUP BY point)	
-------------------------------------------------
SELECT
	SUM(COALESCE(inc, 0)) - SUM(COALESCE(out, 0)) AS balance
FROM
	point_income_o
FULL JOIN
	point_outcome_o
ON point_income_o.point = point_outcome_o.point

-- Задание: 62 (Serge I: 2003-02-15)
-- Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных с отчетностью не чаще одного раза в день

WITH
point_income_o AS(
	SELECT 
		point,
		SUM(inc) AS inc
	FROM 
		Income_o
	WHERE date < '2001-04-15' 
	GROUP BY point
),
point_outcome_o AS(
	SELECT 
		point,
		SUM(out) AS out
	FROM 
		Outcome_o
	WHERE date < '2001-04-15' 
	GROUP BY point)	
-------------------------------------------------
SELECT
	SUM(COALESCE(inc, 0)) - SUM(COALESCE(out, 0)) AS balance
FROM
	point_income_o
FULL JOIN
	point_outcome_o
ON point_income_o.point = point_outcome_o.point


-- Задание: 63 (Serge I: 2003-04-08)
-- Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.

-- больше на 5 в пров базе
WITH 
psng_place AS(
	SELECT 
		p.ID_psg,
		p.name,
		pt.place
	FROM 
		Passenger AS p
	JOIN 
		Pass_in_trip AS pt
	ON
		p.ID_psg = pt.ID_psg
),
psng_place_qty AS(
	SELECT 
		ID_psg,
		name,
		place,
		COUNT(*) AS qty
	FROM 
		psng_place
	GROUP BY ID_psg, name, place
)
------------------------------------------------
SELECT
	name
FROM
	psng_place_qty
WHERE 
	qty > 1
_______________________________________________________________________

SELECT 
	name 
FROM 
	Passenger
WHERE ID_psg in
	(SELECT 
		ID_psg 
	FROM 
		Pass_in_trip
	GROUP BY place, ID_psg
	HAVING COUNT(*) > 1)

-- Задание: 64 (Serge I: 2010-06-04)
-- Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
-- Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.
-- ГОРДОСТЬ


WITH 
date_intersection AS(
	SELECT
		CONCAT(Income.point, Income.date) AS point_date
	FROM
		Income
	INNER JOIN
		Outcome
	ON Income.date = Outcome.date AND
    	Income.point= Outcome.point
)
---------------------------------------
SELECT 
	point,
	date,
	'inc' AS operation,
	SUM(inc) AS money_sum
FROM	
	Income
WHERE 
	CONCAT(Income.point, Income.date) NOT IN (SELECT point_date FROM date_intersection)
GROUP BY point, date

UNION

SELECT 
	point,
	date,
	'out' AS operation,
	SUM(out) AS money_sum
FROM	
	Outcome
WHERE 
	CONCAT(Outcome.point, Outcome.date) NOT IN (SELECT point_date FROM date_intersection)
GROUP BY point, date



-- Задание: 65 (Serge I: 2009-08-24)
-- Пронумеровать уникальные пары {maker, type} из Product, упорядочив их следующим образом:
-- - имя производителя (maker) по возрастанию;
-- - тип продукта (type) в порядке PC, Laptop, Printer.
-- Если некий производитель выпускает несколько типов продукции, то выводить его имя только в первой строке;
-- остальные строки для ЭТОГО производителя должны содержать пустую строку символов ('').
-- ГОРДОСТЬ


SELECT 
	ROW_NUMBER() OVER(ORDER BY maker, type_n) AS num, 
	CASE 
		WHEN maker = LAG(maker,1) OVER(ORDER BY maker, type_n)
		THEN ''
		ELSE maker
	END AS empy_maker,
	type
FROM 	
	(SELECT DISTINCT
		maker, 
		type,
		CASE 
			WHEN LOWER(type)='pc' then 1
            WHEN LOWER(type)='laptop' then 2
            ELSE 3
		END as type_n
	FROM 	
		product) t


-- Задание: 66 (Serge I: 2003-04-09)
-- Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov с пассажирами на борту.
-- Вывод: дата, количество рейсов.

WITH 
date_trip_qty AS(
	SELECT 
		date,
		COUNT(DISTINCT Pass_in_trip.trip_no) AS qty
	FROM
		Pass_in_trip
	JOIN
		Trip
	ON Pass_in_trip.trip_no = Trip.trip_no
	WHERE 
		town_from = 'Rostov'
	GROUP BY 
		date ),
date_series AS(
	SELECT generate_series(
		'2003-04-01 00:00:00'::timestamp, 
		'2003-04-07 00:00:00'::timestamp, 
		'1 day') AS date)
--------------------------	
SELECT 
	date_series.date,
	COALESCE(qty, 0)
FROM
	date_series
LEFT JOIN	
	date_trip_qty
ON date_series.date = date_trip_qty.date

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


-- Задание: 67 (Serge I: 2010-03-27)
-- Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
-- Замечания.
-- 1) A - B и B - A считать РАЗНЫМИ маршрутами.
-- 2) Использовать только таблицу Trip
-- ГОРДОСТЬ
WITH
qty_trip AS(
	SELECT	
		CONCAT(town_from, town_to) AS route,
		COUNT (trip_no) AS qty
	FROM
		Trip
	GROUP BY CONCAT(town_from, town_to)
)
-----------------------------------
SElECT
	COUNT(*)
FROM 
	qty_trip
WHERE 
	qty = (SELECT MAX(qty) FROM qty_trip)

-- Задание: 68 (Serge I: 2010-03-27)
-- Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
-- Замечания.
-- 1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.
-- 2) Использовать только таблицу Trip

WITH
qty_trip AS(
	SELECT	
		CASE 
			WHEN town_from < town_to
			THEN CONCAT(town_from, town_to)
			ELSE CONCAT(town_to, town_from)
		END AS route,
		COUNT (trip_no) AS qty
	FROM
		Trip
	GROUP BY route
)
-----------------------------------
SElECT
	COUNT(*)
FROM 
	qty_trip
WHERE 
	qty = (SELECT MAX(qty) FROM qty_trip)

-- Задание: 69 (Serge I: 2011-01-06)
-- По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня,
-- в который выполнялись операции по приходу и/или расходу на данном пункте.
-- Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
-- Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня.


НЕПОНЯТНЫЕ ОШИБКИ РЯДОМ С 18 СТРОКОЙ
WITH 
point_date AS(
	SELECT DISTINCT
		point,
		date
	FROM Income
	UNION
	SELECT DISTINCT
		point,
		date
	FROM Outcome
),
point_date_inc AS(
	SELECT
		point, 
		date,
		SUM(inc) AS inc
	FROM	
		Income 
	GROUP BY 
		point,
		date
),
point_date_out AS(
	SELECT
		point, 
		date,
		SUM(out) AS inc
	FROM	
		Outcome 
	GROUP BY 
		point,
		date
),
point_date_inc_out AS(
	SELECT
		point_date.point, 
		point_date.date,
		COALESCE(inc, 0),
		COALESCE(out, 0)
	FROM
		point_date
	LEFT JOIN	
		Outcome
		ON point_date.point =  Outcome.point AND
		point_date.date =  Outcome.date 
	LEFT JOIN	
		Income
		ON point_date.point =  Income.point AND
		point_date.date =  Income.date 
)

---------------------------------------
SELECT 
	point,
	date,

	-- inc - out AS diff,
	SUM(inc - out) OVER (PARTITION BY pointF ORDER BY pointF, dateF
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
FROM 
	point_date_inc_out
____________________________________________________________________________

-- CONVERT https://www.sqlshack.com/sql-convert-date/
-- СТИЛИ для https://learn.microsoft.com/ru-ru/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16

WITH 
point_date AS(
	SELECT 
		point,
		date,
		inc as flow,
		'income' AS operation
	FROM Income
	UNION ALL
	SELECT 
		point,
		date,
		-out as flow,
		'Outcome' AS operation
	FROM Outcome),
point_date_flow AS(
	SELECT 
		point,
		date,
		SUM(flow) flow
	FROM point_date
	GROUP BY point, date
)
SELECT 
	point,
	CONVERT( nvarchar(30), date, 103) AS day,
	SUM(flow) OVER (PARTITION BY point ORDER BY point, date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
FROM 
	point_date_flow

-- Задание: 70 (Serge I: 2003-02-14)
-- Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны.

SELECT  DISTINCT
	battle
FROM 
	Outcomes o
LEFT JOIN 
	Ships s
ON o.ship = s.name 	
	
JOIN 
	Classes c

ON o.ship = c.class OR	
	s.class = c.class
GROUP BY battle, country
HAVING COUNT(o.ship) > 2


Задание: 71 (Serge I: 2008-02-23)
Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.


SElECT	
	maker
	-- COUNT(Product.model) qtyPr,
	-- COUNT(PC.model) qtyPC
FROM
	Product  
LEFT JOIN
	PC
ON 	Product.model = PC.model
WHERE 
	type = 'PC'  
GROUP BY maker
HAVING 
	COUNT(Product.model) <= COUNT(PC.model) 
	 
-- http://www.sql-tutorial.ru/ru/book_relational_division.html - ну не знаю
	
	

Задание: 72 (Serge I: 2003-04-29)
Среди тех, кто пользуется услугами только какой-нибудь одной компании, определить имена разных пассажиров, летавших чаще других.
Вывести: имя пассажира и число полетов.

WITH psg_comp_trips as
	(SELECT 
		ID_psg,
		ID_comp,
		COUNT(pt.trip_no) as trips
	FROM 	
		Pass_in_trip AS pt
	JOIN
		Trip AS t
	ON pt.trip_no = t.trip_no
		GROUP BY
	ID_psg,
	ID_comp),
	
psg_one_love_comp_trips AS
	(SElECT
		ID_psg,
		SUM(trips) as trips
	FROM
		psg_comp_trips
	GROUP BY ID_psg
	HAVING COUNT(ID_comp) = 1 )
-----------------------------------------------------
SElECT
	name,
	trips
FROM
	psg_one_love_comp_trips
JOIN
	Passenger
ON psg_one_love_comp_trips.ID_psg = Passenger.ID_psg 

WHERE trips = (SELECT MAX(trips) FROM psg_one_love_comp_trips)

	
Задание: 73 (Serge I: 2009-04-17)
Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
Вывод: страна, сражение


WITH battle_country AS(
	SELECT  DISTINCT
		country,
		battle
	FROM 
		Outcomes o
	LEFT JOIN 
		Ships s
	ON o.ship = s.name 	
		
	JOIN 
		Classes c

	ON o.ship = c.class OR	
		s.class = c.class
	GROUP BY battle, country)
------------------------------------------------------------
SELECT 
	country,
	name
FROM 
	Classes
CROSS JOIN
	Battles
	
EXCEPT 

SELECT  DISTINCT
	country,
	battle
FROM 
	Outcomes o
LEFT JOIN 
	Ships s
ON o.ship = s.name 	
	
JOIN 
	Classes c
ON o.ship = c.class OR	
	s.class = c.class
GROUP BY battle, country

-- Задание: 74 (dorin_larsen: 2007-03-23)
-- Вывести все классы кораблей России (Russia). Если в базе данных нет классов кораблей России, вывести классы для всех имеющихся в БД стран.
Вывод: страна, класс

SELECT 
	country, class
FROM 
	Classes
WHERE country =
	CASE 
		WHEN 'Russia' IN(SELECT country FROM Classes)
		THEN 'Russia'
		ELSE country
	END
	
	
-- Задание: 75 (Serge I: 2020-01-31)
-- Для тех производителей, у которых есть продукты с известной ценой хотя бы в одной из таблиц Laptop, PC, Printer найти максимальные цены на каждый из типов продукции.
-- Вывод: maker, максимальная цена на ноутбуки, максимальная цена на ПК, максимальная цена на принтеры.
-- Для отсутствующих продуктов/цен использовать NULL.

WITH all_prices AS (
SELECT 
	maker, 
	pc.price as pc_price, 
	Laptop.price as Laptop_price, 
	Printer.price as Printer_price
FROM product
LEFT JOIN pc
	ON product.model = pc.model
LEFT JOIN Laptop
	ON product.model = Laptop.model
LEFT JOIN Printer
	ON product.model = Printer.model)

SELECT 
	maker, 
    MAX(Laptop_price) as laptop,
	MAX(pc_price) as pc,
	MAX(Printer_price) as printer
FROM all_prices
GROUP BY maker
HAVING 
	MAX(Laptop_price) IS NOT NULL OR
	MAX(pc_price) IS NOT NULL OR
	MAX(Printer_price) IS NOT NULL
	
-- Задание: 76 (Serge I: 2003-08-28)
-- Определить время, проведенное в полетах, для пассажиров, летавших всегда на разных местах. Вывод: имя пассажира, время в минутах.

WITH 
pass_seats_same_place AS(
	SElECT	
		ID_psg,
		place,
		COUNT(trip_no) qty
	FROM 
		Pass_in_trip
	GROUP by
		ID_psg,
		place
	HAVING 
		COUNT(trip_no) > 1),
pass_seats_same_place_time AS(
	SElECT
		ID_psg,
		SUM(DATEDIFF(
			minute, 
			time_out, 
			CASE
				WHEN time_in > time_out THEN time_in
				ELSE DATEADD(day, 1, time_in)
			END)) AS time_f	
	FROM 
		Pass_in_trip
	JOIN 
		Trip
	ON Pass_in_trip.trip_no = Trip.trip_no
	WHERE 
		ID_psg NOT IN (SELECT ID_psg FROM pass_seats_same_place)
	GROUP BY ID_psg)
------------------------------------------
SELECT
	name,
	time_f
FROM
	pass_seats_same_place_time
JOIN
	Passenger
ON 
pass_seats_same_place_time.ID_psg = Passenger.ID_psg

-- Задание: 77 (Serge I: 2003-04-09)
-- Определить дни, когда было выполнено максимальное число рейсов из
-- Ростова ('Rostov'). Вывод: число рейсов, дата.

WITH 
date_trip_qty AS(
	SELECT DISTINCT
		COUNT(DISTINCT Trip.trip_no) AS qty,
		[date]
	FROM 
		Pass_in_trip
	JOIN
		Trip
	ON Pass_in_trip.trip_no = Trip.trip_no
	WHERE town_from = 'Rostov'
	GROUP BY [date])
-----------------------------------------------
SELECT
	*
FROM
	date_trip_qty
WHERE qty = (SELECT MAX(qty) FROM date_trip_qty)

-- Задание: 78 (Serge I: 2005-01-19)
-- Для каждого сражения определить первый и последний день
-- месяца,
-- в котором оно состоялось.
-- Вывод: сражение, первый день месяца, последний
-- день месяца.
-- Замечание: даты представить без времени в формате "yyyy-mm-dd".

SELECT
	name,
	DATEFROMPARTS(
			DATEPART(year, [date]), 
			DATEPART(month, [date]), 
			1) AS firstD,
	DATEADD(day, -1, -- посл день тек мес - это первый день следующего месяца -1 день
		DATEFROMPARTS( ---  первый день следующего месяца
			DATEPART(-- год не можем взять тем же, тк не учитывается возможный переход на сл. год)
				year,
				DATEADD(month, 1,[date])),
			DATEPART(
				month,
				DATEADD(month, 1,[date])), 
				1)
		
	)AS lastD
					
FROM
	Battles

-- conver data syles 
-- https://learn.microsoft.com/ru-ru/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16

-- Задание: 79 (Serge I: 2003-04-29)
-- Определить пассажиров, которые больше других времени провели в полетах.
-- Вывод: имя пассажира, общее время в минутах, проведенное в полетах
WITH 
pass_time_f AS(
	SELECT
		Pass_in_trip.ID_psg,
		SUM(DATEDIFF(
				minute, 
				time_out, 
				CASE
					WHEN time_in > time_out THEN time_in
					ELSE DATEADD(day, 1, time_in)
				END)) AS time_f	
	FROM
		Pass_in_trip
	JOIN
		Trip
	ON Pass_in_trip.trip_no = Trip.trip_no
	GROUP BY Pass_in_trip.ID_psg)
-------------------------------------------------------------------
SELECT
	COALESCE(name, 'unkonown name') AS name,
	time_f
FROM
	Passenger
RIGHT JOIN
	pass_time_f
ON pass_time_f.ID_psg = Passenger.ID_psg
WHERE
	time_f = (SELECT MAX(time_f) FROM pass_time_f)

-- Задание: 80 (Baser: 2011-11-11)
-- Найти производителей любой компьютерной техники, у которых нет моделей ПК, не представленных в таблице PC

SELECT 
	maker
FROM	
	product
EXCEPT
SELECT 
	maker
FROM	
	product
	WHERE type = 'PC' AND model NOT IN(
		SELECT model FROM PC)

-- Задание: 81 (Serge I: 2011-11-25)
-- Из таблицы Outcome получить все записи за тот месяц (месяцы), с учетом года, в котором суммарное значение расхода (out) было максимальным.
---меньше на 11 запис , у мня учтен только 1 месяц
WITH 
month_out AS(
	SELECT
		SUM(out) AS out,
		DATEFROMPARTS(
			DATEPART(year, [date]),
			DATEPART(month, [date]),
			1
		) AS month
	FROM
		Outcome
	GROUP BY DATEFROMPARTS(
			DATEPART(year, [date]),
			DATEPART(month, [date]),
			1
		)
)
----------------------------------------------------
SELECT
	*
FROM
	Outcome
WHERE 
	DATEPART(year, [date]) = DATEPART(year, (
		SELECT month FROM month_out
		WHERE 
			out = (SELECT MAX(out) FROM month_out))) AND
	DATEPART(month, [date]) = DATEPART(month, (
		SELECT month FROM month_out
		WHERE 
			out = (SELECT MAX(out) FROM month_out)))
_______________________________________________________________________________________	
-- мб несколько месяцев
WITH 
month_out AS(
	SELECT
		SUM(out) AS out,
		DATEFROMPARTS(
			DATEPART(year, [date]),
			DATEPART(month, [date]),
			1
		) AS month
	FROM
		Outcome
	GROUP BY DATEFROMPARTS(
			DATEPART(year, [date]),
			DATEPART(month, [date]),
			1
		)
)
----------------------------------------------------
SELECT
	*
FROM
	Outcome
WHERE 
	DATEFROMPARTS(
		DATEPART(year, [date]),
		DATEPART(month, [date]),
		1
	)
	IN (
		SELECT month FROM month_out
		WHERE out = (SELECT MAX(out) FROM month_out))

-- Задание: 82 (Serge I: 2011-10-08)
-- В наборе записей из таблицы PC, отсортированном по столбцу code (по возрастанию) найти среднее значение цены для каждой шестерки подряд идущих ПК.
-- Вывод: значение code, которое является первым в наборе из шести строк, среднее значение цены в наборе


-- МНЕ КАЖЕТСЯ НА САЙТЕ ОШИБКА
-- Результаты выполнения
-- Вашего запроса:
 	

-- first_code	
-- 1	783.3333
-- 7	566.6666

--  правильного запроса:	
-- code	avgprс
-- 1	783.3333
-- 2	750.0000
-- 3	666.6666
-- 4	625.0000
-- 5	541.6666
-- 6	563.3333
-- 7	566.6666

вот МОЕ ПРАВИЛЬНОЕ РЕШЕНИЕ
_________________________________________
WITH 
PC_group AS(
	SELECT
		NTILE((SELECT COUNT(*) FROM PC)/6) OVER(ORDER BY code) AS gr_n,
		*
	FROM 
		PC
),
PC_qroup_first_code AS( ------жаль, что нельзя в PARTION BY обратитца к другому окну
	SELECT
		MIN(code) OVER(PARTITION BY gr_n) AS first_code,
		*
	FROM 
		PC_group
)
-------------------------------------------
SELECT
	first_code,
	AVG (price) as avg_price
FROM 
	PC_qroup_first_code
GROUP BY 
	first_code

-- Задание: 83 (dorin_larsen: 2006-03-14)
-- Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере, комбинации любых четырёх критериев из следующего списка:
-- numGuns = 8
-- bore = 15
-- displacement = 32000
-- type = bb
-- launched = 1915
-- class=Kongo
-- country=USA

-- ГОРДОСТЬ

SELECT
	name
FROM
	Ships
JOIN
	Classes
ON Ships.class = Classes.class
WHERE
	4 <= 
		CASE	
			WHEN numGuns = 8 THEN 1
			ELSE 0
		END +
		CASE	
			WHEN bore = 15 THEN 1
			ELSE 0
		END +
		CASE	
			WHEN displacement = 32000 THEN 1
			ELSE 0
		END +
		CASE	
			WHEN type = 'bb' THEN 1
			ELSE 0
		END +			
		CASE	
			WHEN launched = 1915 THEN 1
			ELSE 0
		END +
		CASE	
			WHEN Ships.class = 'Kongo' THEN 1
			ELSE 0
		END +
		CASE	
			WHEN country = 'USA' THEN 1
			ELSE 0
		END 


-- Задание: 84 (Serge I: 2003-06-05)
-- Для каждой компании подсчитать количество перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003. При этом учитывать только дату вылета.
-- Вывод: название компании, количество пассажиров за каждую декаду

-- ГОРДОСТЬ
WITH 
comp_pass_by_decades AS(
	SElECT 
		Company.name,
		date,
		COUNT(Pass_in_trip.ID_psg) as total,
		CASE
			WHEN date BETWEEN '2003-04-01 00:00:00' AND '2003-04-10 23:59:59'
			THEN COUNT(Pass_in_trip.ID_psg)
			ELSE 0
		END AS qty_1_10,
		CASE
			WHEN date BETWEEN '2003-04-11 00:00:00' AND '2003-04-20 23:59:59'
			THEN COUNT(Pass_in_trip.ID_psg)
			ELSE 0
		END AS qty_11_20,
		CASE
			WHEN date BETWEEN '2003-04-21 00:00:00' AND '2003-04-30 23:59:59'
			THEN COUNT(Pass_in_trip.ID_psg)
			ELSE 0
		END AS qty_21_30
	FROM
		Company
	JOIN	
		Trip
	ON Company.ID_comp = Trip.ID_comp
	JOIN
		Pass_in_trip
	ON 
		Trip.trip_no = Pass_in_trip.trip_no
	WHERE 
		date BETWEEN '2003-04-01 00:00:00' AND '2003-04-30 23:59:59'
	GROUP BY 
		Company.name,
		date)
------------------------------------------------------
SELECT
	name,
	SUM(qty_1_10) AS qty_1_10,
	SUM(qty_11_20) AS qty_11_20,
	SUM(qty_21_30) AS qty_21_30
FROM
	comp_pass_by_decades
GROUP BY
	name










-- Задание: 89 (Serge I: 2012-05-04)
-- Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей.
Вывод: maker, число моделей

WITH 
maker_model_qty AS
	(SELECT
	  maker,
	  COUNT(model) as qty
	FROM 
	  Product
	GROUP BY 
	  maker)
--------------------------------------------
SELECT
	maker,
	qty
FROM 
	maker_model_qty
WHERE
	qty = (SELECT MAX(qty) FROM maker_model_qty) OR
	qty = (SELECT MIN(qty) FROM maker_model_qty)
	






-- Задание: 92 (ZrenBy: 2003-09-01)
-- Выбрать все белые квадраты, которые окрашивались только из баллончиков,
-- пустых к настоящему времени. Вывести имя квадрата

WITH 
---ID полностью окрашенных квадратов
ID_full_painted_Q AS
	(SELECT 
		B_Q_ID,
		SUM(B_VOL) V
	FROM
		utB
	GROUP BY 
		B_Q_ID
	HAVING
		SUM(B_VOL) = 255 * 3),
--- ID пустых баллончиков
ID_empty_bottle AS
	(SELECT
		B_V_ID,
		SUM(B_VOL)V
	FROM
		utB
	GROUP BY 
		B_V_ID
	HAVING
		SUM(B_VOL) = 255),

--- ID нужных нам квардатов
ID_Q_we_need AS
	(SELECT DISTINCT
		B_Q_ID
	FROM
		utB
	WHERE 
		B_Q_ID IN (SELECT B_Q_ID FROM ID_full_painted_Q) AND
		B_V_ID IN (SELECT B_V_ID FROM ID_empty_bottle)
		
	EXCEPT

	SELECT DISTINCT
		B_Q_ID
	FROM
		utB
	WHERE 
		B_Q_ID IN (SELECT B_Q_ID FROM ID_full_painted_Q) AND
		B_V_ID NOT IN (SELECT B_V_ID FROM ID_empty_bottle))
-------------------------------------------------------------
SELECT 
	Q_NAME
FROM
	utQ
WHERE 
	Q_ID IN (SELECT B_Q_ID FROM ID_Q_we_need)

	
	
-- 92 С помщую оконных Функций

WITH 
---полная таблица с тотал потраченной краски по квадратам и балончикам
total AS
	(SELECT 
		B_Q_ID, 
		Q_NAME,
		B_DATETIME, 
		B_VOL,
		SUM(B_VOL) OVER (PARTITION BY B_Q_ID) AS total_Q_VOL,
		SUM(B_VOL) OVER (PARTITION BY B_V_ID) AS total_V_VOL
	FROM utB
	JOIN
		utQ
	ON
		utB.B_Q_ID = utQ.Q_ID)
-----------------------------------------
SELECT DISTINCT 
	Q_NAME
FROM
	total
WHERE
	total_Q_VOL = 255 * 3 AND
	total_V_VOL = 255
	
EXCEPT

SELECT DISTINCT 
	Q_NAME
FROM
	total
WHERE
	total_Q_VOL = 255 * 3 AND
	total_V_VOL < 255
	



-- ОКОННЫЕ ФУНКЦИИ (отработка в задаче 106)
-- https://youtu.be/Y03xFWa9yGU

SELECT 
	B_Q_ID, 
	B_DATETIME, 
	ROW_NUMBER() OVER (PARTITION BY B_Q_ID ORDER BY B_DATETIME) AS N,
	B_VOL,
	SUM(B_VOL) OVER (PARTITION BY B_Q_ID ORDER BY B_DATETIME ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumul_Q_VOL,
	SUM(B_VOL) OVER (PARTITION BY B_Q_ID) AS total_Q_VOL,
	LAG (B_VOL, 1) OVER (PARTITION BY B_Q_ID ORDER BY B_DATETIME) AS prev,
	LEAD (B_VOL, 1) OVER (PARTITION BY B_Q_ID ORDER BY B_DATETIME) AS nxt
FROM utB

	
	
	
	
	
	
	
	
	



-- Задание: 105 (qwrqwr: 2013-09-11)
-- Статистики Алиса, Белла, Вика и Галина нумеруют строки у таблицы Product.
Все четверо упорядочили строки таблицы по возрастанию названий производителей.
Алиса присваивает новый номер каждой строке, строки одного производителя она упорядочивает по номеру модели.
Трое остальных присваивают один и тот же номер всем строкам одного производителя.
Белла присваивает номера начиная с единицы, каждый следующий производитель увеличивает номер на 1.
У Вики каждый следующий производитель получает такой же номер, какой получила бы первая модель этого производителя у Алисы.
Галина присваивает каждому следующему производителю тот же номер, который получила бы его последняя модель у Алисы.
Вывести: maker, model, номера строк получившиеся у Алисы, Беллы, Вики и Галины соответственно
WITH range_table AS (
SELECT 
	maker,
	model,
	ROW_NUMBER() OVER(ORDER BY maker, model) as A,
	DENSE_RANK() OVER(ORDER BY maker) as B,
	RANK() OVER(ORDER BY maker) as C
FROM Product)
---------------------------------------------------
SELECT 
	*,
	MAX(A) OVER (PARTITION BY maker) as D
FROM range_table
ORDER BY maker


-- Задание: 116 (Velmont: 2013-11-19)
-- Считая, что каждая окраска длится ровно секунду, определить непрерывные интервалы времени с длительностью более 1 секунды из таблицы utB.
Вывод: дата первой окраски в интервале, дата последней окраски в интервале.


-- Задание: 126 (Serge I: 2015-04-17)
-- Для последовательности пассажиров, упорядоченных по id_psg, определить того,
кто совершил наибольшее число полетов, а также тех, кто находится в последовательности непосредственно перед и после него.
Для первого пассажира в последовательности предыдущим будет последний, а для последнего пассажира последующим будет первый.
Для каждого пассажира, отвечающего условию, вывести: имя, имя предыдущего пассажира, имя следующего пассажира.
 
WITH pass_trip_np AS ( 
--почти готовая расширенная таблица, которую остается подрезать  и скорректировать next&prev для первого и последнего id
SELECT 
  Passenger.ID_psg,
  name, 
  COUNT(trip_no) AS trp_qty,
  LAG(name, 1) OVER (ORDER by Passenger.ID_psg) AS prev,
  LEAD(name, 1) OVER (ORDER by Passenger.ID_psg) AS nxt
FROM 
  Passenger
LEFT JOIN Pass_in_trip
ON Passenger.ID_psg = Pass_in_trip.ID_psg
GROUP BY Passenger.ID_psg, name)

--------------------------------------------------------
SELECT 
  name, 
  COALESCE(prev, (SELECT name FROM Passenger WHERE id_psg =                            ---аналог ЕСЛИОШИБКА для пустых значений
    (SELECT MAX(ID_psg) FROM Passenger))) prev, -- ID последнее
  COALESCE(nxt, (SELECT name FROM Passenger WHERE id_psg = 
    (SELECT MIN(ID_psg) FROM Passenger))) nxt -- ID первое
FROM pass_trip_np
  WHERE trp_qty = (SELECT MAX(trp_qty) FROM pass_trip_np)

















-- Задание: 138 (Kursist: 2021-10-15)
-- Выведите имена пассажиров, которые побывали в наибольшем количестве разных городов, включая города отправления.

!!!  СРЕДИ ПАССАЖИРОВА МОГУТ БЫТЬ ОДНОфАМИЛЬЦЫ
WITH town_pass AS (

SELECT DISTINCT
  Passenger.ID_psg AS ID, 
  name, 
  town_to AS town 
FROM Passenger
INNER JOIN Pass_in_trip
-- USING (ID_psg) хз что не так
  ON Passenger.ID_psg = Pass_in_trip.ID_psg
INNER JOIN Trip
  ON Trip.trip_no = Pass_in_trip.trip_no

UNION

SELECT DISTINCT 
  Passenger.ID_psg AS ID,
  name, 
  town_FROM AS town 
FROM Passenger
INNER JOIN Pass_in_trip
-- USING (ID_psg) хз что не так
  ON Passenger.ID_psg = Pass_in_trip.ID_psg
INNER JOIN Trip
  ON Trip.trip_no = Pass_in_trip.trip_no),

town_pass_pivot AS (
SELECT 
  ID,
  name, 
  COUNT(town) AS town_qty
FROM
  town_pass 
GROUP BY 
  ID,
  name)

SELECT 
  name 
FROM  
  town_pass_pivot
WHERE 
  town_qty = (SELECT MAX(town_qty) FROM town_pass_pivot)

SELECT DISTINCT product.model, 
 CASE 
 WHEN price IS NULL 
 THEN 'Нет в наличии' 
 ELSE CAST(price AS CHAR(20)) 
 END price 
FROM Product LEFT JOIN 
 PC ON Product.model = PC.model
WHERE product.type = 'pc';

--Задание: 147 (Serge I: 2011-02-11)
--Пронумеровать строки из таблицы Product в следующем порядке: имя производителя в порядке убывания числа производимых им моделей 
(при одинаковом числе моделей имя производителя в алфавитном порядке по возрастанию), номер модели (по возрастанию).
Вывод: номер в соответствии с заданным порядком, имя производителя (maker), модель (model)

WITH 
window_qty_mod AS
	(SELECT
		*,
		COUNT(*) OVER(PARTITION BY maker) AS qty
	FROM
		Product)
--------------------
SELECT
	ROW_NUMBER() OVER(ORDER BY qty DESC, maker, model),
	maker,
	model
FROM
	window_qty_mod


-- Задание: 157 (Kursist: 2021-09-17)
-- Для всех непотопленных кораблей из базы определить количество битв, в которых они участвовали.
-- Вывести название корабля, количество битв.

-- ВОБЩЕ НЕ ПОХОЖЕ НА ЗАДАНИЕ 4 СЛОЖНОСТИ
WITH 
ship_battles_qty AS(
	SElECT
		ship,
		COUNT(battle) qty
	FROM
		Outcomes
	GROUP BY ship),

ships_without_sunk AS(
	SELECT 
		ship
	FROM
		Outcomes
	UNION
	SElECT	
		name
	FROM
		Ships
	EXCEPT
	SElECT
		ship
	FROM
		Outcomes
	WHERE 
		result =  'sunk')
------------------------------------------------
SELECT 
	ships_without_sunk.ship,
	COALESCE(qty, 0)
FROM
	ships_without_sunk
LEFT JOIN
	ship_battles_qty
ON ships_without_sunk.ship = ship_battles_qty.ship


-- Задание: 159 (Baser: 2021-02-26)
-- Для каждой окраски (t,q,v,vol) = (B_DATETIME,B_Q_ID,B_V_ID,B_VOL) определить предшествующую по времени окраску того же квадрата тем же баллончиком и вывести в таблицу (t,q,v,vol,tp,volp).
-- Если такой окраски не было, то установить для предыдущей tp = volp = NULL.

-- НУ ЯВНО НЕ 4 СЛОЖНОСТЬ, ЕСТЬ И ПОСЛОЖНЕЕ ЗАДАЧИ
SELECT 
	* ,
	LAG(B_DATETIME) OVER (PARTITION BY B_Q_ID, B_V_ID ORDER BY B_DATETIME) as prev_t,
	LAG(B_VOL) OVER (PARTITION BY B_Q_ID, B_V_ID ORDER BY B_DATETIME) as prev_vol
FROM 
	utB
