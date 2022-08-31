use UNIVER;

-- 1--
-- �������� ���������� ���� char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
-- ������ ��� ���������� ���������-���������� � ��������� ����������;
-- ��������� ������������ �������� ��������� ���� ���������� � ����-��� ��������� SET, ����� �� ���� ��-�������� ��������� ��������, �������-��� � ���������� ������� SELECT; 
-- ���� �� ���������� �������� ��� ������������� � �� ����������� �� ���-�����, ���������� ���������� ������-��� ��������� �������� � ������� ��������� SELECT; 
-- �������� ����� �������� �������-��� ������� � ������� ��������� SE-LECT, �������� ������ �������� ����-������ ����������� � ������� �����-���� PRINT. 

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
--������������ ����� ����������� ����-�����. ����� ����� ����������� ���-������ 200,
--�� ������� ���������� ���������, ������� ����������� ����-�����, ���������� ���������,
--������-����� ������� ������ �������, � ���-���� ����� ���������.
--����� ����� ����������� ��������� ������ 200, �� ������� ��������� � ������� ����� �����������

DECLARE @capacity int = (select cast(sum(AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
		@q int = (select cast(count(*) as int) from AUDITORIUM),
		@avg int = (select cast(avg(AUDITORIUM_CAPACITY) as int) from AUDITORIUM);

DECLARE	@lessavg int =  (select cast(count(*) as int) from AUDITORIUM where AUDITORIUM_CAPACITY < @avg);
DECLARE	@percent float =  cast(cast(@lessavg as float) / cast(@q as float) * 100  as float);
		
	IF @capacity > 200
		begin 
		SELECT @q '���������� ���������',			@avg '������� ����������� ���������',
			   @lessavg  '����������� < �������',		cast(@percent as varchar) + '%'   '������� �� ����� ���-�� ���������'
		end
	ELSE IF @capacity < 200
		begin
		PRINT @capacity
		end;

-- 3--
--											���������� ����������
print '����� ������������ �����: ' +										cast(@@ROWCOUNT as varchar);
print '������ SQL Server: ' +												@@VERSION  ;
print '��������� ������������� �������� ' +
	  '����������� �������� �������� ���-��������: ' +						cast(@@SPID  as varchar);
print '��� ��������� ������: ' +											cast(@@ERROR as varchar);	
print '��� �������: ' +														@@SERVERNAME  ;
print '������� ����������� ����������: ' +									cast(@@TRANCOUNT as varchar);
print '�������� ���������� ���������� ����� ��������������� ������: ' +		cast(@@FETCH_STATUS as varchar);
print '������� ����������� ������� ���������: ' +							cast(@@NESTLEVEL as varchar);

-- 4--
-- �������������� ������� ��� �������� � ����������� 
-- ����� ���������, � ������� ���� ���-����� � ��������� ������, � ��������-��� �� ��������;
-- ����� ��� ������, � ������� ���-����� ��������� ������ ������� ����-��� �� ����.

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

select * from (select *, DATEDIFF(YEAR,BDAY,GETDATE())-10 ������� from STUDENT where MONTH(BDAY)  = MONTH(GETDATE()) + 1) as tr;

select * from (select *,
						(CASE 
							when DATEPART(weekday,PDATE) = 1 then '�����������'
							when DATEPART(weekday,PDATE) = 2 then '�������'
							when DATEPART(weekday,PDATE) = 3 then '�����'
							when DATEPART(weekday,PDATE) = 4 then '�������'
							when DATEPART(weekday,PDATE) = 5 then '�������'
							when DATEPART(weekday,PDATE) = 6 then '�������'
							when DATEPART(weekday,PDATE) = 7 then '�����������'
						end) [���� ������] from PROGRESS where SUBJECT like '%����%') as tr;

-- 5--
-- ������������������ ����������� IF� ELSE �� ������� ������� ������ ���-��� ���� ������ �_UNIVER.
SELECT STUDENT.IDGROUP, round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
			From STUDENT inner join GROUPS
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
				group by STUDENT.IDGROUP

DECLARE @gr varchar(3) = '3';
DECLARE @ttp float(2) = (SELECT round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
			From STUDENT inner join GROUPS
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT  where STUDENT.IDGROUP = @gr
				group by STUDENT.IDGROUP);

IF (@ttp  <= 4)
	begin 
	PRINT '������������ ������ ����� ' + cast(@gr as varchar) + ' ������. ������� ����: ' +  cast(@ttp as varchar);
	end
ELSE IF (@ttp  > 4 and @ttp  < 8)
	begin 
	PRINT '������������ ������ ����� ' + cast(@gr as varchar) + ' �������. ������� ����: ' + cast(@ttp as varchar);
	end
ELSE IF (@ttp  > 8)
	begin 
	PRINT '������������ ������ ����� ' + cast(@gr as varchar) + ' �������. ������� ����: ' + cast(@ttp as varchar);
	end

-- 6--
 --  � ������� CASE ������������� ����-��, ���������� ���������� ���������� ���������� ��� ����� ���������.
select case
when NOTE between 1 and 4 then '�������������������'
	when NOTE between 5 and 7 then '������'
	when NOTE between 8 and 10 then '�������'
	end ������,count(*)[����������]
	from 
	PROGRESS p inner join SUBJECT s on p.SUBJECT=s.SUBJECT 
			   inner join PULPIT p2 on s.PULPIT=p2.PULPIT 
			   inner join FACULTY f on p2.FACULTY=f.FACULTY
 Where f.FACULTY = '��'
 group by 
 case
  when NOTE between 1 and 4 then '�������������������'
	when NOTE between 5 and 7 then '������'
	when NOTE between 8 and 10 then '�������'
	end

-- 7--
--  ������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. ������������ �������� WHILE.
--DROP TABLE #TEMP1;
CREATE TABLE #TEMP1
		(
			ID int identity(1,1),
			RANDOM_NUMBER int,
			WORD varchar(50) default '�������� �� ���������'
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
--����������� ������, ��������������� ������������� ��������� RETURN.
declare @xx int=3;
print @xx+10;
print @xx*10;
return
print @xx+1;



-- 9--

use P_MyBase_3
begin try
update �������� set ���������_��������='��'
end try 
begin catch
print '��� ������: '+ cast( ERROR_NUMBER() as varchar(10))
print '��������� �� ������: ' + cast(ERROR_MESSAGE() as varchar(190))
print '������ ������: ' + cast(ERROR_LINE() as varchar(10))
print '��� ��������� ������: ' + isnull(cast(ERROR_PROCEDURE() as varchar(10)),'null')
print '������� ����������� ������: ' + cast(ERROR_SEVERITY() as varchar(10))
print '����� ������: ' + cast(ERROR_STATE() as varchar(10))
end catch