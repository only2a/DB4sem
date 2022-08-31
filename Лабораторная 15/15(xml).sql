--1. ����.XML � ������ PATH �� TEACHER ��� �������� ����
--������ ������� ��������������� ���������� � ��� ����� ���������� ����� �������
go
SELECT * from TEACHER where PULPIT = '����' for xml PATH('TEACHER'), root('�������������_�������_����'),elements;




--2. ����� AUTO: ����.���, ���, ����� + ������ ���������� ���.
--����������� ��������� ���������.
go
select	   AUDITORIUM.AUDITORIUM			[���������],
           AUDITORIUM.AUDITORIUM_TYPE		[�������������_����],
		   AUDITORIUM.AUDITORIUM_CAPACITY	[�����������] 
		   from AUDITORIUM join AUDITORIUM_TYPE
		     on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = '��' for xml AUTO, root('������_���������'), elements;



--3. �-� � ���� ����� �����������
--����.�-� OPENXML, ������. INSERT... SELECT
--����� ��� ��������� ��������� � ������� �������� ��������������� ������

go				
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <����������>
					     <���������� ���="����" ��������="������������ ��������� � �������" �������="����" />
						 <���������� ���="���" ��������="������ ������ ����������" �������="����" />
						 <���������� ���="��" ��������="WEB-������" �������="����" />
					  </����������>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[���], [��������], [�������] from openxml(@h, '/����������/����������',0)
    with([���] char(10), [��������] varchar(100), [�������] char(20));

delete from SUBJECT where SUBJECT.SUBJECT='����' or SUBJECT.SUBJECT='���' or SUBJECT.SUBJECT='��'
select * from SUBJECT



--4
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
	values(22, '��������� �.�.', '15.12.2002',
	'<�������>
	   <������� �����="AB" �����="723123" ����="11.11.2021" />
	   <�������>0</�������>
	   <�����>
		  <������>��������</������>
		  <�����>�����</�����>
		  <�����>���������</�����>
	       	  <���>41</���>
		  <��������>60</��������>
		</�����>
	</�������>');
select * from STUDENT where NAME = '��������� �.�.';
delete STUDENT where NAME = '��������� �.�.';
update STUDENT set INFO = '<�������>
					           <������� �����="AB" �����="723123" ����="12.11.2022" />
							   <�������>123456789101112</�������>
							   <�����>
								  <������>��������</������>
								  <�����>�����</�����>
								  <�����>���������</�����>
	         					  <���>41</���>
								  <��������>60</��������>
								</�����>
							</�������>' where NAME='��������� �.�.'
select NAME[���], INFO.value('(�������/�������/@�����)[1]', 'char(2)')[����� ��������],
	INFO.value('(�������/�������/@�����)[1]', 'varchar(20)')[����� ��������],
	INFO.query('/�������/�����')[�����]
		from  STUDENT
			where NAME = '��������� �.�.';     


--5. ����� STUDENT: �������� �������.������� INFO ������� XML SCHEMACOLLECTION

go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml
--drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='��������� �.�.'


-- 7

select 
	rtrim(F.FACULTY) as "@���",
	(select COUNT(*) from PULPIT as P where P.FACULTY = F.FACULTY) as "����������_������",
	(select rtrim(p.PULPIT) as "@���",
			(
				select 
					rtrim(T.TEACHER) as "�������������/@���",
					T.TEACHER_NAME as "�������������"
				from 
					TEACHER as T where T.PULPIT = p.PULPIT
				for xml path(''),type, root('�������������')
			)
		from 
			PULPIT as p where p.FACULTY = F.FACULTY 
		for xml path('�������'), type, root('�������')
	) 
from
	FACULTY as F
for xml path('���������'), type, root('�����������')








--------------------------------------------------
go
SELECT * from �������� where ����_�������� >10 for xml PATH('��������'), root('����'),elements;




--2. ����� AUTO: ����.���, ���, ����� + ������ ���������� ���.
--����������� ��������� ���������.
go
select	   ��������.������������_��������			[���],
           ��������.���������_��������		[���������],
		   ��������.����������_����_�_����	[���������� ����] 
		   from �������� join �����������
		     on ��������.�����������������_�����_��������= �����������.�������
	where �����������.������ >4000 for xml AUTO, root('������_���������'), elements;

