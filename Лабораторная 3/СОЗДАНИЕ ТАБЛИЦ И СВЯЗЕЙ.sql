use P_MyBase_3;

CREATE table ВОДИТЕЛИ
(
Номер_водителя nvarchar(10) primary key,
Фамилия_водителя nvarchar(20),
Имя_водителя nvarchar(20),
Отчество_водителя nvarchar(20),
Стаж_водителя real check(Стаж_водителя>0 AND Стаж_водителя<47)
);

CREATE table МАРШРУТЫ
(
Идентификациооный_номер_маршрута nvarchar(20) primary key,
Наименование_маршрута nvarchar(20),
Дальность_маршрута real not null,
Количество_дней_в_пути int
);
use P_MyBase_3;
CREATE table ВЫПОЛНЯЕМЫЕ
(
Номер_выполняемой_грузоперевозки nvarchar(10) primary key,
Маршрут nvarchar(20) foreign key references МАРШРУТЫ(Идентификациооный_номер_маршрута),
Оплата int not null check(Оплата>0),
Дата_отправки date,
Дата_возвращения date,
Водитель nvarchar(10) foreign key references ВОДИТЕЛИ(Номер_водителя)
);

Select * From МАРШРУТЫ


ALTER Table ВОДИТЕЛИ ADD Номер_телефона_водителя nvarchar(20);
ALTER Table ВОДИТЕЛИ DROP Column Номер_телефона_водителя;
ALTER Table ВОДИТЕЛИ ADD Возраст_водителя nvarchar(20) default '18' not null;
Alter Table ВОДИТЕЛИ Drop DF__ВОДИТЕЛИ__Возрас__5DCAEF64;


Select * From ВОДИТЕЛИ
