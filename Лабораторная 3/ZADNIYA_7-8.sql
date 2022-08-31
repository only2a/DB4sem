USE master
GO
CREATE database P_MyBase_TSQL
ON PRIMARY
(name=N'Nek_MyBase_TSQL_mdf', filename = N'D:\2SEM\DataBase\����\������������ 3\For DB\P_MyBase_TSQL_mdf.mdf',
size = 10240Kb, maxsize = UNLIMITED, filegrowth = 1024Kb),
(name = N'Nek_MyBase_TSQL_ndf', filename = N'D:\2SEM\DataBase\����\������������ 3\For DB\P_MyBase_TSQL_ndf.ndf',
size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
(name = N'Nek_MyBase_TSQL_fg_1', filename = N'D:\2SEM\DataBase\����\������������ 3\For DB\P_MyBase_TSQL_fg1.ndf',
size = 10240Kb, maxsize=1Gb, filegrowth=25%),
(name = N'Nek_MyBase_TSQL_fg_2', filename = N'D:\2SEM\DataBase\����\������������ 3\For DB\P_MyBase_TSQL_fg2.ndf',
size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
(name = N'Nek_MyBase_TSQL_log', filename=N'D:\2SEM\DataBase\����\������������ 3\For DB\P_MyBase_TSQL_log.ldf',
size=10240Kb, maxsize=2048Gb, filegrowth=10%)


use P_MyBase_TSQL;

CREATE table ��������
(
�����_�������� nvarchar(10) primary key,
�������_�������� nvarchar(20),
���_�������� nvarchar(20),
��������_�������� nvarchar(20),
����_�������� real check(����_��������>0 AND ����_��������<47)
)on FG1;

CREATE table ��������
(
�����������������_�����_�������� nvarchar(20) primary key,
������������_�������� nvarchar(20),
���������_�������� real not null,
����������_����_�_���� int
)on FG1;

CREATE table �����������
(
�����_�����������_�������������� nvarchar(10) primary key,
������� nvarchar(20) foreign key references ��������(�����������������_�����_��������),
������ int not null check(������>0),
����_�������� date,
����_����������� date,
�������� nvarchar(10) foreign key references ��������(�����_��������)
)on FG1;