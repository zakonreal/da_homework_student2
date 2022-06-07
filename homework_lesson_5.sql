-- �������� ������� 4 . ���� 5

--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� 
--(�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as 
select code, model, speed, ram, hd, price, screen, 
    case 
	    when n%2=0 then n/2 
      	else n/2+1 
	end n_page, 
    case 
	    when all_lap%2= 0 then all_lap/2 
    	else all_lap/2+1 
    end all_pages
from (
      select *,
      row_number() over(order by code) as n, 
      count(*) over() as all_lap 
      from laptop
     ) t 

select * from pages_all_products
     
--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. 
-- �����: �������������, ���, ������� (%)

create view distribution_by_type as 
select maker, type,
(ct*100.0/(select count(*) from product)) as percent
from 
(
select maker, type, count(*) as ct
from product
group by maker, type
order by maker
) t1

select * from distribution_by_type

--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������. ������ https://plotly.com/python/histograms/

-- https://colab.research.google.com/github/zakonreal/da_homework_student2/blob/main/homework4_lesson5_task3.ipynb
-- ���
-- https://github.com/zakonreal/da_homework_student2/blob/main/homework4_lesson5_task3.ipynb

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����

create table ships_two_words as 
select * from ships 
where name like '% %'

select * from ships_two_words

--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

select t.name from
  (select ship as name from outcomes
  union
  select name from ships) as t  
  left join ships
  on t.name = ships.name
  where class is null and t.name like 'S%'

--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� �������
-- �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������). ������� model

-- ����������� - ��������� ������������� = 'C' ��� , ������� ������� �������� ������������� "�" �� "D"
  

select pr.model
from product p
join printer pr
on p.model = pr.model
where maker = 'A'  
and price >
		(
		select avg(price) from product pr
		join printer pri
		on pr.model = pri.model
		where maker = 'D'
		) 
union
select model from 
	(
	select pr.model,
	row_number() over(partition by pr.type order by price desc) as rn
	from product pr
	join printer pri
	on pr.model = pri.model
	) t
	where rn <= 3

