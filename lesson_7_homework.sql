-- домашнее задание (lesson7)


--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

-- https://github.com/zakonreal/da_homework_student2/blob/main/homework_task1__lesson7.ipynb

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/


select Email from
(
    select Email, count(Email) as c 
    from Person
    group by Email)
where c >= 2



--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/


select e.name as Employee from employee e
join employee m
on e.managerId = m.id
where e.salary > m.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/


select score, 
dense_rank() over (order by score desc) as rank 
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/


select firstName, lastName, city, state
from Person
left join Address
on Person.personId=Address.personId
order by firstName

