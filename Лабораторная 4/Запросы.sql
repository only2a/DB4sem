use UNIVER;

-----1 -- ���-���
select * from AUDITORIUM
select * from AUDITORIUM_TYPE
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
      from AUDITORIUM inner join AUDITORIUM_TYPE
      on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
-----2 
select * from AUDITORIUM
select * from AUDITORIUM_TYPE
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
      from AUDITORIUM inner join AUDITORIUM_TYPE
      on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE and
            AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%���������%'
-----3 ������� ���������� 
select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM as A, AUDITORIUM_TYPE as A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE

select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM as A, AUDITORIUM_TYPE as A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE and
            A_T.AUDITORIUM_TYPENAME like '%���������%'
-----4 --�������� ���������,���������� ������ 6-8
select  FACULTY.FACULTY [���������], PROFESSION.PROFESSION_NAME [�������], PULPIT.PULPIT [�������������], SUBJECT.SUBJECT_NAME [����������], STUDENT.NAME [��� ��������],
      case 
      when (PROGRESS.NOTE = 6) then '�����'
      when (PROGRESS.NOTE = 7) then '����'
      when (PROGRESS.NOTE = 8) then '������'
      end [������]
    from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
      inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
      inner join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT
      inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
      inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
      inner join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
            where PROGRESS.NOTE between 6 and 8 order by PROGRESS.NOTE desc 
			
-----5 --���������� ����� CASE(������� 7��,����� 8��,� ����� 6��)
select  FACULTY.FACULTY [���������], PROFESSION.PROFESSION_NAME [�������], PULPIT.PULPIT [�������������], SUBJECT.SUBJECT_NAME [����������], STUDENT.NAME [��� ��������],
      case 
        when (PROGRESS.NOTE = 6) then '�����'
        when (PROGRESS.NOTE = 7) then '����'
        when (PROGRESS.NOTE = 8) then '������'
      end [������]
    from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
      inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
      inner join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT
      inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
      inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
      inner join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
            where PROGRESS.NOTE between 6 and 8 
            order by 
            (case
              when (PROGRESS.NOTE=6) then 3
              when (PROGRESS.NOTE=7) then 1
              else 2
            end)
-----6 --������ �������� ������ � �������������� �� ��������[isnull] 
select PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
    from PULPIT left outer join TEACHER
    on TEACHER.PULPIT = PULPIT.PULPIT
-----7 ������ ������ ������������� �������� �� �����-���� ��������, �� �� ��� ������ ������� ���� �������������
select PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
    from TEACHER right outer join PULPIT
    on TEACHER.PULPIT = PULPIT.PULPIT
-----8 --������������, ��� ��� ���������� �� ������� ������,�������������� ����� �� �������� 
drop table ��������
drop table �����������

CREATE table ��������
(
�����������������_�����_�������� nvarchar(20) primary key,
������������_�������� nvarchar(20),
���������_�������� real
);
INSERT into ��������(�����������������_�����_��������,������������_��������,���������_��������)
Values('c1','Brest-Minsk',300),
('b2','Pinsk-Tomck',1300),
('a3','Vilnus-Sochi',2300),
('e4','Mogilev-Paris',4500)

CREATE table �����������
(
�����_�����������_�������������� nvarchar(10) primary key,
������� nvarchar(20) foreign key references ��������(�����������������_�����_��������),
������ int not null check(������>0)
);

INSERT into �����������(�����_�����������_��������������,�������,������)
Values('1','a3',4300),
('2','b2',10230),
('3','c1',18000);

select * from ��������
select * from �����������
SELECT �����������.�����_�����������_��������������, �����������.������, ��������.������������_��������
FROM ����������� LEFT outer JOIN �������� ON �����������.������� = ��������.�����������������_�����_��������

SELECT isnull(�����������.�����_�����������_��������������,'###')[�����_��������������], isnull( �����������.������,0)[������],��������.������������_��������[�������]
FROM ����������� RIGHT outer JOIN �������� ON �����������.������� = ��������.�����������������_�����_��������


SELECT �����������.�����_�����������_��������������[�����_��������������], isnull( �����������.������,0)[������],��������.������������_��������[�������]
FROM ����������� FULL outer JOIN �������� ON �����������.������� = ��������.�����������������_�����_�������� 
where �����������.�����_�����������_�������������� is null

SELECT �����������.�����_�����������_��������������[�����_��������������], isnull( �����������.������,0)[������],��������.������������_��������[�������]
FROM ����������� FULL outer JOIN �������� ON �����������.������� = ��������.�����������������_�����_�������� 
where �����������.�����_�����������_�������������� is not null

SELECT isnull(�����������.�����_�����������_��������������,'###')[�����_��������������], isnull( �����������.������,0)[������], ��������.������������_��������
FROM �������� FULL outer JOIN ����������� ON �����������.������� = ��������.�����������������_�����_�������� order by ��������.������������_��������
-----9 -- ������� 1 ����� Cross join
select A.AUDITORIUM, A_T.AUDITORIUM_TYPENAME 
      from AUDITORIUM A cross join AUDITORIUM_TYPE A_T
      where A.AUDITORIUM_TYPE=A_T.AUDITORIUM_TYPE
-----10
use P_MyBase_3

select ��������.������������_��������, �����������.������, ��������.���_��������, ��������.�������_��������
      from ����������� inner join ��������
      on ��������.�����������������_�����_�������� = �����������.�������
	  inner join �������� on �����������.��������=��������.�����_��������
	  order by ��������.������������_��������
	  

select  ��������.�������_��������, �����������.������, 
      case 
        when (�����������.������ between 1000 and 5000) then '����'
        when (�����������.������ between 5000 and 10000) then '� �������� �����'
        when (�����������.������ > 10000) then '����������'
      end [������], ��������.������������_��������, ��������.���������_��������
    from ����������� inner join �������� on �����������.�������� = ��������.�����_��������
           inner join �������� on �����������.������� = ��������.�����������������_�����_�������� 
            order by �����������.������

select ��������.������������_��������, isnull (�����������.��������, '---') [�����_��������]
    from �������� right outer join  �����������
    on ��������.�����������������_�����_�������� = �����������.�������
        

select ��������.������������_��������,isnull (�����������.��������, '***') [�����_��������]
    from �������� left outer join  �����������
    on ��������.�����������������_�����_�������� = �����������.�������

	--select * from ��������;
	--select * from �����������;
select ��������.������������_��������, �����������.��������
    from �������� cross join  �����������


select ��������.������������_��������, �����������.��������
    from �������� cross join  �����������
	where ��������.�����������������_�����_��������=�����������.�������
-----11*
use UNIVER;
drop table TIMETABLE;
create table TIMETABLE
(
  ID varchar(6) primary key,
  GROUP_ int foreign key references GROUPS(IDGROUP),
  AUDITORIUM char(20) foreign key references AUDITORIUM(AUDITORIUM),
  SUBJECT char(10) foreign key references SUBJECT(SUBJECT),
  TEACHER char(10) foreign key references TEACHER(TEACHER),
  WEEKDAY nvarchar(20) check (WEEKDAY in('�����������','�������','�����','�������','�������','�������')),
  PARA nvarchar(20) check (PARA in('14:40-16:00','16:30-17:50','18:05-19:25','19:40-21:00','13:00-14:20','11:25-12:45'))
)
insert into TIMETABLE(ID, GROUP_, AUDITORIUM, SUBJECT, TEACHER, WEEKDAY, PARA)
    values  ('a1', 2, '313-1', '���', '���', '�����������', '14:40-16:00'),
        ('b1', 15, '236-1', '���', '������', '�������', '18:05-19:25'),
        ('c1', 1, NULL, NULL, NULL, '�����������', '18:05-19:25'),
        ('d1', 2, '408-2', '��', '��� ', '�������', '16:30-17:50'),
        ('e1', 2, '236-1', '��', '���', '�����������', '14:40-16:00'),
        ('f1', 2, '408-2', '��', '���', '�������', '16:30-17:50'),
        ('g1', 4, NULL, NULL, '���', '�������', '19:40-21:00'),
        ('h1', 5, NULL, NULL, '���', '�������', '11:25-12:45'),
        ('i1', 13, '423-1', '��', '�����', '�������', '11:25-12:45'),
        ('j1', 13, '413-1', '��', '���', '�������', '14:40-16:00'),
        ('k1', 13, '324-1', '������OO', '����', '�����������', '11:25-12:45'),
        ('l1', 7, NULL, NULL, NULL, NULL, '11:25-12:45'),
        ('m1', 10, NULL, NULL, '���', '�����������', '16:30-17:50'),
        ('n1', 2, NULL, NULL, NULL, '�����������', '19:40-21:00')

		--���������� ����� Case--
select * from TIMETABLE order by 
            (case
              when (TIMETABLE.WEEKDAY = '�����������') then 1
              when (TIMETABLE.WEEKDAY = '�������') then 2
              when (TIMETABLE.WEEKDAY = '�����') then 3
              when (TIMETABLE.WEEKDAY = '�������') then 4
              when (TIMETABLE.WEEKDAY = '�������') then 5
              when (TIMETABLE.WEEKDAY = '�������') then 6
            end)

			--������ ������ ��� � ���������,���������� ��� ���� ���
select TIMETABLE.WEEKDAY, TIMETABLE.PARA, AUDITORIUM.AUDITORIUM
    from TIMETABLE full outer join AUDITORIUM
    on  TIMETABLE.AUDITORIUM = AUDITORIUM.AUDITORIUM order by 
            (case
              when (TIMETABLE.WEEKDAY = '�����������') then 1
              when (TIMETABLE.WEEKDAY = '�������') then 2
              when (TIMETABLE.WEEKDAY = '�����') then 3
              when (TIMETABLE.WEEKDAY = '�������') then 4
              when (TIMETABLE.WEEKDAY = '�������') then 5
              when (TIMETABLE.WEEKDAY = '�������') then 6
            end)
			-- �������� � ���������� �������������
select TEACHER.TEACHER_NAME [�������������], TIMETABLE.WEEKDAY [���� ������], TIMETABLE.PARA [����]
    from TEACHER inner join TIMETABLE
    on TEACHER.TEACHER = TIMETABLE.TEACHER
      where TIMETABLE.SUBJECT is null
		--�������� �����	
select GROUPS.IDGROUP [������], isnull(TIMETABLE.WEEKDAY,'---') [���� ������], TIMETABLE.PARA [����]
    from GROUPS inner join TIMETABLE
    on GROUPS.IDGROUP = TIMETABLE.GROUP_
      where TIMETABLE.SUBJECT is null

	  select * from TIMETABLE