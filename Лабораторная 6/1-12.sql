--��� 6--

use UNIVER;

-- 1--
SELECT min(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �����������],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [����� ������������]
FROM AUDITORIUM;


-- 2-- ��� ������� ���� ��������� ���������-���, �����������, ������� ����������� ���������, ��������� ����������� ���� ��������� � ����� ���������� ��������� ������� ����. 
select AUDITORIUM_TYPE.AUDITORIUM_TYPE,AUDITORIUM_TYPE.AUDITORIUM_TYPENAME ,
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �����������],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [����� ������������]
FROM AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME;

-- 3-- ���������� ��������������� ������ � ��-������ ���������
SELECT * 
	FROM (select CASE 
					when NOTE between 4 and 5 then '4-5'
					when NOTE between 6 and 7 then '6-7'
					when NOTE between 8 and 9 then '8-9'
					when NOTE = 10 then '10'
		 end [������], COUNT(*) [����������]
		 From PROGRESS Group By Case
					when NOTE between 4 and 5 then '4-5'
					when NOTE between 6 and 7 then '6-7'
					when NOTE between 8 and 9 then '8-9'
					when NOTE = 10 then '10' 
		 end) as T  
	order by CASE [������] 
		when '10' then 1
		when '8-9' then 2
		when '6-7' then 3
		when '4-5' then 4
		else 0
		end;

-- 4-- �������� ������� ��������������� ����-�� ��� ������� ����� ������ ����������-���.
SELECT FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST-2010[����], 
			round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
			From FACULTY inner join GROUPS
				on FACULTY.FACULTY = GROUPS.FACULTY
				inner join STUDENT
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
				group by FACULTY.FACULTY,GROUPS.PROFESSION,GROUPS.YEAR_FIRST
				order by [������� ������]  desc


SELECT FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST-2010[����],PROGRESS.SUBJECT, 
			round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
			From FACULTY inner join GROUPS
				on FACULTY.FACULTY = GROUPS.FACULTY
				inner join STUDENT
				on GROUPS.IDGROUP = STUDENT.IDGROUP
				inner join PROGRESS
				on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT and (PROGRESS.[SUBJECT] ='����' or PROGRESS.[SUBJECT] ='��')
				group by FACULTY.FACULTY,GROUPS.PROFESSION ,GROUPS.YEAR_FIRST,PROGRESS.SUBJECT
				order by [������� ������] desc
-- 5-- �������������, ���������� � ������� ������ ��� ����� ��������� �� ���������� ��

select * from STUDENT
select * from FACULTY
select * from PROFESSION
select * from GROUPS
select * from PROGRESS

SELECT FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM GROUPS inner join STUDENT
		on GROUPS.IDGROUP= STUDENT.IDGROUP
		inner join FACULTY
		on FACULTY.FACULTY = GROUPS.FACULTY
		inner join PROGRESS
		on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where GROUPS.FACULTY = '���'
		group by ROLLUP(GROUPS.PROFESSION,FACULTY.FACULTY, PROGRESS.SUBJECT);




	/*	insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values  ('������OO  ', 1067,  '01.10.2013',8),
           ('������OO  ', 1068,  '01.10.2013',7),
           ('������OO  ', 1069,  '01.10.2013',5),
           ('������OO  ', 1070,  '01.10.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values   ('��', 1071,  '01.12.2013',5),
           ('��', 1072,  '01.12.2013',9),
           ('��', 1073,  '01.12.2013',5),
           ('��', 1074,  '01.12.2013',4)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values ('���       ',   1075,  '06.5.2013',4),
           ('���       ',   1076,  '06.05.2013',7),
           ('���       ',   1077,  '06.05.2013',7),
           ('���       ',   1078,  '06.05.2013',9),
           ('���       ',   1079,  '06.05.2013',5),
           ('���       ',   1080,  '06.05.2013',6)*/

-- 6-- �.5 � �������������� CUBE-�����������
use UNIVER
SELECT FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP
		inner join FACULTY
		on GROUPS.FACULTY = FACULTY.FACULTY 
		where FACULTY.FACULTY = '��'
		group by CUBE(GROUPS.PROFESSION,FACULTY.FACULTY, PROGRESS.[SUBJECT]);

-- 7-- ������������ ���������� ����� ���������.
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		UNION 
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '���'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [������� ������] desc;

-- 7.2--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		UNION ALL
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '���'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [������� ������] desc;

-- 8--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		INTERSECT
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [������� ������] desc;

-- 9--
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY ,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		EXCEPT
SELECT GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT], round(avg(cast(PROGRESS.NOTE as float(2))),2) [������� ������]
		FROM PROGRESS inner join STUDENT
		on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
		inner join GROUPS
		on STUDENT.IDGROUP = GROUPS.IDGROUP and GROUPS.FACULTY = '��'
		GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION, PROGRESS.[SUBJECT]
		order by [������� ������] desc;

--10 -- ��� ������ ���������� ���������� ���-������, ���������� ������ 8 � 9. 
select * from Progress	
SELECT DISTINCT  t1.SUBJECT, (SELECT count(*) from PROGRESS t2
			where t1.SUBJECT = t2.SUBJECT
				and( NOTE = '8' or  NOTE = '9') ) [���������� 8 � 9]
			From Progress t1	
						GROUP BY SUBJECT,NOTE HAVING NOTE = '8' or  NOTE = '9' 
--11 --
use P_MyBase_3;

SELECT min(��������.���������_��������) [����������� ���������],
	   max(��������.���������_��������) [������������ ���������],
	   avg(��������.���������_��������) [������� ���������],
	   sum(��������.���������_��������) [����� ����������]
FROM ��������;


SELECT * 
	FROM (select CASE 
					when ������ between 0 and 5000 then '0-5000'
					when ������ between 5001 and 10000 then '5000-10000'
					when ������ between 10001 and 15000 then '10000-15000'
		 end [������], COUNT(*) [����������]
		 From ����������� Group By  (Case
					when ������ between 0 and 5000 then '0-5000'
					when ������ between 5001 and 10000 then '5000-10000'
					when ������ between 10001 and 15000 then '10000-15000'
		 end)) as T  
	order by CASE [������] 
		when '0-5000' then 1
		when '5000-10000' then 2
		when '10000-15000' then 3
		else 0
		end;


SELECT ��������.���������_��������, �����������.������, ��������.����_��������, round(avg(cast(����������_����_�_���� as float(2))),2) [������� ���������� ���� � ����]
		FROM �������� inner join �����������
		on ��������.�����������������_�����_��������= �����������.�������
		inner join ��������
		on ��������.�����_�������� = �����������.��������
		group by ROLLUP(��������.���������_��������,�����������.������, ��������.����_��������);

--12 --


 --***���������� ��������� � ������ ������, �� ������ ���������� � ����� � ������������
select isnull(f.FACULTY, '�����') [���������], s.IDGROUP [������], COUNT(*) [���-�� ���������]
from GROUPS g	join STUDENT s on s.IDGROUP = g.IDGROUP
				join FACULTY f on f.FACULTY = g.FACULTY
group by rollup (f.FACULTY, s.IDGROUP)

--***���������� ��������� �� ����� � ��������� ����������� � �������� � ����� 
select isnull(a.AUDITORIUM_TYPE, '�����') [��� ���������], 
CASE 
					when a.AUDITORIUM like '%1' then '1'
					when a.AUDITORIUM like '%2' then '2'
					when a.AUDITORIUM like '%3' then '3'
		 end as '������', SUM(AUDITORIUM_CAPACITY) [��������� �����������]
from AUDITORIUM a	join AUDITORIUM_TYPE a2 on a2.AUDITORIUM_TYPE = a.AUDITORIUM_TYPE
group by rollup (a.AUDITORIUM_TYPE,CASE 
					when a.AUDITORIUM like '%1' then '1'
					when a.AUDITORIUM like '%2' then '2'
					when a.AUDITORIUM like '%3' then '3'
		 end)

