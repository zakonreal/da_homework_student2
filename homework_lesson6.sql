-- домашнее задание (lesson 6)

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

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
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all)
-- и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) 
-- по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

    
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
	
--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10 000 строк, 3 колонки, все типы int) 
-- и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции. 

-- 1 способ (создание таблицы)

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
 
-- 2 способ (создание таблицы)

create table table1 as
 select floor(random()*1000000) as x,
        floor(random()*1000000) as y,
        floor(random()*1000000) as z
 from generate_series(1, 100000)

  select * from table1
