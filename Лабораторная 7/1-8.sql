use UNIVER;


-- 1--
go
CREATE VIEW [�������������]
as select   TEACHER			[���],
				TEACHER_NAME    [��� �������������],
				GENDER			[���],
				PULPIT			[��� �������]
				from TEACHER;
select * from �������������
-- 2--
go
CREATE VIEW [���������� ������]
as select		FACULTY_NAME		[���������],
				count(PULPIT)		[����������_������]
				from FACULTY inner join PULPIT
				on FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY_NAME;
insert [���������� ������] values('Bs',3);
select * from [���������� ������]
-- 3--
go
CREATE VIEW [���������]
as select		AUDITORIUM		[���],
				AUDITORIUM_NAME [������������ ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%'
          insert ��������� values ('308-3','308-3')

select * from [���������]
-- 4--
go
CREATE VIEW [���������� ���������]
as select		AUDITORIUM		[���],
				AUDITORIUM_TYPE [���],
				AUDITORIUM_NAME [������������ ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%'
			and AUDITORIUM_NAME = AUDITORIUM
			WITH CHECK OPTION
			insert [���������� ���������] values ('308-3','��','308-3');

select * from [���������� ���������]
-- 5--
go 
CREATE VIEW ����������
as select TOP 10	SUBJECT			[���],
					SUBJECT_NAME	[������������ ����������],
					PULPIT			[��� �������]
					from SUBJECT
					order by SUBJECT_NAME;
select * from ����������

-- 6--
go
ALTER VIEW [���������� ������] with SCHEMABINDING
as select		fclt.FACULTY_NAME		[���������],
				count(plpt.PULPIT)		[����������_������]
				from dbo.FACULTY fclt inner join dbo.PULPIT plpt
				on fclt.FACULTY = plpt.FACULTY group by FACULTY_NAME;
INSERT [���������� ������] values ('��',3);

-- 7--

use P_MyBase_3;
--*** 1

go
CREATE VIEW [�������]
as select   ������������_��������			[������������],
			���������_��������    [���������],
			�����������������_�����_��������	[�����]
			from ��������;
select * from �������
--***2
go
CREATE VIEW [����������_���������_�_��������]
as select		�����������.��������		[�����_��������],
				count(�����������.�������)		[���������� �������]
				from ����������� inner join ��������
				on ��������.�����_�������� = �����������.�������� group by �����������.��������;

select * from [����������_���������_�_��������]

--***3
go
CREATE VIEW [������������]
as select		�����_�������� [�����],
				�������_��������		[�������],
				����_�������� [����]
			from ��������
			where ����_�������� between 8 and 15;
insert [������������] values ('plk2','�����',12);

--***4
go
CREATE VIEW [�������_��������]
as select		�����������������_�����_��������		[���],
				������������_�������� [���],
				���������_�������� [���������],
				����������_����_�_���� [������������ ���������]
			from ��������
			where ������������_�������� like '%k%'
			and ����������_����_�_���� < 5
			WITH CHECK OPTION
			insert [�������_��������] values ('kjhd1','Kursk-Lvov',2000,2);

select * from [�������_��������]

-- 8--

go
CREATE VIEW ����������
as select TOP 150 [�����],[2 ������],[13 ������]
					from (select TOP 150	WEEKDAY	+ ' ' + CAST(PARA as varchar)		[�����],
					cast(GROUP_ as varchar)	+ ' ������'								[������],
					[SUBJECT] + ' ' + AUDITORIUM						[���������� � ���������]
					from TIMETABLE 
						 ) tbl
PIVOT
		( max([���������� � ���������]) 
		FOR ������
		in ([2 ������],[13 ������])
		) as rt
		order by 
					(CASE
					 when [�����] like '%�����������%' then 1
					 when [�����] like '%�������%' then 2
					 when [�����] like '%�����%' then 3
					 when [�����] like '%�������%' then 4
					 when [�����] like '%�������%' then 5
					 when [�����] like '%�������%' then 6
					 end) ;

select * from ����������					 