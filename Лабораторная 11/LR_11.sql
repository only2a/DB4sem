use master;
-- ----------------------------------------------------------------

--								ЗАДАНИЕ 1

-- ----------------------------------------------------------------
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.MyTable') )	     
	drop table MyTable;        

declare @c int, @flag char = 'r';           
SET IMPLICIT_TRANSACTIONS  ON
	
CREATE table MyTable(
ID int identity(1,1), 
word nvarchar(20)
);                         

INSERT MyTable values ('one'),('two'),('three');
set @c = (select count(*) from MyTable);
print 'количество строк в таблице: ' + cast( @c as varchar(2));
if @flag = 'c' commit;
else rollback; 
SET IMPLICIT_TRANSACTIONS  OFF   

if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.MyTable') )
	print 'таблица MyTable есть'; 
	else print 'таблицы MyTable нет';
-- ----------------------------------------------------------------

--								ЗАДАНИЕ 2

-- ----------------------------------------------------------------
use UNIVER;

begin try
	begin tran
		delete AUDITORIUM where AUDITORIUM_NAME = '301-1';
		insert into AUDITORIUM values('301-1','ЛБ-К','15','301-1');
		update AUDITORIUM set AUDITORIUM_CAPACITY = '30' where AUDITORIUM_NAME='301-1';
		print 'Транзакция прошла успешно'; 
	commit tran;
end try
begin catch
	print 'Ошибка: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
	if @@TRANCOUNT > 0 rollback tran;
end catch;

select * from AUDITORIUM
-- ----------------------------------------------------------------

--								ЗАДАНИЕ 3

-- ----------------------------------------------------------------
use UNIVER;

DECLARE @savepoint varchar(30);
begin try
	begin tran
		set @savepoint = 'save1'; save tran @savepoint;
		delete AUDITORIUM where AUDITORIUM_NAME = '301-1';									
		set @savepoint = 'save2'; save tran @savepoint;
		insert into AUDITORIUM values('301-1','ЛБ-К','15','301-1');							
		set @savepoint = 'save3'; save tran @savepoint;
		update AUDITORIUM set AUDITORIUM_CAPACITY = 30 where AUDITORIUM_NAME='301-1';		
		print 'Транзакция прошла успешно'; 
	commit tran;
end try
begin catch
	print 'Ошибка: ' + cast(error_number() as varchar(5)) + ' ' + error_message()
	if @@TRANCOUNT > 0
		begin
			print 'Контрольная точка: ' + @savepoint;
			rollback tran @savepoint;
			commit tran;
		end;
end catch;	
-- ----------------------------------------------------------------

--								ЗАДАНИЕ 8

-- ----------------------------------------------------------------
-----@@TRANCOUNT-----вложенные транзакции
SELECT COUNT(*) '1', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;
BEGIN TRANSACTION A;

INSERT INTO AUDITORIUM values('128-1','ЛК','60','128-1');
SELECT COUNT(*) '2', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;

BEGIN TRANSACTION B
DELETE AUDITORIUM WHERE AUDITORIUM ='128-1';
SELECT COUNT(*) '3', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;

COMMIT TRANSACTION B;
SELECT COUNT(*) '4', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;

INSERT INTO AUDITORIUM values('128-1','ЛК','60','128-1');
SELECT COUNT(*) '5', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;

COMMIT TRANSACTION A;
SELECT COUNT(*) '6', @@TRANCOUNT 'TRANCOUNT' FROM AUDITORIUM;
-- ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

--								ЗАДАНИЕ 9

-- ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
/* 
	Уровень изолированности SERIALIZABLE подойдёт для транзакций получения данных 
из таблицы ЗАКАЗАННЫЕ_ТОВАРЫ, ЗАКАЗЫ ведь возможность ошибочного чтения информации при выполнении пользователем 
заказа должна быть сведена к минимуму.
	Уровень изолированности REPEATABLE READ подойдёт для транзакций получения данных
из таблиц ТОВАРЫ, так как возможность чтения незафиксированных данных не несёт фатальных
ошибок при работе с подобными базами данных для магазина.
	Уровень изолированности READ COMMITED не допускает неподтверждённого чтения.
Подойдёт для таблицы типа ИЗБРАННЫЕ_ТОВАРЫ,так как получение данных об избранных
товарах со стороны пользователя не может привести к ошибочным действиям при оформлении заказа,
а лишь при его выборе в процессе пользования, к примеру, интернет-магазина 
*/
go



-- ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬




