use lab7 
go

--TASK1
create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);

--TASK2	
alter procedure generateXML
as
declare @x XML
set @x = (Select driver.firstName [Èìÿ_âîäèòåëÿ], 
trnumber.taransportNumber [Íîìåð_àâòîìîáèëÿ], car.typeOfService [Òèï_ïåðåâîçêè], GETDATE() [Äàòà]  
from Driver driver join Transport trnumber on driver.id = trnumber.idDriver 
join Carriage car on car.idTransport = trnumber.id
join Goods g on g.id = car.idGoods 
FOR XML AUTO);
SELECT @x
go

execute generateXML;

--TASK3
alter procedure InsertInReport
as
DECLARE  @s XML  
SET @s = (Select d.firstName [Èìÿ], t.taransportNumber [Íîìåð_àâòîìîáèëÿ], 
car.typeOfService [Òèï_ïåðåâîçêè], GETDATE() [Äàòà] 
from Driver d join Transport t on d.id = t.idDriver 
join Carriage car on car.idTransport = t.id
join Goods g on g.id = car.idGoods 
for xml raw);
--FOR XML AUTO, TYPE);
insert into Report values(@s);
go
  
  execute InsertInReport
  select * from Report;

--task4
create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path

--task5 
select * from Report

alter procedure SelectData
as
select xml_column.query('/row') as[xml_column] from Report for xml auto, type;
go

execute SelectData