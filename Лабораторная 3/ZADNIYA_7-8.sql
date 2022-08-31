USE master
GO
CREATE database P_MyBase_TSQL
ON PRIMARY
(name=N'Nek_MyBase_TSQL_mdf', filename = N'D:\2SEM\DataBase\лабы\Лабораторная 3\For DB\P_MyBase_TSQL_mdf.mdf',
size = 10240Kb, maxsize = UNLIMITED, filegrowth = 1024Kb),
(name = N'Nek_MyBase_TSQL_ndf', filename = N'D:\2SEM\DataBase\лабы\Лабораторная 3\For DB\P_MyBase_TSQL_ndf.ndf',
size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
(name = N'Nek_MyBase_TSQL_fg_1', filename = N'D:\2SEM\DataBase\лабы\Лабораторная 3\For DB\P_MyBase_TSQL_fg1.ndf',
size = 10240Kb, maxsize=1Gb, filegrowth=25%),
(name = N'Nek_MyBase_TSQL_fg_2', filename = N'D:\2SEM\DataBase\лабы\Лабораторная 3\For DB\P_MyBase_TSQL_fg2.ndf',
size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
(name = N'Nek_MyBase_TSQL_log', filename=N'D:\2SEM\DataBase\лабы\Лабораторная 3\For DB\P_MyBase_TSQL_log.ldf',
size=10240Kb, maxsize=2048Gb, filegrowth=10%)


use P_MyBase_TSQL;

CREATE table ВОДИТЕЛИ
(
Номер_водителя nvarchar(10) primary key,
Фамилия_водителя nvarchar(20),
Имя_водителя nvarchar(20),
Отчество_водителя nvarchar(20),
Стаж_водителя real check(Стаж_водителя>0 AND Стаж_водителя<47)
)on FG1;

CREATE table МАРШРУТЫ
(
Идентификациооный_номер_маршрута nvarchar(20) primary key,
Наименование_маршрута nvarchar(20),
Дальность_маршрута real not null,
Количество_дней_в_пути int
)on FG1;

CREATE table ВЫПОЛНЯЕМЫЕ
(
Номер_выполняемой_грузоперевозки nvarchar(10) primary key,
Маршрут nvarchar(20) foreign key references МАРШРУТЫ(Идентификациооный_номер_маршрута),
Оплата int not null check(Оплата>0),
Дата_отправки date,
Дата_возвращения date,
Водитель nvarchar(10) foreign key references ВОДИТЕЛИ(Номер_водителя)
)on FG1;