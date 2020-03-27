use Services;
go
exec sp_configure 'clr_enabled', 1;
go
reconfigure;
go
create assembly GetCostByService from 'D:\Учёба\3 курс, 6 семестр\БД\laba3\laba3\bin\Debug\laba3.dll';
drop assembly GetCostByService;

go
create procedure GetCostByService (@start DateTime, @end DateTime)
as external name GetCostByService.StoredProcedures.GetCostByService
go
drop procedure GetCostByService;

go
declare @num int
exec @num = GetCostByService '2017-01-01', '2020-01-01'
print @num

go
create assembly MoneyType from 'D:\Учёба\3 курс, 6 семестр\БД\laba3\laba3\laba3_1\bin\Debug\laba3_1.dll';
drop assembly MoneyType;

go
create type MoneyType external NAME MoneyType.MoneyType;
drop type MoneyType;

declare @s dbo.MoneyType;
set @s = '99,9';
print @s.ToString();
