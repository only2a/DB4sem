use P_MyBase_3;
UPDATE ВОДИТЕЛИ set Стаж_водителя = Стаж_водителя+2 Where Фамилия_водителя='Zelenski';

Select Фамилия_водителя,Стаж_водителя From ВОДИТЕЛИ

INSERT into ВОДИТЕЛИ(Номер_водителя,Фамилия_водителя,Имя_водителя,Отчество_водителя,Стаж_водителя)
Values('kkk6','Dubrovski','Makar','Andreevich',15);

Delete from ВОДИТЕЛИ Where Фамилия_водителя='Dubrovski';