use P_MyBase_3;
go
create PROCEDURE PDEALS @find_year varchar(10)
as
begin
	select Маршрут 'Номер маршрута',Оплата 'Оплата', Дата_отправки 'Отправление', Водитель 'Номер водителя' from ВЫПОЛНЯЕМЫЕ where YEAR(Дата_возвращения)= @find_year;
	print 'параметры: @find_year=' +@find_year;
	declare @k int = (select count(*) from ВЫПОЛНЯЕМЫЕ);
	return @k ;
end;

CREATE TABLE #DEALS
(Маршрут		nvarchar(20)		not null,
Оплата	int			,
Дата_отправки		date		not null,
Водитель nvarchar(10)
);

INSERT #DEALS exec PDEALS @find_year = '2021';

SELECT * FROM #DEALS;

DROP PROCEDURE PDEALS;
DROP TABLE #DEALS;


--------------------------------------------------
go
CREATE PROCEDURE ВОДИТЕЛИ_INSERT @rd nvarchar(10), @nc nvarchar(20), @ni nvarchar(20),@no nvarchar(20), @v real
as

	declare @ret int = 1;

	begin try
		INSERT into ВОДИТЕЛИ(Номер_водителя,Имя_водителя,Фамилия_водителя,Отчество_водителя,Стаж_водителя)
			values(@rd,@nc,@ni,@no,@v);
		return  @ret;
	end try

	begin catch
		print 'Код ошибки: ' + cast(ERROR_NUMBER() as varchar(6));
		print 'Сообщение об ошибке: ' + ERROR_MESSAGE();
		print 'Строка ошибки: ' + cast(ERROR_LINE()as varchar(8));
		if ERROR_PROCEDURE() is not null
			print 'Имя процедуры ошибки: ' + ERROR_PROCEDURE();
		print 'Уровень серьёзности ошибки: ' + cast(ERROR_SEVERITY()as varchar(6));
		print 'Метка ошибки: ' + cast(ERROR_STATE()as varchar(8));
		return -1;
	end catch;

DECLARE @paud int = 0;
EXEC @paud = ВОДИТЕЛИ_INSERT @rd='ldsa',@nc='Viktoria',@ni='Pilipovich',@no='Sergeevna', @v=14.3;	
select * from ВОДИТЕЛИ;

DELETE ВОДИТЕЛИ where Номер_водителя='ldsa';

DROP PROCEDURE ВОДИТЕЛИ_INSERT;