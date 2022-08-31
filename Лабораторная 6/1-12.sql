--ЛАБ 6--

use UNIVER;

-- 1--
SELECT min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимости],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Сумма вместимостей]
FROM AUDITORIUM;


-- 2-- для каждого типа аудиторий максималь-ную, минимальную, среднюю вместимость аудиторий, суммарную вместимость всех аудиторий и общее количество аудиторий данного типа. 
select AUDITORIUM_TYPE.AUDITORIUM_TYPE,AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимости],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Сумма вместимостей]
FROM AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME;

-- 3-- количество экзаменационных оценок в за-данном интервале
SELECT * 
	FROM (select CASE 
					when NOTE between 4 and 5 then '4-5'
					when NOTE between 6 and 7 then '6-7'
					when NOTE between 8 and 9 then '8-9'
					when NOTE = 10 then '10'
		 end [Оценки], COUNT(*) [Количество]
		 From PROGRESS Group By Case
					when NOTE between 4 and 5 then '4-5'
					when NOTE between 6 and 7 then '6-7'
					when NOTE between 8 and 9 then '8-9'
					when NOTE = 10 then '10' 
		 end) as T  
	order by CASE [Оценки] 
		when '10' then 1
		when '8-9' then 2
		when '6-7' then 3
		when '4-5' then 4
		else 0
		end;

-- 4-- содержит среднюю экзаменационную оцен-ку для каждого курса каждой специально-сти.
SELECT FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST-2010[Курс], 
			round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
			From FACULTY inner join GROUPS
				on FACULTY.FACULTY = GROUPS.FACULTY
				inner join STUDENT
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
				group by FACULTY.FACULTY,GROUPS.PROFESSION,GROUPS.YEAR_FIRST
				order by [Средняя оценка]  desc


SELECT FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST-2010[Курс],PROGRESS.SUBJECT, 
			round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
			From FACULTY inner join GROUPS
				on FACULTY.FACULTY = GROUPS.FACULTY
				inner join STUDENT
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT and (PROGRESS.[SUBJECT] ='ОАиП' or PROGRESS.[SUBJECT] ='БД')
				group by FACULTY.FACULTY,GROUPS.PROFESSION ,GROUPS.YEAR_FIRST,PROGRESS.SUBJECT
				order by [Средняя оценка] desc
-- 5-- специальность, дисциплины и средние оценки при сдаче экзаменов на факультете ИТ

select * from STUDENT
select * from FACULTY
select * from PROFESSION
select * from GROUPS
select * from PROGRESS

SELECT FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM GROUPS inner join STUDENT
		on GROUPS.IDGROUP= STUDENT.IDGROUP
		inner join FACULTY
		on FACULTY.FACULTY = GROUPS.FACULTY
		inner join PROGRESS
		on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where GROUPS.FACULTY = 'ТОВ'
		group by ROLLUP(GROUPS.PROFESSION,FACULTY.FACULTY, PROGRESS.SUBJECT);




	/*	insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values  ('БЛЗиПсOO  ', 1067,  '01.10.2013',8),
           ('БЛЗиПсOO  ', 1068,  '01.10.2013',7),
           ('БЛЗиПсOO  ', 1069,  '01.10.2013',5),
           ('БЛЗиПсOO  ', 1070,  '01.10.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values   ('ОХ', 1071,  '01.12.2013',5),
           ('ОХ', 1072,  '01.12.2013',9),
           ('ОХ', 1073,  '01.12.2013',5),
           ('ОХ', 1074,  '01.12.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values ('ПЭХ       ',   1075,  '06.5.2013',4),
           ('ПЭХ       ',   1076,  '06.05.2013',7),
           ('ПЭХ       ',   1077,  '06.05.2013',7),
           ('ПЭХ       ',   1078,  '06.05.2013',9),
           ('ПЭХ       ',   1079,  '06.05.2013',5),
           ('ПЭХ       ',   1080,  '06.05.2013',6)*/

-- 6-- п.5 с использованием CUBE-группировки
use UNIVER
SELECT FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP
		inner join FACULTY
		on GROUPS.FACULTY = FACULTY.FACULTY 
		where FACULTY.FACULTY = 'ИТ'
		group by CUBE(GROUPS.PROFESSION,FACULTY.FACULTY, PROGRESS.[SUBJECT]);

-- 7-- определяются результаты сдачи экзаменов.
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		UNION 
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ТОВ'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [Средняя оценка] desc;

-- 7.2--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		UNION ALL
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ТОВ'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [Средняя оценка] desc;

-- 8--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		INTERSECT
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [Средняя оценка] desc;

-- 9--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		EXCEPT
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = 'ИТ'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [Средняя оценка] desc;

--10 -- для каждой дисциплины количество сту-дентов, получивших оценки 8 и 9. 
select * from Progress	
SELECT DISTINCT  t1.SUBJECT, (SELECT count(*) from PROGRESS t2
			where t1.SUBJECT = t2.SUBJECT
				and( NOTE = '8' or  NOTE = '9') ) [Количество 8 и 9]
			From Progress t1	
						GROUP BY SUBJECT,NOTE HAVING NOTE = '8' or  NOTE = '9' 
--11 --
use P_MyBase_3;

SELECT min(МАРШРУТЫ.Дальность_маршрута) [Минимальная дальность],
	   max(МАРШРУТЫ.Дальность_маршрута) [Максимальная дальность],
	   avg(МАРШРУТЫ.Дальность_маршрута) [Средняя дальность],
	   sum(МАРШРУТЫ.Дальность_маршрута) [Сумма дальностей]
FROM МАРШРУТЫ;


SELECT * 
	FROM (select CASE 
					when Оплата between 0 and 5000 then '0-5000'
					when Оплата between 5001 and 10000 then '5000-10000'
					when Оплата between 10001 and 15000 then '10000-15000'
		 end [Оплата], COUNT(*) [Количество]
		 From ВЫПОЛНЯЕМЫЕ Group By  (Case
					when Оплата between 0 and 5000 then '0-5000'
					when Оплата between 5001 and 10000 then '5000-10000'
					when Оплата between 10001 and 15000 then '10000-15000'
		 end)) as T  
	order by CASE [Оплата] 
		when '0-5000' then 1
		when '5000-10000' then 2
		when '10000-15000' then 3
		else 0
		end;


SELECT МАРШРУТЫ.Дальность_маршрута, ВЫПОЛНЯЕМЫЕ.Оплата, ВОДИТЕЛИ.Стаж_водителя, round(avg(cast(Количество_дней_в_пути as float(2))),2) [Среднее количество дней в пути]
		FROM МАРШРУТЫ inner join ВЫПОЛНЯЕМЫЕ
		on МАРШРУТЫ.Идентификациооный_номер_маршрута= ВЫПОЛНЯЕМЫЕ.Маршрут
		inner join ВОДИТЕЛИ
		on ВОДИТЕЛИ.Номер_водителя = ВЫПОЛНЯЕМЫЕ.Водитель
		group by ROLLUP(МАРШРУТЫ.Дальность_маршрута,ВЫПОЛНЯЕМЫЕ.Оплата, ВОДИТЕЛИ.Стаж_водителя);

--12 --


 --***количество студентов в каждой группе, на каждом факультете и всего в университете
select isnull(f.FACULTY, 'Итого') [Факультет], s.IDGROUP [Группа], COUNT(*) [Кол-во студентов]
from GROUPS g	join STUDENT s on s.IDGROUP = g.IDGROUP
				join FACULTY f on f.FACULTY = g.FACULTY
group by rollup (f.FACULTY, s.IDGROUP)

--***количество аудиторий по типам и суммарной вместимости в корпусах и всего 
select isnull(a.AUDITORIUM_TYPE, 'Итого') [Тип аудитории], 
CASE 
					when a.AUDITORIUM like '%1' then '1'
					when a.AUDITORIUM like '%2' then '2'
					when a.AUDITORIUM like '%3' then '3'
		 end as 'Корпус', SUM(AUDITORIUM_CAPACITY) [Суммарная вместимость]
from AUDITORIUM a	join AUDITORIUM_TYPE a2 on a2.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
group by rollup (a.AUDITORIUM_TYPE,CASE 
					when a.AUDITORIUM like '%1' then '1'
					when a.AUDITORIUM like '%2' then '2'
					when a.AUDITORIUM like '%3' then '3'
		 end)

