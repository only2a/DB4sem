use UNIVER;


-- 1--
go
CREATE VIEW [Преподаватель]
as select   TEACHER			[Код],
				TEACHER_NAME    [Имя преподавателя],
				GENDER			[Пол],
				PULPIT			[Код кафедры]
				from TEACHER;
select * from Преподаватель
-- 2--
go
CREATE VIEW [Количество кафедр]
as select		FACULTY_NAME		[Факультет],
				count(PULPIT)		[Количество_кафедр]
				from FACULTY inner join PULPIT
				on FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY_NAME;
insert [Количество кафедр] values('Bs',3);
select * from [Количество кафедр]
-- 3--
go
CREATE VIEW [Аудитории]
as select		AUDITORIUM		[Код],
				AUDITORIUM_NAME [Наименование аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
          insert Аудитории values ('308-3','308-3')

select * from [Аудитории]
-- 4--
go
CREATE VIEW [Лекционные аудитории]
as select		AUDITORIUM		[Код],
				AUDITORIUM_TYPE [Тип],
				AUDITORIUM_NAME [Наименование аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
			and AUDITORIUM_NAME = AUDITORIUM
			WITH CHECK OPTION
			insert [Лекционные аудитории] values ('308-3','ЛК','308-3');

select * from [Лекционные аудитории]
-- 5--
go 
CREATE VIEW Дисциплины
as select TOP 10	SUBJECT			[Код],
					SUBJECT_NAME	[Наименование дисциплины],
					PULPIT			[Код кафедры]
					from SUBJECT
					order by SUBJECT_NAME;
select * from Дисциплины

-- 6--
go
ALTER VIEW [Количество кафедр] with SCHEMABINDING
as select		fclt.FACULTY_NAME		[Факультет],
				count(plpt.PULPIT)		[Количество_кафедр]
				from dbo.FACULTY fclt inner join dbo.PULPIT plpt
				on fclt.FACULTY = plpt.FACULTY group by FACULTY_NAME;
INSERT [Количество кафедр] values ('ИТ',3);

-- 7--

use P_MyBase_3;
--*** 1

go
CREATE VIEW [Маршрут]
as select   Наименование_маршрута			[Наименование],
			Дальность_маршрута    [Дальность],
			Идентификациооный_номер_маршрута	[Номер]
			from МАРШРУТЫ;
select * from Маршрут
--***2
go
CREATE VIEW [Количество_маршрутов_у_водителя]
as select		ВЫПОЛНЯЕМЫЕ.Водитель		[Номер_водителя],
				count(ВЫПОЛНЯЕМЫЕ.Маршрут)		[Количество заказов]
				from ВЫПОЛНЯЕМЫЕ inner join ВОДИТЕЛИ
				on ВОДИТЕЛИ.Номер_водителя = ВЫПОЛНЯЕМЫЕ.Водитель group by ВЫПОЛНЯЕМЫЕ.Водитель;

select * from [Количество_маршрутов_у_водителя]

--***3
go
CREATE VIEW [ВодителиПред]
as select		Номер_водителя [Номер],
				Фамилия_водителя		[Фамилия],
				Стаж_водителя [Стаж]
			from ВОДИТЕЛИ
			where Стаж_водителя between 8 and 15;
insert [ВодителиПред] values ('plk2','Бидон',12);

--***4
go
CREATE VIEW [Быстрые_маршруты]
as select		Идентификациооный_номер_маршрута		[Код],
				Наименование_маршрута [Тип],
				Дальность_маршрута [Дальность],
				Количество_дней_в_пути [Наименование аудитории]
			from МАРШРУТЫ
			where Наименование_маршрута like '%k%'
			and Количество_дней_в_пути < 5
			WITH CHECK OPTION
			insert [Быстрые_маршруты] values ('kjhd1','Kursk-Lvov',2000,2);

select * from [Быстрые_маршруты]

-- 8--

go
CREATE VIEW Расписание
as select TOP 150 [Время],[2 группа],[13 группа]
					from (select TOP 150	WEEKDAY	+ ' ' + CAST(PARA as varchar)		[Время],
					cast(GROUP_ as varchar)	+ ' группа'								[Группа],
					[SUBJECT] + ' ' + AUDITORIUM						[Дисциплина и аудитория]
					from TIMETABLE 
						 ) tbl
PIVOT
		( max([Дисциплина и аудитория]) 
		FOR Группа
		in ([2 группа],[13 группа])
		) as rt
		order by 
					(CASE
					 when [Время] like '%Понедельник%' then 1
					 when [Время] like '%Вторник%' then 2
					 when [Время] like '%Среда%' then 3
					 when [Время] like '%Четверг%' then 4
					 when [Время] like '%Пятница%' then 5
					 when [Время] like '%Суббота%' then 6
					 end) ;

select * from Расписание					 