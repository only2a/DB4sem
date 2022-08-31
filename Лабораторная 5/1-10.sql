USE UNIVER;


--1 -- ������������ ������,������� ��������� �� ����������,�������������� ���������� �� ����������� �������������� 
select * from PULPIT
select * from FACULTY
select * from PROFESSION

SELECT DISTINCT PULPIT.PULPIT_NAME from PULPIT,FACULTY
		Where PULPIT.FACULTY = FACULTY.FACULTY and
		FACULTY.FACULTY
		in ( SELECT PROFESSION.FACULTY from PROFESSION 
		where (PROFESSION.PROFESSION_NAME Like '%����������%') or(PROFESSION.PROFESSION_NAME Like '%����������%'));

-- 2---- ������� 1 + [... inner join ... on ... and ... in(���������)]
--select * from PULPIT
select PULPIT.PULPIT_NAME[�������]
FROM PULPIT inner join FACULTY on
PULPIT.FACULTY=FACULTY.FACULTY and FACULTY.FACULTY in(
select PROFESSION.FACULTY
from PROFESSION
where (PROFESSION.PROFESSION_NAME Like '%����������%') or( PROFESSION.PROFESSION_NAME like '%����������%'));
-- 3-- ������� 1 + 3 inner'� 
select Distinct PULPIT.PULPIT_NAME[�������] 
from PULPIT inner join FACULTY on 
PULPIT.FACULTY=FACULTY.FACULTY
inner join PROFESSION on 
PROFESSION.FACULTY=FACULTY.FACULTY and ((PROFESSION.PROFESSION_NAME Like '%����������%') or( PROFESSION.PROFESSION_NAME like '%����������%'));

-- 4-- ������������� ������, ������������ ����������� ��������� ������� ����
select * from AUDITORIUM
SELECT AUDITORIUM_NAME,AUDITORIUM_CAPACITY,AUDITORIUM_TYPE FROM AUDITORIUM a
		Where AUDITORIUM = (select top(1) AUDITORIUM from AUDITORIUM aa
			Where aa.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)
															order by AUDITORIUM_CAPACITY desc;
-- 5-- ���������� ��� ������
select * from FACULTY
select * from PULPIT

select FACULTY.FACULTY_NAME[���������� ��� ������] from FACULTY
where not exists(select * from PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY)

-- 6-- ������� �������� ������ �� �����������
select * from PROGRESS
select top 1
   (select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='����')[����],
	(select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='��')[��],
	(select AVG(NOTE) from PROGRESS p
	where p.SUBJECT='����')[����]
from PROGRESS

-- 7-- ������������ ALL
select * from STUDENT
select * from PROGRESS
SELECT STUDENT.IDSTUDENT, STUDENT.[NAME] from STUDENT 
		Where STUDENT.IDSTUDENT in (select PROGRESS.IDSTUDENT from PROGRESS
		Where PROGRESS.NOTE < all(select PROGRESS.NOTE from PROGRESS
								Where PROGRESS.NOTE >= 5));

SELECT STUDENT.IDSTUDENT, STUDENT.[NAME] from STUDENT 
		Where STUDENT.IDSTUDENT in (select PROGRESS.IDSTUDENT from PROGRESS
		Where PROGRESS.NOTE > any(select PROGRESS.NOTE from PROGRESS
								Where PROGRESS.NOTE >= 8));


-- 9--
use P_MyBase_3;
select * from ��������
select * from �����������
select * from ��������

						--������������ ���������,������� ����������� ��������� �� ������ 5-14 ���--  
select ��������.������������_��������[�������]
FROM ��������
where ��������.�����������������_�����_�������� in
		(select  �����������.������� from �����������
			where �����������.�������� in
			(select  ��������.�����_�������� from ��������	
				where ��������.����_�������� between 5 and 14))


						--��������,������� �� �����������-- 
select ������������_��������[������������� ��������], �����������������_�����_�������� from ��������
where not exists(select * from �����������
where ��������.�����������������_�����_��������=�����������.�������)


					-- ��������� ���������� ���� � ���� ����������� ��������� � ������� 4400 � 3000--
select top(1)
	isnull((select SUM(����������_����_�_����) from �������� m
	where m.���������_��������=4400),'0')[4400] ,
	isnull((select SUM(����������_����_�_����) from �������� m
	where m.���������_��������=3000),'0')[3000] 
FROM ��������


							-- ������������ ���������� ���� � ���� �������� � ����������� ����������--
select ���������_��������, ����������_����_�_���� from �������� a
        Where �����������������_�����_��������=(select top(1) �����������������_�����_�������� from �������� aa
			Where aa.���������_��������=a.���������_�������� order by ����������_����_�_���� desc)
																order by ����������_����_�_���� desc;


						-- ��� ���������� ��������,������ ������� ������ ������� �� ������ ����������� ���������,����� �� ������� ������ ��� ����� 7000
SELECT ��������.�����������������_�����_��������, ��������.������������_�������� from �������� 
		Where ��������.�����������������_�����_�������� in(select �����������.������� from ����������� 
		Where �����������.������ < all(select �����������.������ from ����������� 
										Where �����������.������ >=7000));

						-- ��� ���������� ��������,������ ������� ������  ���� ����� ���� �� ������ �������� ������ �� ������(>=7000)
SELECT ��������.�����������������_�����_��������, ��������.������������_�������� from �������� 
		Where ��������.�����������������_�����_�������� in(select �����������.������� from ����������� 
		Where �����������.������ >= any(select �����������.������ from ����������� 
										Where �����������.������ >=7000));

-- 10--
use UNIVER

				-- �������� � ��� �������� � ���� ����
SELECT STUDENT.NAME,Day(BDAY)[���� ��������], STUDENT.BDAY FROM STUDENT WHERE DAY(BDAY)
IN ( SELECT DAY(BDAY) FROM STUDENT  GROUP BY DAY(BDAY) HAVING COUNT(DAY(BDAY)) > 1) group by Day(Bday),STUDENT.NAME,STUDENT.BDAY;


select DAY(BDAY) from STUDENT order by DAY(BDAY) 