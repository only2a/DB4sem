USE [UNIVER]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 16.05.2022 0:34:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PSUBJECT] @p varchar(20), @c int output
as
begin
	select SUBJECT 'Код',SUBJECT_NAME 'Дисциплина', PULPIT 'Кафедра' from SUBJECT where PULPIT= @p;
	set @c  = @@ROWCOUNT;
	print 'параметры: @p=' + @p + ',@c =' + cast(@c as varchar(3));
	declare @k int = (select count(*) from SUBJECT);
	return @k ;
end;