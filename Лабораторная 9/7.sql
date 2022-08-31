use P_MyBase_3;

CREATE INDEX ДАТА_ОТПРАВЛЕНИЯ_INDEX on ВЫПОЛНЯЕМЫЕ(Дата_отправки);
DROP INDEX ВЫПОЛНЯЕМЫЕ.ДАТА_ОТПРАВЛЕНИЯ_INDEX;

SELECT Дата_отправки FROM ВЫПОЛНЯЕМЫЕ t where Дата_отправки > '01.01.2022' and Дата_отправки < '01.03.2022';

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)]
	FROM sys.dm_db_index_physical_stats(DB_ID(N'P_MyBase_3'), 
	OBJECT_ID(N'ДАТА_ОТПРАВЛЕНИЯ_INDEX'),NULL,NULL,NULL) ss
	inner JOIN sys.indexes ii on ss.index_id = ii.index_id and ss.object_id = ii.object_id
											WHERE name is not null;
-- НАЧАЛЬНАЯ СТОИМОСТЬ: 0.0032886 ▬ КОНЕЧНАЯ СТОИМОСТЬ: 0.0032853
-- ФРАГМЕНТАЦИЯ - 0%

CREATE INDEX СТАЖ_INDEX on ВОДИТЕЛИ(Стаж_водителя) where (Стаж_водителя >= 10 and Стаж_водителя <= 20);
DROP index ВОДИТЕЛИ.СТАЖ_INDEX
SELECT Стаж_водителя from ВОДИТЕЛИ where Стаж_водителя >= 10 and Стаж_водителя <= 20;
-- НАЧАЛЬНАЯ СТОИМОСТЬ: 0.0032897 ▬ КОНЕЧНАЯ СТОИМОСТЬ: 0.0032875
-- ФРАГМЕНТАЦИЯ - 0%