USE UNIVER;


--1 -- Наименование кафедр,которые находятся на факультете,обеспечивающем подготовку по определённым специальностям 
select * from PULPIT
select * from FACULTY
select * from PROFESSION

SELECT DISTINCT PULPIT.PULPIT_NAME from PULPIT,FACULTY
		Where PULPIT.FACULTY = FACULTY.FACULTY and
		FACULTY.FACULTY
		in ( SELECT PROFESSION.FACULTY from PROFESSION 
		where (PROFESSION.PROFESSION_NAME Like '%технология%') or(PROFESSION.PROFESSION_NAME Like '%технологии%'));

-- 2---- Задание 1 + [... inner join ... on ... and ... in(подзапрос)]
--select * from PULPIT
select PULPIT.PULPIT_NAME[Кафедра]
FROM PULPIT inner join FACULTY on
PULPIT.FACULTY=FACULTY.FACULTY and FACULTY.FACULTY in(
select PROFESSION.FACULTY
from PROFESSION
where (PROFESSION.PROFESSION_NAME Like '%технология%') or( PROFESSION.PROFESSION_NAME like '%технологии%'));
-- 3-- Задание 1 + 3 inner'а 
select Distinct PULPIT.PULPIT_NAME[Кафедра] 
from PULPIT inner join FACULTY on 
PULPIT.FACULTY=FACULTY.FACULTY
inner join PROFESSION on 
PROFESSION.FACULTY=FACULTY.FACULTY and ((PROFESSION.PROFESSION_NAME Like '%технология%') or( PROFESSION.PROFESSION_NAME like '%технологии%'));

-- 4-- Коррелируемый запрос, максимальная вместимость аудиторий каждого типа
select * from AUDITORIUM
SELECT AUDITORIUM_NAME,AUDITORIUM_CAPACITY,AUDITORIUM_TYPE FROM AUDITORIUM a
		Where AUDITORIUM = (select top(1) AUDITORIUM from AUDITORIUM aa
			Where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)
															order by AUDITORIUM_CAPACITY desc;
-- 5-- Факультеты без кафедр
select * from FACULTY
select * from PULPIT

select FACULTY.FACULTY_NAME[Факультеты без кафедр] from FACULTY
where not exists(select * from PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY)

-- 6-- Среднее значение оценок по дисциплинам
select * from PROGRESS
select top 1
   (select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='ОАиП')[ОАиП],
	(select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='КГ')[БД],
	(select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='СУБД')[СУБД]
from PROGRESS

-- 7-- Демонстрация ALL
select * from STUDENT
select * from PROGRESS
SELECT STUDENT.IDSTUDENT, STUDENT.[NAME] from STUDENT 
		Where STUDENT.IDSTUDENT in (select PROGRESS.IDSTUDENT from PROGRESS
		Where PROGRESS.NOTE < all(select PROGRESS.NOTE from PROGRESS
								Where PROGRESS.NOTE >= 5));

SELECT STUDENT.IDSTUDENT, STUDENT.[NAME] from STUDENT 
		Where STUDENT.IDSTUDENT in (select PROGRESS.IDSTUDENT from PROGRESS
		Where PROGRESS.NOTE > any(select PROGRESS.NOTE from PROGRESS
								Where PROGRESS.NOTE >= 8));


-- 9--
use P_MyBase_3;
select * from ВОДИТЕЛИ
select * from ВЫПОЛНЯЕМЫЕ
select * from МАРШРУТЫ

						--Наименование маршрутов,которые выполняются водителем со стажем 5-14 лет--  
select МАРШРУТЫ.Наименование_маршрута[Маршрут]
FROM МАРШРУТЫ
where МАРШРУТЫ.Идентификациооный_номер_маршрута in
		(select  ВЫПОЛНЯЕМЫЕ.Маршрут from ВЫПОЛНЯЕМЫЕ
			where ВЫПОЛНЯЕМЫЕ.Водитель in
			(select  ВОДИТЕЛИ.Номер_водителя from ВОДИТЕЛИ	
				where ВОДИТЕЛИ.Стаж_водителя between 5 and 14))


						--Маршруты,которые не выполняются-- 
select Наименование_маршрута[Невыполняемые маршруты], Идентификациооный_номер_маршрута from МАРШРУТЫ
where not exists(select * from ВЫПОЛНЯЕМЫЕ
where МАРШРУТЫ.Идентификациооный_номер_маршрута=ВЫПОЛНЯЕМЫЕ.Маршрут)


					-- Суммарное количество дней в пути выполняемых маршрутов с оплатой 4400 и 3000--
select top(1)
	isnull((select SUM(Количество_дней_в_пути) from МАРШРУТЫ m
	where m.Дальность_маршрута=4400),'0')[4400] ,
	isnull((select SUM(Количество_дней_в_пути) from МАРШРУТЫ m
	where m.Дальность_маршрута=3000),'0')[3000] 
FROM МАРШРУТЫ


							-- Максимальное количество дней в пути маршрута с определённой дальностью--
select Дальность_маршрута, Количество_дней_в_пути from МАРШРУТЫ a
        Where Идентификациооный_номер_маршрута=(select top(1) Идентификациооный_номер_маршрута from МАРШРУТЫ aa
			Where aa.Дальность_маршрута=a.Дальность_маршрута order by Количество_дней_в_пути desc)
																order by Количество_дней_в_пути desc;


						-- Все выполняемы маршруты,оплата которых меньше каждого из списка выполняемых маршрутов,плата за которые больше или равна 7000
SELECT МАРШРУТЫ.Идентификациооный_номер_маршрута, МАРШРУТЫ.Наименование_маршрута from МАРШРУТЫ 
		Where МАРШРУТЫ.Идентификациооный_номер_маршрута in(select ВЫПОЛНЯЕМЫЕ.Маршрут from ВЫПОЛНЯЕМЫЕ 
		Where ВЫПОЛНЯЕМЫЕ.Оплата < all(select ВЫПОЛНЯЕМЫЕ.Оплата from ВЫПОЛНЯЕМЫЕ 
										Where ВЫПОЛНЯЕМЫЕ.Оплата >=7000));

						-- Все выполняемы маршруты,оплата которых больше  либо равна хотя бы одного значения оплаты из списка(>=7000)
SELECT МАРШРУТЫ.Идентификациооный_номер_маршрута, МАРШРУТЫ.Наименование_маршрута from МАРШРУТЫ 
		Where МАРШРУТЫ.Идентификациооный_номер_маршрута in(select ВЫПОЛНЯЕМЫЕ.Маршрут from ВЫПОЛНЯЕМЫЕ 
		Where ВЫПОЛНЯЕМЫЕ.Оплата >= any(select ВЫПОЛНЯЕМЫЕ.Оплата from ВЫПОЛНЯЕМЫЕ 
										Where ВЫПОЛНЯЕМЫЕ.Оплата >=7000));

-- 10--
use UNIVER

				-- Студенты с днём рождения в один день
SELECT STUDENT.NAME,Day(BDAY)[День рождения], STUDENT.BDAY FROM STUDENT WHERE DAY(BDAY)
IN ( SELECT DAY(BDAY) FROM STUDENT  GROUP BY DAY(BDAY) HAVING COUNT(DAY(BDAY)) > 1) group by Day(Bday),STUDENT.NAME,STUDENT.BDAY;


select DAY(BDAY) from STUDENT order by DAY(BDAY) 