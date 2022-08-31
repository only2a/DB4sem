

INSERT into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT)
VALUES ('МЩК','Мущук Артур Николаевич','м','ИСиТ'),
('КРЛВ','Крылов Павел Павлович','м','ТДП');
delete from TEACHER where TEACHER='КРЛВ';
delete from TEACHER where TEACHER='МЩК';
-- 1
CREATE TABLE TR_AUDIT
(
ID int identity,
STMT varchar(20) check (STMT in ('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(800)
)
drop table TR_AUDIT
drop trigger TR_TEACHER_INS
go
    create  trigger TR_TEACHER_INS 
      on TEACHER after INSERT  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(800);
      print 'Вставка';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = rtrim(@a1)+'-'+ rtrim(@a2) +'-'+ rtrim(@a3)+ '-' +rtrim(@a4);
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('INS', 'TR_TEACHER_INS', @in);	         
      return;  
      go

	  insert into  TEACHER values('ИВНВ', 'Иванов', 'м', 'ИСиТ');


	  select * from TR_AUDIT;
	  select * from TEACHER
	  delete from TEACHER where TEACHER='ИВНВ';
	  



-- 2
drop trigger TR_TEACHER_DEL;
go
    create  trigger TR_TEACHER_DEL 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(800);
      print 'Удаление';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = rtrim(@a1)+'-'+ rtrim(@a2) +'-'+ rtrim(@a3)+ '-' +rtrim(@a4);
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL', @in);	         
      return;  

DELETE FROM TEACHER where TEACHER = 'ИВНВ';
select * from TR_AUDIT

-- 3 


go
    create  trigger TR_TEACHER_UPD 
      on TEACHER after UPDATE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(800);
	  declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 

      print 'Обновление';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = rtrim(@a1)+'-'+ rtrim(@a2) +'-'+ rtrim(@a3)+ '-' +rtrim(@a4);
      set @a1 = (select TEACHER from deleted);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in =@in + '   ' + rtrim(@a1)+'-'+ rtrim(@a2) +'-'+ rtrim(@a3)+ '-' +rtrim(@a4);
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('UPD', 'TR_TEACHER_UPD', @in);	         
      return;  
      go
	  update TEACHER set PULPIT = 'ТЛ' where TEACHER like('КРЛВ')
	  select * from TR_AUDIT
	  select * from TEACHER

	  delete from TR_AUDIT where STMT = 'UPD'


-- 4
drop trigger TR_TEACHER
go
create trigger TR_TEACHER  on TEACHER after INSERT, DELETE, UPDATE  
as 
declare @ins int = (select count(*) from inserted),
         @del int = (select count(*) from deleted); 
if  @ins > 0 and  @del = 0  
begin 
     print 'Событие: INSERT';
     insert into TR_AUDIT values ('INS','TR_TEACHER_INS','*' + rtrim((SELECT TEACHER from INSERTED)) + 
													'-' + rtrim((SELECT TEACHER_NAME from INSERTED)) + 
													'-' + rtrim((SELECT GENDER from INSERTED)) + 
													'-' + rtrim((SELECT PULPIT from INSERTED)));
end; 
else		  	 
if @ins = 0 and  @del > 0  
begin 
    print 'Событие: DELETE';
   insert into TR_AUDIT values ('DEL','TR_TEACHER_DEL','*' + rtrim((SELECT TEACHER from DELETED)) + 
													'-' + rtrim((SELECT TEACHER_NAME from DELETED)) + 
													'-' + rtrim((SELECT GENDER from DELETED)) + 
													'-' + rtrim((SELECT PULPIT from DELETED)));
end; 
else	  
if @ins > 0 and  @del > 0  
begin 
    print 'Событие: UPDATE'; 
   insert into TR_AUDIT values ('UPD','TR_TEACHER_UPD','*' + rtrim((SELECT TEACHER from INSERTED)) + 
													'-' + rtrim((SELECT TEACHER_NAME from INSERTED)) + 
													'-' + rtrim((SELECT GENDER from INSERTED)) + 
													'-' + rtrim((SELECT PULPIT from INSERTED)));
end;  
return;  

DELETE FROM TEACHER where TEACHER = 'МЩК';
INSERT into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) VALUES ('МЩК','Мущук Артур Николаевич','м','ИСиТ')
UPDATE TEACHER SET PULPIT = 'ИСиТ' where TEACHER = 'МЩК';
select * from TR_AUDIT;
select * from TEACHER;

-- 5



go UPDATE TEACHER SET GENDER = 'b' where TEACHER = 'МЩК';

select * from TR_AUDIT


-- 6
-----------        DROP TRIGGER TR_TEACHER_DEL1;
-----------        DROP TRIGGER TR_TEACHER_DEL2;
-----------        DROP TRIGGER TR_TEACHER_DEL3;

go
CREATE TRIGGER TR_TEACHER_DEL1 on TEACHER after DELETE as
print('Вызван TR_TEACHER_DEL1');
go
CREATE TRIGGER TR_TEACHER_DEL2 on TEACHER after DELETE as
print('Вызван TR_TEACHER_DEL2');
go
CREATE TRIGGER TR_TEACHER_DEL3 on TEACHER after DELETE as
print('Вызван TR_TEACHER_DEL3');

go    
select t.name, e.type_desc 
         from sys.triggers  t join  sys.trigger_events e  
                  on t.object_id = e.object_id  
                            where OBJECT_NAME(t.parent_id) = 'TEACHER' and 
	                                                                        e.type_desc = 'DELETE' ;  

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'DELETE';

DELETE FROM TEACHER where TEACHER = 'МЩК';
INSERT into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) VALUES ('НСКВ','Носков Михаил Трофимович','М','ИСиТ')


-- 7
--AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, акти-визировавший триггер.
--         DROP TRIGGER TEACHER_TRAN;
--
go
create trigger TEACHER_TRAN on TEACHER after INSERT, DELETE, UPDATE  
as 
declare @count int = (select  count(*) from TEACHER);
if (@count >= 9)
	begin
		raiserror('Количество преподавателей не больше 9!',10,1);
		rollback;
	end;
return;

INSERT into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) VALUES ('НСКВ','Носков Михаил Трофимович','М','ИСиТ');
select * from TEACHER

--8
--INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
go 
create trigger FACULTY_INSTEAD_OF on FACULTY instead of DELETE as raiserror(N'Удаление запрещено',10,1);
return;

delete from FACULTY where FACULTY ='ИТ';


drop trigger FACULTY_INSTEAD_OF


-- 9
--Триггер должен запрещать создавать новые таблицы и удалять существующие.
use UNIVER;
go	
create  trigger DDL_UNIVER on database  for DDL_DATABASE_LEVEL_EVENTS  
as   
declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INS-TANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INS-TANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INS-TANCE/ObjectType)[1]', 'varchar(50)'); 
       print 'Тип события: '+@t;
       print 'Имя объекта: '+@t1;
       print 'Тип объекта: '+@t2;
       raiserror( N'Операции с таблицами запрещены ', 16, 1);  
       rollback;    

use master;
DROP TRIGGER DDL_UNIVER;

CREATE TABLE BUBUB
(
ID int identity(1,1)
)
drop table BUBUB;


-- 11


use master;

go
create table WEATHER 
(
	City varchar(50),
	start_dat smalldatetime,
	end_dat smalldatetime,
	Temperature float
)

go 
create trigger TR_WEATHER 
	on WEATHER for INSERT, UPDATE
	as declare @a1 varchar(50), @a2 smalldatetime, @a3 smalldatetime, @a4 float, @count int, @in varchar(300)
	begin
	  set @a1 = (select City from INSERTED);
      set @a2= (select start_dat from INSERTED);
      set @a3= (select end_dat from INSERTED);
	  set @a4 = (select Temperature from INSERTED);
	  set @in = 'Неверная запись: '+ @a1 + ' '+ cast(@a2 as varchar(20)) +' '+ cast(@a3 as varchar(20))+ ' ' +cast(@a4 as varchar(20));
	  set @count = (select count(*) from WEATHER as W where W.City = @a1 and (W.start_dat >= @a2 or W.end_dat <= @a3)) 
	  if @count > 1
		begin
			raiserror(@in, 11, 1);  
			rollback;
		end
	end
	return

go
insert into WEATHER values ('Минск','01-01-2017 00:00','01-01-2017 23:59', -6);
insert into WEATHER values ('Минск','01-01-2017 00:00','01-01-2017 23:58', -2);

select * from WEATHER;
delete from WEATHER;

drop table WEATHER;
drop trigger TR_WEATHER;