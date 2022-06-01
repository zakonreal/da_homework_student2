-- lesson3

--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class

with t1 as
( 
 select t0.name, class from
  (select ship as name from outcomes
    union
  select name from ships) as t0  
  left join ships
  on t0.name = ships.name
   )
  
   select name,
   case 
   	when class is null then '0'
   	else cast(class as char(20))
   end t1_class
   from t1
   
   --task16
   --Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

with t_b as
(select name, cast(date as char(4)) from battles),
t_sh as
(select cast(launched as char(4)) from ships)

select distinct name from t_b
where date not in (select launched from t_sh)



-- домашнее задание №2

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with t1 as
(select ship, class
from outcomes
left join ships
on ship=name
where result = 'sunk')

select cl.class, count(t1.ship)
from classes cl
left join t1
on cl.class=t1.class or cl.class = t1.ship

group by cl.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
-- Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select cl.class, min(sh.launched)
from classes cl
left join ships sh
on cl.class=sh.class
group by cl.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with t2 as 
(select ship, 
case when result = 'sunk' then 1
end out1 
from outcomes
) -- âûäåëÿåì êîðàáëè, êîòîðûå ïîòîíóëè
 
select cl.class, sum(out1) out_1 from classes cl
left join ships sh 
on cl.class = sh.class
left join (select ship, out1 from t2 where out1=1) as ta2
on cl.class = ta2.ship or sh.name = ta2.ship 

group by cl.class
having count(cl.class)>2 and sum(out1) is not null

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with t3 as 
(
select ou.ship, numguns, displacement
FROM outcomes ou
join classes cl
on ou.ship = cl.class and ou.ship not in (select name from ships)

union

select sh.name, numguns, displacement
from ships sh
join classes cl 
on sh.class = cl.class
),

t4 as 
(
select max(numguns), displacement
from outcomes ou
join classes cl 
on ou.ship = cl.class and ou.ship not in (select name from ships)
group by displacement

union

select max(numguns), displacement
from ships sh
join classes cl 
on sh.class = cl.class
group by displacement
)

select ship as name from t3
join t4
on t3.numguns = t4.max and t3.displacement = t4.displacement


--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM
-- и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with t7 as
(
select maker from 
(select model, max(speed)
 from pc
where ram = (select min(ram) from pc)
group by model) as tt
join product pr
on tt.model=pr.model
),

t8 as
(
select maker from product pr
join printer pri
on pr.model=pri.model
)

select distinct t7.maker from t7
join t8
on t7.maker = t8.maker


