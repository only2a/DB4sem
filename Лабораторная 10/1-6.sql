use UNIVER;
-----------------------------------------------------------
 -- Задание 1
--формирующий список дисциплин на кафедре ИСиТ.
DECLARE Discipline CURSOR for select [SUBJECT_NAME] from [SUBJECT] where [SUBJECT].PULPIT = 'ИСиТ';

--deallocate  Discipline;

DECLARE @subject char(100), @subject_ot char(500) ='';

OPEN Discipline;
FETCH Discipline into @subject;
print 'Дисциплины кафедры ИСиТ';
while @@FETCH_STATUS = 0
	begin
		set @subject_ot = RTRIM(@subject);
		print '-'+@subject_ot;
		FETCH  Discipline into @subject;
	end;
	
CLOSE Discipline;

-----------------------------------------------------------
 -- Задание 2
--отличие глобального курсора от ло-кального
go 
declare @tid char(10), @tnm char(40), @tgn char(1);   
declare c_teacher cursor local--локальный может применяться в рамках одного пакета и ресурсы, 
							  --выделенные ему при объ-явлении, освобождаются сразу после завершения работы пакета.
for select t.TEACHER, t.TEACHER_NAME, t.GENDER 
from TEACHER t where t.PULPIT = 'ИСиТ';
open c_teacher;  

fetch  c_teacher into @tid, @tnm, @tgn;   
print '1. '+ @tid + ' '+ @tnm + ' '+ @tgn;                      
go 
declare @tid char(10), @tnm char(40), @tgn char(1); 
fetch  c_teacher into @tid, @tnm, @tgn;  
print '2. '+@tid + ' '+ @tnm + ' '+ @tgn;      


go 
declare c_teacher2 cursor global--глобальный может быть объявлен, открыт и использован в разных пакетах.
--Выделенные ему ресурсы освобождаются после оператора DEALLOCATE или при завершении сеанса
for select t.TEACHER, t.TEACHER_NAME, t.GENDER 
from TEACHER t where t.PULPIT = 'ИСиТ';
open c_teacher2;
go                       
declare @tid char(10), @tnm char(40), @tgn char(1);  
fetch  c_teacher2 into @tid, @tnm, @tgn;  
print '1. '+ @tid + ' '+ @tnm + ' '+ @tgn;   
go 
declare @tid char(10), @tnm char(40), @tgn char(1);  
fetch  c_teacher2 into @tid, @tnm, @tgn;  
print '2. '+@tid + ' '+ @tnm + ' '+ @tgn;  
close  c_teacher2;

deallocate c_teacher2;--DEALLOCATE освобождение ресурсов глобального курсора
go 
open c_teacher2; 
go    

-----------------------------------------------------------
 -- Задание 3
 --отличие статических курсоров от ди-намических 
 DECLARE @fac char(20), @facn char(100); 
	DECLARE a1 CURSOR LOCAL static                              
		 for  select FACULTY,FACULTY_name from FACULTY;			   
	open a1;
	print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
    
	INSERT FACULTY values ('D','D'); 
	FETCH  a1 into @fac, @facn;     
	while @@fetch_status = 0                                    
      begin 
          print @fac + ' '+ @facn;      
          fetch a1 into @fac, @facn;
       end;          
   CLOSE  a1;
   deallocate a1
   select * from FACULTY
   delete FACULTY where FACULTY like'%D%';

   --------------DYNAMIC----------------
   -- *************************************************
INSERT Into AUDITORIUM values('301-1','ЛБ-К','15','301-1');
-- *************************************************
DECLARE Auditorium_local_dynamic CURSOR  DYNAMIC for select AUDITORIUM,AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К';

-- *************************************************
DECLARE @q int = 0, @auditorium char(10), @iter int = 1;
open Auditorium_local_dynamic;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
DELETE AUDITORIUM where AUDITORIUM ='301-1';
FETCH Auditorium_local_dynamic into @auditorium, @q;
while @@FETCH_STATUS = 0
	begin
		print cast(@iter as varchar(5)) + '. Аудитория ' + rtrim(@auditorium) +': ' + cast(@q as varchar(5)) + ' мест' ;
		set @iter += 1;
		FETCH Auditorium_local_dynamic into @auditorium, @q;
	end;
CLOSE Auditorium_local_dynamic;

Select * from AUDITORIUM
-----------------------------------------------------------
 -- Задание 4
 --свойства навигации в результирующем наборе курсора с атрибутом SCROLL
declare @tc char(50), @rn char(50);
declare dunam cursor local dynamic scroll --динамический курсор и SCROLL, позволяющий применять оператор FETCH с дополнительными опциями позиционирования.
for select row_number() over (order by FACULTY) N,
FACULTY_NAME from FACULTY
open dunam;
fetch first from dunam into @tc, @rn;
print 'первая строка					:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch next from dunam into @tc, @rn;
print 'слудующая строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch last from  dunam into @tc, @rn;
print 'последняя строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch prior from dunam into @tc, @rn;
print 'предыдущая строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch absolute 3 from dunam into @tc, @rn;
print '3 строка с начала				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch absolute -3 from dunam into @tc, @rn;
print '3 строка с конца				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch relative 5 from dunam into @tc, @rn;
print '5 строка с текущей позиции		:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch relative -5 from dunam into @tc, @rn;
print '5 строка назад с текущей позиции:' + cast(@tc as varchar(3))+rtrim(@rn);
close dunam;
  select * from FACULTY
---------------------------------------------------------
 -- Задание 5
 --применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE.
use master;
CREATE TABLE #EXAMPLE
(
	ID int identity(1,1),
	WORD varchar(100)
);

INSERT INTO #EXAMPLE values ('One'),('two'),('three'),('four'),('five'),('six'),('seven');

go
DECLARE @id varchar(10), @word varchar(100);
DECLARE CURRENT_OF_CURSROR CURSOR LOCAL DYNAMIC
	for SELECT * from #EXAMPLE FOR UPDATE;
OPEN CURRENT_OF_CURSROR
fetch CURRENT_OF_CURSROR into @id,@word;
print @id + '-' + @word;
DELETE #EXAMPLE where CURRENT OF CURRENT_OF_CURSROR;
fetch  CURRENT_OF_CURSROR into @id,@word;
UPDATE #EXAMPLE set WORD += ' - updated' where CURRENT OF CURRENT_OF_CURSROR;
print @id + '-' + @word;

close CURRENT_OF_CURSROR;

go
DECLARE @id varchar(10), @word varchar(100);
DECLARE CURRENT_OF_CURSROR CURSOR LOCAL DYNAMIC
	for SELECT * from #EXAMPLE FOR UPDATE;
OPEN CURRENT_OF_CURSROR
while(@@FETCH_STATUS = 0)
	begin
		fetch CURRENT_OF_CURSROR into @id,@word;
		print @id + '-' + @word;
	end;
close CURRENT_OF_CURSROR;

DROP TABLE #EXAMPLE;
---------------------------------------------------------
 -- Задание 6
 go
DECLARE @id varchar(10), @name varchar(100), @subj varchar(50), @note varchar(2);
DECLARE PROGRESS_DELETE_CURSOR CURSOR LOCAL DYNAMIC
	for SELECT STUDENT.IDSTUDENT, STUDENT.NAME, PROGRESS.SUBJECT, PROGRESS.NOTE from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT FOR UPDATE;
OPEN PROGRESS_DELETE_CURSOR
fetch PROGRESS_DELETE_CURSOR into @id,@name,@subj,@note;
if(@note < 4)
			begin
				DELETE PROGRESS where CURRENT OF PROGRESS_DELETE_CURSOR;
			end;
print @id + ' - ' + @name + ' - '+ @subj + ' - ' + @note ;
While (@@FETCH_STATUS = 0)
	begin
		fetch PROGRESS_DELETE_CURSOR into @id,@name,@subj,@note;
		print @id + ' ▬ ' + @name + ' ▬ '+ @subj + ' ▬ ' + @note ;
		if(@note < 4)
			begin
				DELETE PROGRESS where CURRENT OF PROGRESS_DELETE_CURSOR;
			end;
	end;
close PROGRESS_DELETE_CURSOR;

select* from PRogress;
insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
    values 
           ('ОАиП', 1005,  '01.10.2013',3),
           ('СУБД', 1017,  '01.12.2013',3),
		   ('КГ',   1018,  '06.5.2013',3),
           ('ОХ',   1065,  '01.1.2013',3),
           ('ОХ',   1069,  '01.1.2013',3),
           ('ЭТ',   1058,  '01.1.2013',3)
--6.2
declare @im char(20), @n int;  
declare PROGRESS_ADD_CURSOR cursor local for 
select NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1001
open PROGRESS_ADD_CURSOR;  
    fetch  PROGRESS_ADD_CURSOR into @im, @n; 
    UPDATE PROGRESS set NOTE=NOTE-1 where current of PROGRESS_ADD_CURSOR;
close PROGRESS_ADD_CURSOR;

select NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1001

