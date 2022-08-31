declare @tc char(50), @rn char(50);
declare SCROLL_CURSOR cursor local dynamic scroll --динамический курсор и SCROLL, позволяющий применять оператор FETCH с дополнительными опциями позиционирования.
for select row_number() over (order by Фамилия_водителя) N,
Фамилия_водителя from ВОДИТЕЛИ
open SCROLL_CURSOR;
fetch first from SCROLL_CURSOR into @tc, @rn;
print 'первая строка					:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch next from SCROLL_CURSOR into @tc, @rn;
print 'слудующая строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch last from  SCROLL_CURSOR into @tc, @rn;
print 'последняя строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch prior from SCROLL_CURSOR into @tc, @rn;
print 'предыдущая строка				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch absolute 3 from SCROLL_CURSOR into @tc, @rn;
print '3 строка с начала				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch absolute -3 from SCROLL_CURSOR into @tc, @rn;
print '3 строка с конца				:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch relative 5 from SCROLL_CURSOR into @tc, @rn;
print '5 строка с текущей позиции		:' + cast(@tc as varchar(3))+rtrim(@rn);
fetch relative -5 from SCROLL_CURSOR into @tc, @rn;
print '5 строка назад с текущей позиции:' + cast(@tc as varchar(3))+rtrim(@rn);
close SCROLL_CURSOR;
  select * from ВОДИТЕЛИ order by Фамилия_водителя

------------------------------------------------------


go
DECLARE ЗАКАЗЫ_CURSOR CURSOR LOCAL STATIC for select Номер_выполняемой_грузоперевозки,Оплата,Дата_отправки,Дата_возвращения from ВЫПОЛНЯЕМЫЕ where YEAR(ВЫПОЛНЯЕМЫЕ.Дата_отправки) = '2021';
DECLARE @number nvarchar(10),@salary int, @fromdate date,@todate date;

OPEN ЗАКАЗЫ_CURSOR;
print 'Заказы за 2021:';
FETCH ABSOLUTE 1 from ЗАКАЗЫ_CURSOR into @number,@salary,@fromdate,@todate;
while @@FETCH_STATUS = 0
	begin
		print  CHAR(10) +
'Номер заказа: '+ rtrim(@number)  +
'. Оплата заказа: '  + rtrim(@salary) + 
'. Дата отправки: '  + rtrim(@fromdate) + 
'. Дата возвращения: ' + rtrim(@todate);
	FETCH ЗАКАЗЫ_CURSOR into @number,@salary,@fromdate,@todate;
	end;
CLOSE ЗАКАЗЫ_CURSOR;