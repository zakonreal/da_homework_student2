--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select d.Name as Department, t.Name as Employee, t.Salary 
from
(
select e.*,
dense_rank() over (partition by DepartmentId order by Salary desc) as dr 
from Employee e
) t
join Department d
on t.DepartmentId = d.Id 
where dr <=3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

-- вариант 1

select member_name, status,
sum(unit_price * amount) costs
from payments
join familyMembers
on family_member=member_id 
where date like '2005%'
group by family_member

-- вариант 2

select member_name, 
status, 
sum(amount*unit_price) as costs 
from Payments 
join FamilyMembers
on Familymembers.member_id = payments.family_member
where Year (date)='2005'
GROUP BY member_name, status


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

-- вариант 1

select name 
from (
select name, count(*) as c
from passenger 
group by name
) a 
where c > 1

-- вариант 2

select name from Passenger
group by name
having count(*) > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(distinct classroom) as count
from Schedule
where date like '2019-09-02%'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(datediff(NOW(), birthday)/365)) as age
FROM FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount*unit_price) costs
from GoodTypes
join Goods
on good_type_id=type
join Payments
on good = good_id
and date like '2005%'
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select floor(min(DATEDIFF(NOW(), birthday)/365)) year
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select floor(max(DATEDIFF(NOW(), birthday)/365)) max_year
from Student s1
join Student_in_class s2
on s1.id=s2.student 
join class cl
on s2.class=cl.id
and cl.name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name,
sum(unit_price * amount) costs
from payments
join familyMembers
on family_member=member_id 
join Goods
on good=good_id
join GoodTypes
on type=good_type_id
and good_type_name = 'entertainment'
group by status, member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

with t1 as
(
select name, count(company),
dense_rank() OVER(ORDER BY count(company)) rnk
from Trip
join Company
on Company.id=Trip.company
group by name
)
delete from Company
where name in (select name from t1 where rnk=1)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom from 
(
select classroom, count(classroom),
dense_rank() OVER(ORDER BY count(classroom) desc) rnk
from Schedule
group by classroom
) t
where rnk=1


--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name from Teacher t
join Schedule sc
on t.id=sc.teacher
join Subject s
on s.id=sc.subject
where s.name='Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, '.', left(first_name, 1),
'.', left(middle_name, 1), '.') as name
from Student
order by name

