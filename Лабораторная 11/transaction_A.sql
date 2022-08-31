-- ----------------------------------------------------------------
--						ЗАДАНИЕ 4 (A - READ UNCOMMITTED)
-- ----------------------------------------------------------------
use UNIVER;
DBCC USEROPTIONS
---1
	set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_SUBJECT from SUBJECT;
	select COUNT(*) from SUBJECT; -- запускаем первую транзакцию, переходим в другой файл
---3
	select COUNT(*) STR_IN_SUBJECT from SUBJECT;
	select @@SPID 'SID', 'insert SUBJECT' 'результат', * from SUBJECT 
	                                                    where SUBJECT = 'СТПИ';													             
	select @@SPID 'SID', 'update AUDITORIUM'  'результат',  AUDITORIUM_NAME, 
                      AUDITORIUM_TYPE,AUDITORIUM_CAPACITY from AUDITORIUM   
														where  AUDITORIUM_NAME='301-1';
---5   
--	пункт 3;	
	commit tran; 

-- ----------------------------------------------------------------
--						ЗАДАНИЕ 5 (A - READ COMMITTED)
-- ----------------------------------------------------------------
use UNIVER;
DBCC USEROPTIONS
----- Покажем, что READ COMMITTED не допускает неподтвержденное(грязное) чтение 
---1
    set transaction isolation level READ COMMITTED 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;
---3
	select COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- Результат: ожидание неподтвержденного чтения
---5
	select COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- Сразу после отката транзакции результат: STR_IN_AUDITORIUM=11
	commit tran; 
----- Покажем, что READ COMMITTED допускает неповторяющееся чтение
---1
	set transaction isolation level READ COMMITTED 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 11
---3	
	select COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 12
	commit tran; 
-- ----------------------------------------------------------------
--						ЗАДАНИЕ 6 (A - REPEATABLE READ)
-- ----------------------------------------------------------------
----- Покажем, что REPEATABLE READ не допускает неповторяющееся чтение
---1   
	set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 12
---3
	commit tran;
	-- сразу после фиксации транзакции А пошло выполнение транзакции B
----- Покажем, что REPEATABLE READ допускает проблему фантомных записей
---1
	set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 11
---3
	select COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 12
	-- в рамках одной транзакции А два результата
	commit tran;
-- ----------------------------------------------------------------
--						ЗАДАНИЕ 7 (A - SERIALIZABLE)
-- ----------------------------------------------------------------
----- Покажем, что SERIALIZABLE не допускает проблему фантомных записей
---1
	set transaction isolation level SERIALIZABLE 
	begin transaction 
	select @@SPID 'SID', @@TRANCOUNT 'TRANCOUNT', COUNT(*) STR_IN_AUDITORIUM from AUDITORIUM;	-- результат: 12
---3
	commit tran;	--после выполнения этой команды, начнется выполнение транзакции B
-- ----------------------------------------------------------------