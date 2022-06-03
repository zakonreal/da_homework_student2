-- �������� ������� �3


--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

select model, maker, type from product order by maker

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select * ,
case when price > (select avg(price) from printer) then 1
else 0
end price_avg
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

select name from ships where class is null

 select t.name, class from
  (select ship as name from outcomes
    union
  select name from ships) as t  
  left join ships
  on t.name = ships.name
  where class is null
   
  
--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.

with t_b as
(select name, cast(date as char(4)) from battles),
t_sh as
(select cast(launched as char(4)) from ships)

select distinct name from t_b
where date not in (select launched from t_sh)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select battle
from outcomes 
join ships   
on ship = name
where class = 'Kongo'

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300.
-- �� view ��� �������: model, price, flag


create view all_products_flag_300 as 
with t1 as 
(
select pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model,price,
case when price>300 then '+'
end flag_300
from t1

select * from all_products_flag_300

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������,
-- ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

create view all_products_flag_avg_price as 
with t2 as 
(
select pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model,price,
case when price> (select avg(price) from t2) then '+'
end flag_avg
from t2

select * from all_products_flag_avg_price

--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with t2 as
(
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
)
select model from t2
where price > (select avg(price) from t2 where maker in ('D','C') )


--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with t3 as 
(
select maker, pr.model,price from product pr
join pc
on pr.model=pc.model 
union
select maker, pr.model,price from product pr
join laptop l
on pr.model=l.model 
union 
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
),
t4 as 
(
select maker, pr.model,price from product pr
join printer pri
on pr.model=pri.model
)

select model from t3
where price > (select avg(price) from t4 where maker in ('D','C') )

--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

--- ������ �1 ����� 595.7142857142857143

with t5 as 
(
select pr.model, avg(price) as price_avg from product pr
join pc
on pr.model=pc.model 
where maker = 'A'
group by pr.model
union
select pr.model, avg(price) from product pr
join laptop l
on pr.model=l.model 
where maker = 'A'
group by pr.model
union 
select pr.model, avg(price) from product pr
join printer pri
on pr.model=pri.model
where maker = 'A'
group by pr.model
)

select avg(price_avg) from t5

--- ������ �2 ����� 599.2857142857142857

create view tesk5 as
with t6 as 
(
select pr.model, price from product pr
join pc
on pr.model=pc.model 
where maker = 'A'
union
select pr.model, price from product pr
join laptop l
on pr.model=l.model 
where maker = 'A'
union 
select pr.model, price from product pr
join printer pri
on pr.model=pri.model
where maker = 'A'
)
select avg(price) from t6 group by model

select avg(avg) from tesk5

-- �����������
-- �� �����, ��� ������ �� 2 �������, �.�. ����������� � ���������� � ��.��������� ������ 1232 (pc).
-- � 1 ������� ��.��������� ������ 1232 (pc) = 425 (�����), �� 2 ������� ��.��������� ������ 1232 (pc) = 450 (������? �� �����!)
-- ������ �������� � ���� ����������
-- ��� � �� ����� �������


--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

create view count_products_by_makers as
select maker, count(maker) from product
group by maker
order by maker

select * from count_products_by_makers

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

-- https://colab.research.google.com/drive/17arWQF0LFopocbbEkLEZMnqGcjU1u6mb

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

create table printer_updated as 
select * 
from printer
where model in
(select pr.model from product pr
join printer pri 
on pr.model=pri.model
where maker != 'D')

select * from printer_updated

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

create view printer_updated_with_makers as
select code, pri.model, color, type, price, maker 
from printer_updated pri
left join 
(select maker, model from product) as pr
on pri.model=pr.model

select * from printer_updated_with_makers

-- �� ������� ��� ������ ����� USING ������������� �������


--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). 
-- �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

create view sunk_ships_by_classes as
with t1 as
(select ship, class
from outcomes
left join ships
on ship=name
where result = 'sunk')
select count(t1.ship), cl.class
from classes cl
left join t1
on cl.class=t1.class or cl.class = t1.ship
group by cl.class

select * from sunk_ships_by_classes

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

-- https://colab.research.google.com/drive/17arWQF0LFopocbbEkLEZMnqGcjU1u6mb#scrollTo=W-l0QP_d-hIr

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create table classes_with_flag as 
select * ,
case when numguns>=9 then 1
else 0
end flag
from classes

select * from classes_with_flag

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

select country, count(class) from classes
group by country

-- https://colab.research.google.com/drive/17arWQF0LFopocbbEkLEZMnqGcjU1u6mb#scrollTo=S_dgUsIu_4_d

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

select count(name) from ships 
where name like 'M%' or name like 'O%'

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select count(name) from ships 
where name like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

select launched as year, count(name) from ships
group by launched

-- https://colab.research.google.com/drive/17arWQF0LFopocbbEkLEZMnqGcjU1u6mb#scrollTo=ce8d-T66CCJU
