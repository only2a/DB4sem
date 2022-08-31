use P_MyBase_3;
go
create PROCEDURE PDEALS @find_year varchar(10)
as
begin
	select ������� '����� ��������',������ '������', ����_�������� '�����������', �������� '����� ��������' from ����������� where YEAR(����_�����������)= @find_year;
	print '���������: @find_year=' +@find_year;
	declare @k int = (select count(*) from �����������);
	return @k ;
end;

CREATE TABLE #DEALS
(�������		nvarchar(20)		not null,
������	int			,
����_��������		date		not null,
�������� nvarchar(10)
);

INSERT #DEALS exec PDEALS @find_year = '2021';

SELECT * FROM #DEALS;

DROP PROCEDURE PDEALS;
DROP TABLE #DEALS;


--------------------------------------------------
go
CREATE PROCEDURE ��������_INSERT @rd nvarchar(10), @nc nvarchar(20), @ni nvarchar(20),@no nvarchar(20), @v real
as

	declare @ret int = 1;

	begin try
		INSERT into ��������(�����_��������,���_��������,�������_��������,��������_��������,����_��������)
			values(@rd,@nc,@ni,@no,@v);
		return  @ret;
	end try

	begin catch
		print '��� ������: ' + cast(ERROR_NUMBER() as varchar(6));
		print '��������� �� ������: ' + ERROR_MESSAGE();
		print '������ ������: ' + cast(ERROR_LINE()as varchar(8));
		if ERROR_PROCEDURE() is not null
			print '��� ��������� ������: ' + ERROR_PROCEDURE();
		print '������� ����������� ������: ' + cast(ERROR_SEVERITY()as varchar(6));
		print '����� ������: ' + cast(ERROR_STATE()as varchar(8));
		return -1;
	end catch;

DECLARE @paud int = 0;
EXEC @paud = ��������_INSERT @rd='ldsa',@nc='Viktoria',@ni='Pilipovich',@no='Sergeevna', @v=14.3;	
select * from ��������;

DELETE �������� where �����_��������='ldsa';

DROP PROCEDURE ��������_INSERT;