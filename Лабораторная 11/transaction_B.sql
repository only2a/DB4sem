-- ----------------------------------------------------------------
--						ЗАДАНИЕ 4 (B - READ COMMITTED) select * from Subject
-- ----------------------------------------------------------------
use UNIVER;
DBCC USEROPTIONS
---2
	begin transaction		-- открываем параллельную транзакцию
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';	-- возвращает системный идентификатор процесса
	-- модифицируем табл
	INSERT into SUBJECT values('СТПИ','Современные технологии программирования в  интернете','ИСиТ');   
	update AUDITORIUM set AUDITORIUM_CAPACITY = '15' where AUDITORIUM_NAME='301-1';	
---4
	rollback;		-- откатываем транзакцию
-- ----------------------------------------------------------------
--						ЗАДАНИЕ 5 (B - READ COMMITTED)
-- ----------------------------------------------------------------
use UNIVER;
DBCC USEROPTIONS
--delete AUDITORIUM where AUDITORIUM_NAME='128-1';
select * from AUDITORIUM
---2	
	begin transaction
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';
    insert into AUDITORIUM values('310a-1','ЛБ-К','30','310a-1');
---4
	rollback tran;
-- ****************************************************************
---2	
	begin transaction
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';
    insert into AUDITORIUM values('310a-1','ЛБ-К','30','310a-1');
	commit tran;
-- ----------------------------------------------------------------
--						ЗАДАНИЕ 6 (B - READ COMMITTED)
-- ----------------------------------------------------------------
---2
	begin tran
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';
    delete from AUDITORIUM where AUDITORIUM = '310a-1';
---4
	commit tran;
-- ****************************************************************
---2
	begin tran
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';
	insert into AUDITORIUM values('310a-1','ЛБ-К','30','310a-1');	-- изменения прошли
	commit tran;
-- ----------------------------------------------------------------
--						ЗАДАНИЕ 7 (B - READ COMMITTED)
-- ----------------------------------------------------------------
---2
	begin tran
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT';
    delete from AUDITORIUM where AUDITORIUM = '310a-1';	-- ожидание
	commit tran;
-- ----------------------------------------------------------------
	
