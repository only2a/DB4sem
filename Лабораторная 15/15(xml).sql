--1. созд.XML в режиме PATH из TEACHER для преподов ИСиТ
--каждый столбец конфигурируется независимо с пом имени псевдонима этого столбца
go
SELECT * from TEACHER where PULPIT = 'ИСиТ' for xml PATH('TEACHER'), root('Преподаватели_кафедры_ИСиТ'),elements;




--2. режим AUTO: назв.ауд, тип, вмест + только лекционные ауд.
--применением вложенных элементов.
go
select	   AUDITORIUM.AUDITORIUM			[Аудитория],
           AUDITORIUM.AUDITORIUM_TYPE		[Наимменование_типа],
		   AUDITORIUM.AUDITORIUM_CAPACITY	[Вместимость] 
		   from AUDITORIUM join AUDITORIUM_TYPE
		     on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список_аудиторий'), elements;



--3. д-е о трех новых дисциплинах
--сист.ф-я OPENXML, констр. INSERT... SELECT
--имена его атрибутов совпадают с именами столбцов результирующего набора

go				
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="ВД" название="WEB-дизайн" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));

delete from SUBJECT where SUBJECT.SUBJECT='КГиГ' or SUBJECT.SUBJECT='ОЗИ' or SUBJECT.SUBJECT='ВД'
select * from SUBJECT



--4
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
	values(22, 'Пилипович Д.С.', '15.12.2002',
	'<студент>
	   <паспорт серия="AB" номер="723123" дата="11.11.2021" />
	   <телефон>0</телефон>
	   <адрес>
		  <страна>Беларусь</страна>
		  <город>Пинск</город>
		  <улица>Солнечная</улица>
	       	  <дом>41</дом>
		  <квартира>60</квартира>
		</адрес>
	</студент>');
select * from STUDENT where NAME = 'Пилипович Д.С.';
delete STUDENT where NAME = 'Пилипович Д.С.';
update STUDENT set INFO = '<студент>
					           <паспорт серия="AB" номер="723123" дата="12.11.2022" />
							   <телефон>123456789101112</телефон>
							   <адрес>
								  <страна>Беларусь</страна>
								  <город>Пинск</город>
								  <улица>Шапошника</улица>
	         					  <дом>41</дом>
								  <квартира>60</квартира>
								</адрес>
							</студент>' where NAME='Пилипович Д.С.'
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Пилипович Д.С.';     


--5. измен STUDENT: значения типизир.столбца INFO контрол XML SCHEMACOLLECTION

go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml
--drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='Пилипович Д.С.'


-- 7

select 
	rtrim(F.FACULTY) as "@код",
	(select COUNT(*) from PULPIT as P where P.FACULTY = F.FACULTY) as "количество_кафедр",
	(select rtrim(p.PULPIT) as "@код",
			(
				select 
					rtrim(T.TEACHER) as "преподаватель/@код",
					T.TEACHER_NAME as "преподаватель"
				from 
					TEACHER as T where T.PULPIT = p.PULPIT
				for xml path(''),type, root('преподаватели')
			)
		from 
			PULPIT as p where p.FACULTY = F.FACULTY 
		for xml path('кафедра'), type, root('кафедры')
	) 
from
	FACULTY as F
for xml path('факультет'), type, root('университет')








--------------------------------------------------
go
SELECT * from ВОДИТЕЛИ where Стаж_водителя >10 for xml PATH('ВОДИТЕЛИ'), root('СТАЖ'),elements;




--2. режим AUTO: назв.ауд, тип, вмест + только лекционные ауд.
--применением вложенных элементов.
go
select	   МАРШРУТЫ.Наименование_маршрута			[Имя],
           МАРШРУТЫ.Дальность_маршрута		[Дальность],
		   МАРШРУТЫ.Количество_дней_в_пути	[Количество дней] 
		   from МАРШРУТЫ join ВЫПОЛНЯЕМЫЕ
		     on МАРШРУТЫ.Идентификациооный_номер_маршрута= ВЫПОЛНЯЕМЫЕ.Маршрут
	where ВЫПОЛНЯЕМЫЕ.Оплата >4000 for xml AUTO, root('Список_маршрутов'), elements;

