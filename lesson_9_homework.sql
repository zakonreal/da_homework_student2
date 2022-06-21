--task5 (lesson9)
-- Компьютерная фирма: Найти максимальную, минимальную и среднюю цену на персональные компьютеры при условии,
-- что средняя цена не превышает 600

select max(price), min(price), avg(price)
from pc
having avg(price) <= 600


--task6 (lesson9)
-- Компьютерная фирма: Получить количество ПК и среднюю цену для каждой модели, средняя цена которой менее 800

select model, count(model), avg(price) from pc
group by model
having avg(price) < 800


--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
 case
 when Grades.Grade > 7 then Students.Name
 end,
Grades.Grade, Students.Marks 
from Students 
join Grades
on Students.Marks between Grades.Min_Mark and Max_Mark
order by Grades.Grade desc, Students.Name;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

with qwer as
(
select Doctor, Professor, Singer, Actor from
(select Doctor,
row_number() over(order by Doctor) as rn1
from
(select
 case when Occupation = 'Doctor' then name end Doctor
 from Occupations) t1) a
join 
(select Professor,
row_number() over(order by Professor) as rn2
from
(select
 case when Occupation = 'Professor' then name end Professor
 from Occupations) t2) b
on rn1=rn2
join
(select Singer,
row_number() over(order by Singer) as rn3
from
(select
 case when Occupation = 'Singer' then name end Singer
 from Occupations) t3) c
 on rn1=rn3
 join
(select Actor,
row_number() over(order by Actor) as rn4
from
(select
 case when Occupation = 'Actor' then name end Actor
 from Occupations) t4) d
 on rn1=rn4
)
select Doctor, Professor, Singer, Actor from qwer
where Professor is not null or Actor is not null or Doctor is not null or Singer is not null
;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city from station
where not (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from station
where not (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from station
where city not in (select city from station where (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%')
and (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'));

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from station
where not (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%')
and not (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from employee
where salary>2000 and months<10;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
 case
 when Grades.Grade > 7 then Students.Name
 end,
Grades.Grade, Students.Marks 
from Students 
join Grades
on Students.Marks between Grades.Min_Mark and Max_Mark
order by Grades.Grade desc, Students.Name;