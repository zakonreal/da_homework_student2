-- �������� ������� (lesson 6)

--task3  (lesson6)
--������������ �����: ������� ����� ������ �������� (��, ��-�������� ��� ��������), �������� ����� ������� ����. �������: model

with t1 as
(
select product.model, maker, price, product.type  
from ( 
select code, model, price 
   from pc 
   union all  
    select code, model, price 
    from printer  
   union all  
    select code, model, price 
    from laptop   
    ) as foo 
    join product   
    on product.model = foo.model
)
select model from t1
where price = (select max(price) from t1) 


--task5  (lesson6)
-- ������������ �����: ������� ������� all_products_with_index_task5 ��� ����������� ���� ������ �� ����� code (union all)
-- � ������� ���� (flag) �� ���� > ������������ �� ��������. ����� �������� ��������� (����� ������� �������) 
-- �� ������ ��������� �������� � ������� ����������� ���� (price_index). �� ����� price_index ������� ������

    
 create table all_products_with_index_task5 as 
 select product.model, maker, price, type, 
 case  
 when price > (select max(price) from printer) then 1 
 else 0 
 end flag,
 row_number() over(partition by product.type order by price) as price_index
 from  
 (select code, model, price 
 from pc  
 union all 
 select code, model, price 
 from laptop l  
 union all 
 select code, model, price 
 from printer) all_products 
 join product  
 on all_products.model = product.model

create index price_index on all_products_with_index_task5 (price_index)

select * from all_products_with_index_task5
	
--task1  (lesson6, �������������)
-- SQL: �������� ������� � �������������� ������� (10 000 �����, 3 �������, ��� ���� int) 
-- � ��������� �� ���������� ������� �� 0 �� 1 000 000. ��������� EXPLAIN �������� � �������� ������� ��������. 

create table table_10000_3
(
  column_name1 int not null,
  column_name2 int not null,
  column_name3 int not null
)

-- insert into table_10000_3 values (floor(random()*(max-min+1))+min, floor(random()*(max-min+1))+min, floor(random()*(max-min+1))+min)

do $$
begin
 for cnt in 1..10000 loop	
    insert into table_10000_3 values (floor(random()*(1000000-0+1))+0, floor(random()*(1000000-0+1))+0, floor(random()*(1000000-0+1))+0);
 end loop;
end; $$


 explain select * from table_10000_3
 explain select count(*) from table_10000_3
 explain select max(column_name1) from table_10000_3
 explain select min(column_name2) from table_10000_3
 explain select avg(column_name3) from table_10000_3
 explain select max(column_name1), min(column_name2), avg(column_name3) from table_10000_3
 explain select sum(column_name1)+sum(column_name2)+sum(column_name3) from table_10000_3
 
 
 explain analyze select * from table_10000_3
 explain analyze select count(*) from table_10000_3
 explain analyze select max(column_name1) from table_10000_3
 explain analyze select min(column_name2) from table_10000_3
 explain analyze select avg(column_name3) from table_10000_3
 explain analyze select max(column_name1), min(column_name2), avg(column_name3) from table_10000_3
 explain analyze select sum(column_name1)+sum(column_name2)+sum(column_name3) from table_10000_3
 