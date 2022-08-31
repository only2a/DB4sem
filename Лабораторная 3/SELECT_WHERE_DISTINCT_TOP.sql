use P_MyBase_3;

SELECT * From ВЫПОЛНЯЕМЫЕ

SELECT Маршрут,Водитель From ВЫПОЛНЯЕМЫЕ

SELECT count(*)[Count_of_notations] From ВЫПОЛНЯЕМЫЕ

SELECT TOP(3) Номер_выполняемой_грузоперевозки,Оплата From ВЫПОЛНЯЕМЫЕ
Where Оплата>5000 AND Оплата<12000;

SELECT distinct Фамилия_водителя From ВОДИТЕЛИ
Where Стаж_водителя>4 AND Стаж_водителя<11;

SELECT  Фамилия_водителя From ВОДИТЕЛИ
Where Стаж_водителя>4 AND Стаж_водителя<11 Order by Стаж_водителя desc;