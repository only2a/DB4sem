use P_MyBase_3;

CREATE table ��������
(
�����_�������� nvarchar(10) primary key,
�������_�������� nvarchar(20),
���_�������� nvarchar(20),
��������_�������� nvarchar(20),
����_�������� real check(����_��������>0 AND ����_��������<47)
);

CREATE table ��������
(
�����������������_�����_�������� nvarchar(20) primary key,
������������_�������� nvarchar(20),
���������_�������� real not null,
����������_����_�_���� int
);
use P_MyBase_3;
CREATE table �����������
(
�����_�����������_�������������� nvarchar(10) primary key,
������� nvarchar(20) foreign key references ��������(�����������������_�����_��������),
������ int not null check(������>0),
����_�������� date,
����_����������� date,
�������� nvarchar(10) foreign key references ��������(�����_��������)
);

Select * From ��������


ALTER Table �������� ADD �����_��������_�������� nvarchar(20);
ALTER Table �������� DROP Column �����_��������_��������;
ALTER Table �������� ADD �������_�������� nvarchar(20) default '18' not null;
Alter Table �������� Drop DF__��������__������__5DCAEF64;


Select * From ��������
