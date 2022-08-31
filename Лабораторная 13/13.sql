--								ЗАДАНИЕ 1
go 
create function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin 
declare @ret int = 0;
set @ret = (select count(IDSTUDENT) from 
			[GROUPS] inner join FACULTY 
			on [GROUPS].FACULTY = FACULTY.FACULTY inner join STUDENT
			on STUDENT.IDGROUP = [GROUPS].IDGROUP where [GROUPS].FACULTY = @faculty);
return @ret;
end;

DROP FUNCTION COUNT_STUDENTS;

declare @faculty_name char(10) = 'ИТ';
declare @f_result int = dbo.COUNT_STUDENTS(@faculty_name);
print 'Количество студентов факультета ' + rtrim(@faculty_name) + ': ' + cast(@f_result as varchar);

--								ЗАДАНИЕ 2
go
create function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
DECLARE Discipline CURSOR LOCAL for select [SUBJECT_NAME] from [SUBJECT] where [SUBJECT].PULPIT = @p;
DECLARE @subject varchar(60), @subject_ot varchar(300) ='';
OPEN Discipline;
FETCH Discipline into @subject;
while @@FETCH_STATUS = 0
	begin
		set @subject_ot = RTRIM(@subject) +', ' +  @subject_ot;
		FETCH  Discipline into @subject;
	end;
CLOSE Discipline;
set @subject_ot = '•Дисциплины: ' + @subject_ot;
return @subject_ot;
end;

DROP FUNCTION FSUBJECTS;

select PULPIT.PULPIT 'Кафедра', dbo.FSUBJECTS(PULPIT.PULPIT) 'Дисцплины кафедры' from PULPIT;

--								ЗАДАНИЕ 3

go
create function FFACPUL(@faculty varchar(20), @pulpit varchar(20)) returns table
as return 
	select FACULTY.FACULTY,PULPIT.PULPIT from
		FACULTY left outer join PULPIT
		on FACULTY.FACULTY = PULPIT.FACULTY
		where FACULTY.FACULTY = isnull(@faculty,FACULTY.FACULTY)and
			PULPIT.PULPIT = isnull(@pulpit,PULPIT.PULPIT);

DROP FUNCTION FFACPUL;

select * from dbo.FFACPUL(NULL,NULL);
select * from dbo.FFACPUL('ТТЛП',NULL);
select * from dbo.FFACPUL(NULL,'ИСиТ');
select * from dbo.FFACPUL('ЛХ','ТиП');
select * from dbo.FFACPUL('ЛХФ','ЛУ');

--								ЗАДАНИЕ 4

go
create function FTEACHER (@pulpit varchar(20)) returns int
as begin
		declare @result int = 0;
		set @result  = (select count(*) from
									TEACHER inner join PULPIT
									on TEACHER.PULPIT = PULPIT.PULPIT
									where PULPIT.PULPIT = isnull(@pulpit,PULPIT.PULPIT));
		return @result;
end;

DROP FUNCTION FTEACHER;

select PULPIT, dbo.FTEACHER(PULPIT.PULPIT) 'Количество преподавателей ☺' from PULPIT;
select dbo.FTEACHER(NULL) 'Всего преподавателей';


--							ЗАДАНИЕ 6
--4. Скалярная ф., один парам (код кафедры)
-- возвр. кол-во преподов на зад.кафедре
-- если (NULL), возвр. общее кол-во преподавов
go
create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select PULPIT, dbo.FCTEACHER(PULPIT)[Количество преподавателей] from TEACHER;
select dbo.FCTEACHER(null)[Общее количество преподавателей];

--подсчет количества студентов на факультете
go
create function COUNT_stud(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(NAME)
from STUDENT z join GROUPS zk
on z.IDGROUP=zk.IDGROUP
where FACULTY = @f) ;
return @rc;
end;
select dbo.COUNT_stud('ИТ')
end
--подсчет количества кафедр на факультете

go

create function COUNT_pulpit(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(PULPIT) from PULPIT where FACULTY = @f) ;
return @rc;
end;
select dbo.COUNT_pulpit('ИТ')

--подсчет количества групп на факультете

go
create function COUNT_group(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(IDGROUP) from GROUPS where FACULTY = @f) ;
return @rc;
end;
select dbo.COUNT_group('ИТ')

--подсчет количества специальностей на факультете
go
create function COUNT_prof(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(PROFESSION) from PROFESSION where FACULTY = @f) ;
return @rc;
end;
select dbo.COUNT_prof('ИТ')

--
go
create function FACULTY_REPORT(@c varchar(20))
returns @fr table
( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп] int,
[Количество студентов] int, [Количество специальностей] int )

begin
insert @fr values( @c,
(select dbo.COUNT_pulpit(@c)),
(select dbo.COUNT_group(@c)),
(select dbo.COUNT_stud(@c)),
(select dbo.COUNT_prof(@c))
);

return; end;

drop function FACULTY_REPORT

select * from dbo.FACULTY_REPORT('ИТ');



---------------------------

