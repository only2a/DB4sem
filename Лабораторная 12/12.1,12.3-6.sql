use UNIVER
--1. хранимая проц. без парам, форм. рез.набор на основк SUBJECT
--к точке вызова процедура д. возвр кол-во строк, выведенных в рез.набор
go
CREATE procedure PSUBJECT
as begin
	DECLARE @n int = (SELECT count(*) from SUBJECT);
	SELECT SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT;
	return @n;
end;

DECLARE @k int;
EXEC @k = PSUBJECT; -- вызов процедуры 
print 'Количество предметов: ' + cast(@k as varchar(3));
go
--DROP procedure PSUBJECT;


declare @result int = 0, @r int = 0
EXEC @result = PSUBJECT @p='ИСИТ',@c = @r output;
print 'Количество дисциплин:' + cast(@result as varchar(5));
print 'Количество дициплин кафедры ИСИТ:' + cast(@r as varchar(5));
go



----------------------------------------------------------------------------------
--3. созд. врем.лок.табл, столбцы как в рез.наборе 2
--изм. PSUBJECT, убрать @c, добав. ее строки в #SUBJECT

ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;


CREATE table #SUBJECTs
(
	Код_предмета varchar(20),
	Название_предмета varchar(100),
	Кафедра varchar(20)
);
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ПСП';
INSERT #SUBJECTs EXEC PSUBJECT @p = 'СУБД';
SELECT * from #SUBJECTs;
go

--drop table #SUBJECTs


----------------------------------------------------------------------------------
--4. Процедура 4 вх.парам (значения столбцов), доб. строку в табл.AUDITORIUM
go
CREATE procedure PAUDITORIUM_INSERT
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10)
as begin 
begin try
	INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values(@a, @n, @c, @t);
		--values(433-1, 'ЛК', 433-1, 100);
	return 1;
end try
begin catch
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print 'Имя процедуры: ' + error_procedure();
	return -1;
end catch;
end;


DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '820-8', @n = 'ЛК', @c = 100, @t = '820-8'; 
print 'Код ошибки: ' + cast(@rc as varchar(3));
go


select * from AUDITORIUM;
delete AUDITORIUM where AUDITORIUM='820-8';



----------------------------------------------------------------------------------
--5. форм. список дисциплин на отд.кафедре
--краткие назв. в строку через зап.(RTRIM)
--можем использовать курсоры
go
CREATE PROCEDURE SUBJECT_REPORT @p CHAR(10)
as 
	declare @ret int = 0;
	begin try
		declare @subjects nvarchar(300) ='',@subject nvarchar(10);
		DECLARE  Sub_Report CURSOR LOCAL for
		select [SUBJECT] from [SUBJECT] where PULPIT = @p;
		if  not exists (select [SUBJECT] from [SUBJECT] where PULPIT = @p)
			raiserror('Ошибка',11,1);
		else
			open Sub_Report;
			fetch Sub_Report into @subject;
			set @subjects += RTRIM(@subject);
			while @@FETCH_STATUS = 0
				begin	
					fetch Sub_Report into @subject;
					set @subjects = RTRIM(@subject) + ',' +@subjects;
					set @ret = @ret + 1;
				end;
			print 'Дисциплины кафедры ' + @p;
			print @subjects;
			close Sub_Report;
			return @ret;
	end try

	begin catch
		print 'Ошибка в параметрах.'
		if ERROR_PROCEDURE() is not null
			print 'Имя процедуры:' + error_procedure();
		return @ret;
	end catch;

DECLARE @res_rep int;
exec @res_rep = SUBJECT_REPORT @p = 'ИСиТ';
print 'Количество дисциплин: ' + cast(@res_rep as varchar(3));

DROP PROCEDURE SUBJECT_REPORT;
		

----------------------------------------------------------------------------------
--6. Проц. доб. 2 строки: в табл.AUD_TYPE(@t, @tn) + путем вызова PAUD_INSERT
--все в рамках явной транзакции с ур.изол.SERIALIZABLE
 
CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	--доп., для ввода в AUD_TYPEAUD_TYPENAME
as begin
DECLARE @rc int = 1;
begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	commit tran;
	return @rc;
end try
begin catch
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not  null   
	print 'Имя процедуры: ' + error_procedure(); 
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;
end;

DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '522-3', @n = 'КК', @c = 85, @t = '522-3', @tn = 'Комп. класс'; 
print 'Код ошибки: ' + cast(@k3 as varchar(3));

delete AUDITORIUM where AUDITORIUM='522-3';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='КК';
go
drop procedure PAUDITORIUM_INSERTX;

select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;