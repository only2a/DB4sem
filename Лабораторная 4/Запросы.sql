use UNIVER;

-----1 -- Код-тип
select * from AUDITORIUM
select * from AUDITORIUM_TYPE
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
      from AUDITORIUM inner join AUDITORIUM_TYPE
      on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
-----2 
select * from AUDITORIUM
select * from AUDITORIUM_TYPE
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
      from AUDITORIUM inner join AUDITORIUM_TYPE
      on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE and
            AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%компьютер%'
-----3 неявная реализация 
select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM as A, AUDITORIUM_TYPE as A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE

select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM as A, AUDITORIUM_TYPE as A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE and
            A_T.AUDITORIUM_TYPENAME like '%компьютер%'
-----4 --Перечень студентов,получивших оценки 6-8
select  FACULTY.FACULTY [Факультет], PROFESSION.PROFESSION_NAME [Кафедра], PULPIT.PULPIT [Специальность], SUBJECT.SUBJECT_NAME [Дисциплина], STUDENT.NAME [Имя Студента],
      case 
      when (PROGRESS.NOTE = 6) then 'шесть'
      when (PROGRESS.NOTE = 7) then 'семь'
      when (PROGRESS.NOTE = 8) then 'восемь'
      end [Оценка]
    from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
      inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
      inner join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT
      inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
      inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
      inner join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
            where PROGRESS.NOTE between 6 and 8 order by PROGRESS.NOTE desc 
			
-----5 --Сортировка через CASE(сначала 7ки,потом 8ки,а после 6ки)
select  FACULTY.FACULTY [Факультет], PROFESSION.PROFESSION_NAME [Кафедра], PULPIT.PULPIT [Специальность], SUBJECT.SUBJECT_NAME [Дисциплина], STUDENT.NAME [Имя Студента],
      case 
        when (PROGRESS.NOTE = 6) then 'шесть'
        when (PROGRESS.NOTE = 7) then 'семь'
        when (PROGRESS.NOTE = 8) then 'восемь'
      end [Оценка]
    from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
      inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
      inner join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT
      inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
      inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
      inner join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
            where PROGRESS.NOTE between 6 and 8 
            order by 
            (case
              when (PROGRESS.NOTE=6) then 3
              when (PROGRESS.NOTE=7) then 1
              else 2
            end)
-----6 --ПОЛНЫЙ перечень кафедр и преподавателей на кафедрах[isnull] 
select PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
    from PULPIT left outer join TEACHER
    on TEACHER.PULPIT = PULPIT.PULPIT
-----7 Потому каждый преподаватель числится за какой-либо кафедрой, но не для каждой кафедры есть преподаватели
select PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
    from TEACHER right outer join PULPIT
    on TEACHER.PULPIT = PULPIT.PULPIT
-----8 --Коммутативна, так как независимо от порядка таблиц,результирующий набор не меняется 
drop table МАРШРУТЫ
drop table ВЫПОЛНЯЕМЫЕ

CREATE table МАРШРУТЫ
(
Идентификациооный_номер_маршрута nvarchar(20) primary key,
Наименование_маршрута nvarchar(20),
Дальность_маршрута real
);
INSERT into МАРШРУТЫ(Идентификациооный_номер_маршрута,Наименование_маршрута,Дальность_маршрута)
Values('c1','Brest-Minsk',300),
('b2','Pinsk-Tomck',1300),
('a3','Vilnus-Sochi',2300),
('e4','Mogilev-Paris',4500)

CREATE table ВЫПОЛНЯЕМЫЕ
(
Номер_выполняемой_грузоперевозки nvarchar(10) primary key,
Маршрут nvarchar(20) foreign key references МАРШРУТЫ(Идентификациооный_номер_маршрута),
Оплата int not null check(Оплата>0)
);

INSERT into ВЫПОЛНЯЕМЫЕ(Номер_выполняемой_грузоперевозки,Маршрут,Оплата)
Values('1','a3',4300),
('2','b2',10230),
('3','c1',18000);

select * from МАРШРУТЫ
select * from ВЫПОЛНЯЕМЫЕ
SELECT ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки, ВЫПОЛНЯЕМЫЕ.Оплата, МАРШРУТЫ.Наименование_маршрута
FROM ВЫПОЛНЯЕМЫЕ LEFT outer JOIN Маршруты ON Выполняемые.Маршрут = Маршруты.Идентификациооный_номер_маршрута

SELECT isnull(ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки,'###')[Номер_грузоперевозки], isnull( ВЫПОЛНЯЕМЫЕ.Оплата,0)[Оплата],МАРШРУТЫ.Наименование_маршрута[Маршрут]
FROM ВЫПОЛНЯЕМЫЕ RIGHT outer JOIN МАРШРУТЫ ON ВЫПОЛНЯЕМЫЕ.Маршрут = МАРШРУТЫ.Идентификациооный_номер_маршрута


SELECT ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки[Номер_грузоперевозки], isnull( ВЫПОЛНЯЕМЫЕ.Оплата,0)[Оплата],МАРШРУТЫ.Наименование_маршрута[Маршрут]
FROM ВЫПОЛНЯЕМЫЕ FULL outer JOIN МАРШРУТЫ ON ВЫПОЛНЯЕМЫЕ.Маршрут = МАРШРУТЫ.Идентификациооный_номер_маршрута 
where ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки is null

SELECT ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки[Номер_грузоперевозки], isnull( ВЫПОЛНЯЕМЫЕ.Оплата,0)[Оплата],МАРШРУТЫ.Наименование_маршрута[Маршрут]
FROM ВЫПОЛНЯЕМЫЕ FULL outer JOIN МАРШРУТЫ ON ВЫПОЛНЯЕМЫЕ.Маршрут = МАРШРУТЫ.Идентификациооный_номер_маршрута 
where ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки is not null

SELECT isnull(ВЫПОЛНЯЕМЫЕ.Номер_выполняемой_грузоперевозки,'###')[Номер_грузоперевозки], isnull( ВЫПОЛНЯЕМЫЕ.Оплата,0)[Оплата], МАРШРУТЫ.Наименование_маршрута
FROM МАРШРУТЫ FULL outer JOIN ВЫПОЛНЯЕМЫЕ ON ВЫПОЛНЯЕМЫЕ.Маршрут = Маршруты.Идентификациооный_номер_маршрута order by Маршруты.Наименование_маршрута
-----9 -- Задание 1 через Cross join
select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM A cross join AUDITORIUM_TYPE A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE
-----10
use P_MyBase_3

select МАРШРУТЫ.Наименование_маршрута, ВЫПОЛНЯЕМЫЕ.Оплата, ВОДИТЕЛИ.Имя_водителя, ВОДИТЕЛИ.Фамилия_водителя
      from ВЫПОЛНЯЕМЫЕ inner join МАРШРУТЫ
      on МАРШРУТЫ.Идентификациооный_номер_маршрута = ВЫПОЛНЯЕМЫЕ.Маршрут
	  inner join ВОДИТЕЛИ on ВЫПОЛНЯЕМЫЕ.Водитель=ВОДИТЕЛИ.Номер_водителя
	  order by МАРШРУТЫ.Наименование_маршрута
	  

select  ВОДИТЕЛИ.Фамилия_водителя, ВЫПОЛНЯЕМЫЕ.Оплата, 
      case 
        when (ВЫПОЛНЯЕМЫЕ.Оплата between 1000 and 5000) then 'мало'
        when (ВЫПОЛНЯЕМЫЕ.Оплата between 5000 and 10000) then 'в пределах нормы'
        when (ВЫПОЛНЯЕМЫЕ.Оплата > 10000) then 'достаточно'
      end [Оценка], МАРШРУТЫ.Наименование_маршрута, МАРШРУТЫ.Дальность_маршрута
    from ВЫПОЛНЯЕМЫЕ inner join ВОДИТЕЛИ on ВЫПОЛНЯЕМЫЕ.Водитель = ВОДИТЕЛИ.Номер_водителя
           inner join МАРШРУТЫ on ВЫПОЛНЯЕМЫЕ.Маршрут = МАРШРУТЫ.Идентификациооный_номер_маршрута 
            order by ВЫПОЛНЯЕМЫЕ.Оплата

select МАРШРУТЫ.Наименование_маршрута, isnull (ВЫПОЛНЯЕМЫЕ.Водитель, '---') [Номер_водителя]
    from МАРШРУТЫ right outer join  ВЫПОЛНЯЕМЫЕ
    on МАРШРУТЫ.Идентификациооный_номер_маршрута = ВЫПОЛНЯЕМЫЕ.Маршрут
        

select МАРШРУТЫ.Наименование_маршрута,isnull (ВЫПОЛНЯЕМЫЕ.Водитель, '***') [Номер_водителя]
    from МАРШРУТЫ left outer join  ВЫПОЛНЯЕМЫЕ
    on Маршруты.Идентификациооный_номер_маршрута = ВЫПОЛНЯЕМЫЕ.Маршрут

	--select * from МАРШРУТЫ;
	--select * from ВЫПОЛНЯЕМЫЕ;
select МАРШРУТЫ.Наименование_маршрута, ВЫПОЛНЯЕМЫЕ.Водитель
    from МАРШРУТЫ cross join  ВЫПОЛНЯЕМЫЕ


select МАРШРУТЫ.Наименование_маршрута, ВЫПОЛНЯЕМЫЕ.Водитель
    from МАРШРУТЫ cross join  ВЫПОЛНЯЕМЫЕ
	where МАРШРУТЫ.Идентификациооный_номер_маршрута=ВЫПОЛНЯЕМЫЕ.Маршрут
-----11*
use UNIVER;
drop table TIMETABLE;
create table TIMETABLE
(
  ID varchar(6) primary key,
  GROUP_ int foreign key references GROUPS(IDGROUP),
  AUDITORIUM char(20) foreign key references AUDITORIUM(AUDITORIUM),
  SUBJECT char(10) foreign key references SUBJECT(SUBJECT),
  TEACHER char(10) foreign key references TEACHER(TEACHER),
  WEEKDAY nvarchar(20) check (WEEKDAY in('Понедельник','Вторник','Среда','Четверг','Пятница','Суббота')),
  PARA nvarchar(20) check (PARA in('14:40-16:00','16:30-17:50','18:05-19:25','19:40-21:00','13:00-14:20','11:25-12:45'))
)
insert into TIMETABLE(ID, GROUP_, AUDITORIUM, SUBJECT, TEACHER, WEEKDAY, PARA)
    values  ('a1', 2, '313-1', 'ООП', 'ЖЛК', 'Понедельник', '14:40-16:00'),
        ('b1', 15, '236-1', 'ПЭХ', 'БЗБРДВ', 'Четверг', '18:05-19:25'),
        ('c1', 1, NULL, NULL, NULL, 'Понедельник', '18:05-19:25'),
        ('d1', 2, '408-2', 'ПЗ', 'МРЗ ', 'Суббота', '16:30-17:50'),
        ('e1', 2, '236-1', 'ЭТ', 'ДТК', 'Понедельник', '14:40-16:00'),
        ('f1', 2, '408-2', 'КГ', 'ЖЛК', 'Четверг', '16:30-17:50'),
        ('g1', 4, NULL, NULL, 'АРС', 'Пятница', '19:40-21:00'),
        ('h1', 5, NULL, NULL, 'БРГ', 'Пятница', '11:25-12:45'),
        ('i1', 13, '423-1', 'ИГ', 'ЗВГЦВ', 'Суббота', '11:25-12:45'),
        ('j1', 13, '413-1', 'ЛВ', 'БРГ', 'Суббота', '14:40-16:00'),
        ('k1', 13, '324-1', 'БЛЗиПсOO', 'ДМДК', 'Понедельник', '11:25-12:45'),
        ('l1', 7, NULL, NULL, NULL, NULL, '11:25-12:45'),
        ('m1', 10, NULL, NULL, 'ЖЛК', 'Понедельник', '16:30-17:50'),
        ('n1', 2, NULL, NULL, NULL, 'Понедельник', '19:40-21:00')

		--Сортировка через Case--
select * from TIMETABLE order by 
            (case
              when (TIMETABLE.WEEKDAY = 'Понедельник') then 1
              when (TIMETABLE.WEEKDAY = 'Вторник') then 2
              when (TIMETABLE.WEEKDAY = 'Среда') then 3
              when (TIMETABLE.WEEKDAY = 'Четверг') then 4
              when (TIMETABLE.WEEKDAY = 'Пятница') then 5
              when (TIMETABLE.WEEKDAY = 'Суббота') then 6
            end)

			--Полный список пар и аудиторий,выделенных для этих пар
select TIMETABLE.WEEKDAY, TIMETABLE.PARA, AUDITORIUM.AUDITORIUM
    from TIMETABLE full outer join AUDITORIUM
    on  TIMETABLE.AUDITORIUM = AUDITORIUM.AUDITORIUM order by 
            (case
              when (TIMETABLE.WEEKDAY = 'Понедельник') then 1
              when (TIMETABLE.WEEKDAY = 'Вторник') then 2
              when (TIMETABLE.WEEKDAY = 'Среда') then 3
              when (TIMETABLE.WEEKDAY = 'Четверг') then 4
              when (TIMETABLE.WEEKDAY = 'Пятница') then 5
              when (TIMETABLE.WEEKDAY = 'Суббота') then 6
            end)
			-- Форточки в расписании преподавателя
select TEACHER.TEACHER_NAME [Преподаватель], TIMETABLE.WEEKDAY [День Недели], TIMETABLE.PARA [Окно]
    from TEACHER inner join TIMETABLE
    on TEACHER.TEACHER = TIMETABLE.TEACHER
      where TIMETABLE.SUBJECT is null
		--Форточки групп	
select GROUPS.IDGROUP [Группа], isnull(TIMETABLE.WEEKDAY,'---') [День Недели], TIMETABLE.PARA [Окно]
    from GROUPS inner join TIMETABLE
    on GROUPS.IDGROUP = TIMETABLE.GROUP_
      where TIMETABLE.SUBJECT is null

	  select * from TIMETABLE