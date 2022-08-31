use UNIVER;

-- 1--
-- объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
-- первые две переменные проинициа-лизировать в операторе объявления;
-- присвоить произвольные значения следующим двум переменным с помо-щью оператора SET, одной из этих пе-ременных присвоить значение, получен-ное в результате запроса SELECT; 
-- одну из переменных оставить без инициализации и не присваивать ей зна-чения, оставшимся переменным присво-ить некоторые значения с помощью оператора SELECT; 
-- значения одной половины перемен-ных вывести с помощью оператора SE-LECT, значения другой половины пере-менных распечатать с помощью опера-тора PRINT. 

DECLARE @c char = 'c',
		@vc varchar(10) = 'Hi!',
		@dt datetime,
		@tm time(0),
		@i int,
		@smi smallint,
		@tni tinyint,
		@nmrc numeric(12,5);
SET @dt = getdate();
SET @tm = (SELECT @dt dt);
DECLARE @h TABLE
			(
			num int identity(1,1)
			);
INSERT @h default values;
INSERT @h default values;
INSERT @h default values;
INSERT @h default values;
SET @i =	(SELECT * from @h where num = 1);
SET	@smi =	(SELECT * from @h where num = 2);
SET	@tni =	(SELECT * from @h where num = 3);
SET	@nmrc =	(SELECT * from @h where num = 4);
print @i;print @smi;print @tni;print @nmrc;
SELECT @c, @vc,@dt,@tm;


-- 2--
--определяется общая вместимость ауди-торий. Когда общая вместимость пре-вышает 200,
--то вывести количество аудиторий, среднюю вместимость ауди-торий, количество аудиторий,
--вмести-мость которых меньше средней, и про-цент таких аудиторий.
--Когда общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости

DECLARE @capacity int = (select cast(sum(AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
		@q int = (select cast(count(*) as int) from AUDITORIUM),
		@avg int = (select cast(avg(AUDITORIUM_CAPACITY) as int) from AUDITORIUM);

DECLARE	@lessavg int =  (select cast(count(*) as int) from AUDITORIUM where AUDITORIUM_CAPACITY < @avg);
DECLARE	@percent float =  cast(cast(@lessavg as float) / cast(@q as float) * 100  as float);
		
	IF @capacity > 200
		begin 
		SELECT @q 'Количество аудиторий',			@avg 'Средняя вместимость аудиторий',
			   @lessavg  'Вместимость < средней',		cast(@percent as varchar) + '%'   'Процент от всего кол-ва аудиторий'
		end
	ELSE IF @capacity < 200
		begin
		PRINT @capacity
		end;

-- 3--
--											Глобальные переменные
print 'Число обработанных строк: ' +										cast(@@ROWCOUNT as varchar);
print 'Версия SQL Server: ' +												@@VERSION  ;
print 'Системный идентификатор процесса ' +
	  'назначенный сервером текущему под-ключению: ' +						cast(@@SPID  as varchar);
print 'Код последней ошибки: ' +											cast(@@ERROR as varchar);	
print 'Имя сервера: ' +														@@SERVERNAME  ;
print 'Уровень вложенности транзакции: ' +									cast(@@TRANCOUNT as varchar);
print 'Проверка результата считывания строк результирующего набора: ' +		cast(@@FETCH_STATUS as varchar);
print 'Уровень вложенности текущей процедуры: ' +							cast(@@NESTLEVEL as varchar);

-- 4--
-- преобразование полного ФИО студента в сокращенное 
-- поиск студентов, у которых день рож-дения в следующем месяце, и определе-ние их возраста;
-- поиск дня недели, в который сту-денты некоторой группы сдавали экза-мен по СУБД.

DECLARE @t float = 90, @x float = 30, @z float;
IF (@t > @x)
	begin
	SET @z  = POWER(SIN(@t),2);
	end
ELSE IF (@t < @x)
	begin
	SET @z  = 4 * (@t + @x);
	end
ELSE IF (@t = @x)
	begin 
	SET @z  = 1 - EXP(@x-2);
	end
SELECT @z z;

DECLARE @tableFIO varchar(50) = (select top 1 NAME from STUDENT)
DECLARE @resultFIO varchar(50);
		SET @resultFIO = (select substring(@tableFIO, 1, charindex(' ', @tableFIO)) +
								 substring(@tableFIO, charindex(' ', @tableFIO)+1,1)+'.'+
								 substring(@tableFIO, charindex(' ', @tableFIO, charindex(' ', @tableFIO)+1)+1,1)+'.');
print @resultFIO;

select * from (select *, DATEDIFF(YEAR,BDAY,GETDATE())-10 Возраст from STUDENT where MONTH(BDAY)  = MONTH(GETDATE()) + 1) as tr;

select * from (select *,
						(CASE 
							when DATEPART(weekday,PDATE) = 1 then 'Понедельник'
							when DATEPART(weekday,PDATE) = 2 then 'Вторник'
							when DATEPART(weekday,PDATE) = 3 then 'Среда'
							when DATEPART(weekday,PDATE) = 4 then 'Четверг'
							when DATEPART(weekday,PDATE) = 5 then 'Пятница'
							when DATEPART(weekday,PDATE) = 6 then 'Суббота'
							when DATEPART(weekday,PDATE) = 7 then 'Воскресенье'
						end) [День недели] from PROGRESS where SUBJECT like '%ОАиП%') as tr;

-- 5--
-- Продемонстрировать конструкцию IF… ELSE на примере анализа данных таб-лиц базы данных Х_UNIVER.
SELECT STUDENT.IDGROUP, round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
			From STUDENT inner join GROUPS
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
				group by STUDENT.IDGROUP

DECLARE @gr varchar(3) = '3';
DECLARE @ttp float(2) = (SELECT round(avg(cast(PROGRESS.NOTE as float(2))),2) [Средняя оценка]
			From STUDENT inner join GROUPS
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT  where STUDENT.IDGROUP = @gr
				group by STUDENT.IDGROUP);

IF (@ttp  <= 4)
	begin 
	PRINT 'Успеваемость группы номер ' + cast(@gr as varchar) + ' низкая. Средний балл: ' +  cast(@ttp as varchar);
	end
ELSE IF (@ttp  > 4 and @ttp  < 8)
	begin 
	PRINT 'Успеваемость группы номер ' + cast(@gr as varchar) + ' средняя. Средний балл: ' + cast(@ttp as varchar);
	end
ELSE IF (@ttp  > 8)
	begin 
	PRINT 'Успеваемость группы номер ' + cast(@gr as varchar) + ' средняя. Средний балл: ' + cast(@ttp as varchar);
	end

-- 6--
 --  с помощью CASE анализируются оцен-ки, полученные студентами некоторого факультета при сдаче экзаменов.
select case
when NOTE between 1 and 4 then 'Неудовлетворительно'
	when NOTE between 5 and 7 then 'Хорошо'
	when NOTE between 8 and 10 then 'Отлично'
	end Оценка,count(*)[Количество]
	from 
	PROGRESS p inner join SUBJECT s on p.SUBJECT=s.SUBJECT 
			   inner join PULPIT p2 on s.PULPIT=p2.PULPIT 
			   inner join FACULTY f on p2.FACULTY=f.FACULTY
 Where f.FACULTY = 'ИТ'
 group by 
 case
  when NOTE between 1 and 4 then 'Неудовлетворительно'
	when NOTE between 5 and 7 then 'Хорошо'
	when NOTE between 8 and 10 then 'Отлично'
	end

-- 7--
--  Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. Использовать оператор WHILE.
--DROP TABLE #TEMP1;
CREATE TABLE #TEMP1
		(
			ID int identity(1,1),
			RANDOM_NUMBER int,
			WORD varchar(50) default 'Значение по умолчанию'
		);

DECLARE  @iter int = 0;
WHILE @iter < 10
	begin
	INSERT #TEMP1(RANDOM_NUMBER)
			values(rand() * 1000);
	SET @iter = @iter + 1;
	end
SELECT * from #TEMP1;

-- 8--
--Разработать скрипт, демонстрирующий использование оператора RETURN.
declare @xx int=3;
print @xx+10;
print @xx*10;
return
print @xx+1;



-- 9--

use P_MyBase_3
begin try
update МАРШРУТЫ set Дальность_маршрута='вы'
end try 
begin catch
print 'Код ошибки: '+ cast( ERROR_NUMBER() as varchar(10))
print 'Сообщение об ошибке: ' + cast(ERROR_MESSAGE() as varchar(190))
print 'Строка ошибки: ' + cast(ERROR_LINE() as varchar(10))
print 'Имя процедуры ошибки: ' + isnull(cast(ERROR_PROCEDURE() as varchar(10)),'null')
print 'Уровень серьёзности ошибки: ' + cast(ERROR_SEVERITY() as varchar(10))
print 'Метка ошибки: ' + cast(ERROR_STATE() as varchar(10))
end catch