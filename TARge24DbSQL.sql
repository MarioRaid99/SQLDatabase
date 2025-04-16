-- 1tund 26.02.25
--loome db
crEaTE database TARge24

--db valimine
use TARge24

-- db kustutamine
drop database TARge24

-- 2tund 05.03.2025

--tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female'),
(3, 'Unknown')

--vaatame tabeli andmeid
select * from Gender

create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

select * from Person

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla v��rtust, siis
--- see automaatselt sisestab sellele reale v��rtuse 3 e nagu meil on unknown
alter table Person
add constraint DF_Person_GenderId
default 3 for GenderId

select * from Person

insert into Person (Id, Name, Email)
values (7, 'Spiderman', 'spider@s.com')

--piirangu kustutamine
alter table Person
drop constraint DF_Person_GenderId

--lisame veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

-- rea kustutamine
delete from Person where Id = 8

select * from Person

--kuidas uuendada andmeid
update Person
set Age = 19
where Id = 7

select * from Person

--lisame veeru juurde
alter table Person
add City nvarchar(50)

-- k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k�ik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
select * from Person where City <> 'Gotham'

-- n�itab teatud vanusega olevaid inimesi
select * from Person where Age = 100 or Age = 45 or Age = 19
select * from Person where Age in (100, 45, 19)

-- n�itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 27 and 31

-- wildcard e n�itab k�ik g-t�hega linnad
select * from Person where City like 'g%'
select * from Person where City like '%g%'

--n�itab k�iki, kellel ei ole @-m�rki emailis
select * from Person where Email not like '%@%'

-- n'tiab k�iki, kellel on emailis ees ja peale @-m�rki ainult �ks t�ht
select * from Person where Email like '_@_.com'

-- k�ik, kellel nimes ei ole esimene t�ht W, A, S
select * from Person where Name Like '[^WAS]%'
select * from Person

--k�ik, kes elavad Gothamis ja New Yorkis
select * from Person where City in ('Gotham','New York')

--- k�ik, kes elavad v�lja toodud linnades ja on nooremad 
--  kui 30 a 
select * from Person where (City = 'Gotham' or City = 'New York')
and Age < 30

-- kuvab t�hestikulises j�rjekorras inimesi ja v�tab aluseks nime
select * from Person order by Name
-- kuvab vastupidises j�rjestuses
select * from Person order by Name desc

-- v�tab kolm esimest rida
select top 3 * from person

-- kolm esimest, aga tabeli j�rjestus on Age ja siis Name
select top 3 Age, Name from Person

-- 3tund 12.03.2025 

--n�ita esimesed 50% tabelis
select top 50 percent * from Person

--j�rjestab vanuse j�rgi
--see p�ring ei j�resta numbreid �igesti kuna Age on varchar
select * from Person order by Age desc

--castime Age int andmet��biks ja siis j�rjestab �igesti
select * from Person order by CAST(Age as int)

--k�ikide iskute koondvanus
select sum(cast(Age as int)) as "Total Age" from Person

--k�ige noorem isik
select min(cast(Age as int)) as "K�ige noorem" from Person
--k�ige vanem isik
select max(cast(Age as int)) as "K�ige vanem" from Person

--n�eme konkreetsetes linnades olevate isikute koonvanust
--enne oli Age string, aga enne p�ringut muudame selle int-ks
select City, sum(Age) as TotalAge from Person group by City

--n��d muudame muutuja andmet��pi koodiga
alter table Person
alter column Name nvarchar(25)

---kuvab esimeses reas v�lja toodud j�rjestuses ja kuvab Age-i TotalAge-ks
---j�rjestab City-s olevate nimede j�rgi ja siis GenderId j�rgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

---n�itab, et mitu rida on selles tabelis
select count(*) from Person
select * from Person

---N�itab tulemust, et mitu inimest on GenderId v��rtused 2 konkreetses linnas
---veel arvutab vanuse kokku
select City, GenderId, sum(Age) as TotalAge, count(Id)as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

insert into Person values
(10, 'Black Panther', 'b@b.com', 2, 34, 'New York')

---n�itab �ra inimeste koondvanuse, kelle vanus on v�hemalt 29 a
--kui palju neid igas linnas elab
select GenderId, City, sum(Age) as TotalAge, count(Id)
as [Total Person(s)]
from Person
group by GenderId, City having sum(Age) > 29


--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 4500, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James','Male', 6500, NULL),
(10, 'Russel', 'Male', 8800, NULL)

insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christle'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Employees
select * from Department


--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

-- arvutab k�ikide palgad kokku
Select sum(cast(Salary as int)) from Employees
-- k�ige v�iksema palgasaaja palk
Select min(cast(Salary as int)) from Employees
-- �he kuu palgafon linnade l�ikes
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.id
group by Location

alter table Employees
add City nvarchar(30)

--sooline erip�ra palkade osas
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
--Sama nagu eelmine, aga linnad on t�hestikulises j�rjekorras
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
order by City

--loeb �ra, mitu rida andmeid on tabelis,
-- * aseme v�in panna ka muid veergude nimetusi
select count(DepartmentID) from Employees

--mitu t��tajat on soo ja linna kaupa selles tabelis
select Gender, City
count (Id) as [Total employee(s)]
from Employees
group by Gender, City

--n�itab k�ik mehed linnade kaupa
select Gender, City,
count (Id) as [Total employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--n�itab k�k naised linnade kaupa
select Gender, City,
count (Id) as [Total employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--kelle palk on v�hemalt �le 4000 ja toob v�lja ainult nime, linna ja palga
select Name, City, sum(cast(Salary as int))
as [Salary]
from Employees
group by Name, City having sum(cast(Salary as int)) > 4000

--sama tulemus, aga kergemalt
select * from Employees where Salary > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama id-d
create table Test1
(
id int identity(1,1),
Value nvarchar(20)
)
insert into Test1 values('X')
select * from Test1

--kustutage �ra City veerg Employees tabelist
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas v��rtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.id

--left join
--kuidas saada k�ik andmed Employees tabelist k�tte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.id

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.id

-- full outer join, kuidas saada k�ikide tabelite v��rtused �hte p�ringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.id

--cross join, v�tab kaks allpool olevat tabelit kokku ja korrutab need omavahel l�bi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--p�ringu sisu
select ColumnList
from leftTable
joinType RightTable
on JoinCondition

--kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.id
where employees.DepartmentId is null

-- Teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.id
where Department.Id is null

--Kuidas saame Department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--Full join
--M�lema tabeli mitte-kattuvate v��rtustega read kuvab v�lja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.id is null

--Saame muuta tabeli nimetust, alguses vana tabeli nimi ja siis uus soovitud
sp_rename 'Department123' , 'Department'

--Teeme left join-i, aga Employees tabeli nimetus on l�hendina E
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

alter table Employees
add ManagerId int

--Inner join
--kuvab inult ManagerId all olevate isikute v��rtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join
--k�ik saavad k�ikide �lemused olla
select E.name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select isnull('Asd', 'No Manager') as Manager

--NULL asemel kuab No Manager
select  coalesce(NULL, 'No Manager') as Manager

--neil kellel e ole �lemust, siis paneb neile No Manager
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teeme p�ringu, kus kasutame case-i
select E.Name as Employee, case when M.Name is null then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

--muudame veeru nime
sp_rename 'Employees.Name', 'FirstName'

--lisame andmed tabelisse
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

select * from Employees

---igast reast v�tab esimesena t�idetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

-- kasutame union all, n�itab k�iki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

-- korduvate v��rtustega read pannakse �hte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--- kasuta union all ja sorteeri nime j�rgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--- stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--Kutsuda stored procedure esile
spGetEmployees
exec spGetEmployees
execute spGetEmployees

select * from Employees

create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--kutsume selle sp esile ja selle puhul tuleb sisestada parameetrid
spGetEmployeesByGenderAndDepartment 'Male', 1

--niimoodi saab sp tahetud j�rjekord m��da minna, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta s-d ja v�ti peale panna, et keegi teine peale teie ei saaks muuta.
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb v�tme peale
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

sp_helptext spGetEmployeesByGenderAndDepartment

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab �ra n�uetele vastavad read
--prindib tulemuse konsooli
declare @TotalCount int
execute spGetEmployeeCountByGender 'Female', @TotalCount out
if(@TotalCount = 0)
	print 'TotalCount is null'
else
	print '@Total is not null'
print @TotalCount

-- n�itab �ra, et mitu rid vastab n�uetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

-- sp sisu vaatamine
sp_help spGetEmployeeCountByGender
-- tabeli info
sp_help Employees
-- kui soovid sp tektsi n�ha
sp_helptext spGetEmployeeCountByGender

-- vaatame , millest see sp s�ltub
sp_depends spGetEmployeeCountByGender
-- vaatame tabelit
sp_depends Employees

--
create proc spGetnameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--veateadet ei n�ita, aga tulemust ka ei ole
spGetnameById 1, 'Tom'

select * from Employees
declare @FirstName nvarchar(20)
execute spGetnameById 1, @FirstName output
print 'Name of the employee = ' + @FirstName

-- uus sp
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

declare @FirstName nvarchar(50)
execute spGetNameById1 1, @FirstName output
print 'Name of the employee = ' + @FirstName

--- 5 tund 26.03.2025

declare
@FirstName nvarchar(20)
execute spGetnameById1 1, @FirstName out
print 'name = ' + @Firstname

create proc spGetNameById2
@id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

--tuleb veateade kuna kutsusime v�lja int-i, aga Tom on string
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

--sisseehitatud string funktsioonid
--see konverteerib ASCII t�he v��rtuse numbriks
select ascii('a')
-- kuvab A-t�he
select char (65)

--prindime kogu t�hestiku v�lja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select char (@Start)
	set @Start = @Start + 1
end

-- eemaldame t�hjad kohad sulgudes
select ltrim('        Hello')

-- t�hikute eemaldamine veerust
select ltrim(FirstName) as FirstName, MiddleName, LastName from Employees

select * from Employees

--paremalt poolt t�hjad stringid l�ikab �ra
select rtrim('      Hello          ')

--keerab kooloni sees olevad andmed vastupidiseks
-- vastavalt upper ja lower-ga saan muuta m�rkide suurust
-- reverse funktsioon p��rab k�ik �mber
select REVERSE(UPPER(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--n�eb, mitu t�hte on s�nal ja loeb t�hikud sisse
select FirstName, len(FirstName) as [Total Characters] from Employees

--- n�eb, mitu t�hte on s�nal ja ei loe tyhikuid sisse
select FirstName, len(ltrim(FirstName)) as [Total Characters] from Employees

-- left, right ja substring
--- vasakult poolt neli esimest t�hte
select left('ABCDEF', 4)
-- paremalt poolt kolm t�hte
select right('ABCDEF', 3)

--kuvab @-t�hem�rgi asetust e mitmes on @ m�rk
select charindex('@', 'sara@aaa.com')

--- esimene nr peale komakohta n�itab, et mitmendast alustab ja siis mitu nr peale
-- seda kuvada
select SUBSTRING('pam@btbb.com', 5, 2)

--- @-m�rgist kuvab kolm t�hem�rki. Viimase numriga saab m��rata pikkust
select substring('pam@bb.com', charindex('@', 'pam@bb.com') + 1, 3)

--- peale @-m�rki reguleerin t�hem�rkide pikkuse n�itamist
select substring('pam@bb.com', charindex('@', 'pam@bb.com') + 1, 
len('pam@bb.com') - CHARINDEX('@', 'pam@bb.com'))


select * from Employees

-- vaja teha uus veerg nimega Email, nvarchar (20)
alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10


select * from Employees

--- lisame *-m�rgi alates teatud kohast
select FirstName, LastName,
	substring(Email, 1, 2) + REPLICATE('*', 5) + --peale teist t�hem�rki paneb viis t�rni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email)+1) as Email
from Employees

--- kolm korda n�itab stringis olevat v��rtust
select replicate(FirstName, 3)
from Employees

select replicate('asd', 3)

-- kuidas sisestada tyhikut kahe nime vahele
select space(5)

--Employees tabelist teed p�ringu kahe nime osas (FirstName ja LastName)
--kahe nime vahel on 25 t�hikut
select FirstName + space(25) + LastName as FullName
from Employees


-- PATINDEX
-- sama, mis charIndex, aga d�naamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0  --leian k]ik selle domeeni esindajad ja
--- alates mitmendast m�rgist algab @

-- k�ik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from Employees

--- soovin asnedada peale esimest m�rki kolm t�hte viie t�rniga
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

---ajat��bid
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--- masina kellaaja teada saamine
select GETDATE(), 'GETDATE()'

insert into DateTime
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

select * from DateTime

update DateTime set c_datetimeoffset = '2025-04-08 10:59:29.1933333 + 10:00'
where c_datetimeoffset = '2025-03-24 09:01:40.2766667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' -- aja p'ring
select SYSDATETIME()  -- veel t�psem ajap�ring
select SYSDATETIMEOFFSET() -- t�pne aeg koos ajalise nihkega UTC suhtes
select GETUTCDATE()  --UTC aeg

select isdate('asd') --tagastab 0 kuna string ei ole date e aeg
select ISDATE(getdate()) --tagastab 1 kuna on kp
select isdate('2025-03-24 09:19:01.1490061') --tagastab 0 kuna max kolm komakohta v�ib olla
select isdate('2025-03-24 09:19:01.149') ---tagastab 1
select day(getdate()) --annab t�nase p�eva nr
select day('02/28/2025') --annab stringis oleva p�eva nr
select month(getdate()) --annab t�nase kuu nr
select month('02/28/2025') --annab stringis oleva kuu nr
select year(getdate()) --annab t�nase aasta nr
select year('02/28/2025') --annab stringis oleva aasta nr

select datename(day, '2025-03-24 09:19:01.149') --annab stringis oleva p�eva nr
select Datename(WEEKDAY, '2025-03-25 09:19:01.149')  -- annab stringis oleva p�eva s�nana
select datename(MONTH, '2025-03-24 09:19:01.149') -- annab stringis oleva kuu s�nana
select datename(dayofYEAR, '2025-03-24 09:19:01.149') 

create table EmployeesWithDates
(
Id nvarchar(2),
Name nvarchar(20),
DateOfBirth datetime
)

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

--- kuidas v�tta �hest veerust andmeid ja selle abil luua uued veerud
--vaatab DoB veerust p�eva ja kuvab p�eva nimetuse s�nana
select Name, DateOfBirth, DATENAME(weekday, DateOfBirth) as [Day], 
--vaatab DoB veerust kp-d ja kuvab kuu nr
	MONTH(DateOfBirth) as MonthNumber,
-- vaatab DoB veerust kuud ja kuvab s�nana
	DateName(MONTH, DateOfBirth) as [MonthName],
-- v]tab Dob veerust aasta
	YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

select DATEPART(weekday, '2025-01-30 12:22:56.401') --kuvab 1 kuna USA n�dal algab p�hap�evaga
select DATEPART(MONTH, '2025-03-24 12:22:56.401') --kuvab kuu nr
select DATEADD(DAY, 20, '2025-03-24 12:22:56.401') --liidab stringis olevale kp 20 p�eva juurde
select DATEADD(DAY, -20, '2025-03-24 12:22:56.401') --lahutab 20 p�eva maha
select datediff(MONTH, '11/30/2024', '03/24/2025')  --kuvab kahe stringi kuudevahelist aega nr-na
select datediff(year, '11/30/2022', '03/24/2025')--n�itab aastatevahelist aega nr-na

-- funktsiooni tegemine
create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
	as begin
		declare @tempdate datetime, @years int, @months int, @days int
			select @tempdate = @DOB

			select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) > month(GETDATE())) or (MONTH(@DOB)
			= month (getdate()) and day(@DOB) > DAY(getdate())) then 1 else 0 end
			select @tempdate = dateadd(year, @years, @tempdate)

			select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate()) then 1 else 0 end
			select @tempdate = dateadd(MONTH, @months, @tempdate)

			select @days = datediff(day, @tempdate, getdate())

		declare @Age nvarchar(50)
			set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2)) + 
			' Months ' + cast(@days as nvarchar(2)) + ' Days old'
		return @Age
	end

--- saame vaadata kasutajate vanust
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) 
as Age from EmployeesWithDates

--- kui kasutame seda funktsiooni, 
--- siis saame teada t�nase p�eva vahet stringis v�lja tooduga
select dbo.fnComputeAge('11/06/2010')

-- nr peale DOB muutujat n�itab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth,
convert(nvarchar, DateOfBirth, 107) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] 
from EmployeesWithDates

select cast(getdate() as date) --t�nane kp
select convert(date, GETDATE()) -- t�nane kp

--matemaatilised funktsioonid
select abs(-101.5) --- abs on absoluutne nr ja tulemuseks saame positiivse v��rtuse
select CEILING(15.2) -- tagastab 16 ja suurendab suurema t�isarvu suunas
select CEILING(-15.2) -- tagastab -15 ja suurendab suurema positiivse t�isarvu suunas
select floor(15.2) --�mardab v�iksema arvu suunas
select floor(-15.2) --�mardab negatiivsema nr poole
select power(2,4) --hakkab korrutama 2x2x2x2 e 2 astmes 4, esimene nr on korrutatav
select SQUARE(9) --antud juhul 9 ruudus
select SQRT(81)    ---annab vastuse 9, ruutjuur

select rand()  --annab suvalise nr
select floor(rand() * 100)  --oleks t�isarvud, aga kasutad rand-i

--- iga kord n�itab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print floor(rand() * 1000)
	set @counter = @counter + 1
end

-- �mardused
select Round(850.556, 2) --�mardab kaks kohta peale komat, tulemus 850.560
select round(850.556, 2, 1) --�mardab allapoole, tulemus 850.550
select round(850.556, 1) --�mardab �lespoole ja v�tab ainult esimest nr peale koma arvesse
select round(850.556, 0) --�mardab t�isarvuni
select round(850.556, -2) --�mardab sajalise t�psusega
select round(850.556, -1) --�mardab t�isnumber allapoole

---
create function dbo.CalculateAge(@DOB date)
returns int
as begin
declare @Age int

set @Age = DATEDIFF(YEAR, @DOB, GETDATE()) -
	case
		when (MONTH(@DOB) > MONTH(getdate())) or
			 (MONTH(@DOB) > MONTH(GETDATE()) and DAY(@DOB) > day(GETDATE()))
		then 1
		else 0
		end
	return @Age
end

execute CalculateAge '10/08/2020'

select Id, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

select * from EmployeesWithDates

-- inline table valued functions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 1
update EmployeesWithDates set Gender = 'Female', DepartmentId = 2
where Id = 2
update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 3
update EmployeesWithDates set Gender = 'Female', DepartmentId = 3
where Id = 4
insert into EmployeesWithDates (Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', '1978-11-29 12:59:30.670', 1, 'Male')

select * from EmployeesWithDates

-- scalare function annab mingis vahemikus olevaid andmeid,
-- inline table values ei kasuta begin ja end funktsioone
-- scalar annab v��rtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

-- k�ik female t��tajad
select * from fn_EmployeesByGender('Female')

select * from fn_EmployeesByGender('Female')
where Name = 'Pam'  --where abil saab otsingut t�psustada

select * from Department

--kahest erinevast tabelist andmete v�tmine ja koos kuvamine
-- esimene on funktsioon ja teine tabel, 
--kasutage fn_EmployeesByGender ja tabelit Department, join p�ring
select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D
on D.Id = E.DepartmentId

-- multi-tabel statment

-- inline funktsioon
create function fn_GetEmployees()
returns table as
return (Select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()
--teha multi-state funktsioon
--peab defineerima uue tabeli veerud kooos muutujatega
--id int, Name nvarchar(50), DOB date
--funktisooni nimi on fn_MS_getEmployees()
--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, Cast(DateOfBirth as Date) from EmployeesWithDates

	return
end

select * from fn_MS_GetEmployees()
-- mis vahe on inline funktsiooni ja multi-statement vahel???
--- inline tabeli funktsioonid on paremini t��tamas kuna k�sitletakse vaatena
--- multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

--muutke andmeid, Sam muutub Sam1
update fn_GetEmployees() set Name = 'Sam1' where Id = 1 --saab muuta andmeid
update fn_MS_GetEmployees() set Name = 'Sam' where Id = 1 --ei saa muuta multistate puhul

--deterministic and non-deterministic

select count(*) from EmployeesWithDates
select square(3) --k�ik tehtem�rgid on deterministlikud funktsioonid, sinna kuuluvad veel sum, avg ja square

-- non-deterministic
select getdate()
select CURRENT_TIMESTAMP

select rand() --see funktsioon saab olla m�lemas kategoorias, k�ik oleneb sellest, 
-- kas sulgudes on 1 v�i ei ole

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

select fn_GetNameById(4)

drop table EmployeesWithDates

create table EmployeesWithDates
(
Id int primary key,
Name nvarchar(50) NULL,
DateOfBirth datetime NULL,
Gender nvarchar(10) NULL,
DepartmentId int NULL
)

select * from EmployeesWithDates

create function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

sp_helptext fn_GetEmployeeNameById

select dbo.fn_GetEmployeeNameById(3)

--kr�pteerige funktsioon fn_GetEmployeeNameById
alter function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end
--uuesti vataame sisu
sp_helptext fn_GetEmployeeNameById

--muudame �levalpool olevat funktsiooni, kindlasti tabeli ette panna dbo.Tabelinimi
alter function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

drop table dbo.EmployeesWithDates

drop function fn_GetEmployeeNameById

-- temporary tables

--- #-m�rgi ette panemisel saame aru, et tegemist on temp tabeliga
--- seda tabelit saab ainult selles p�ringus avdada
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
--kuhu tekkis #PersonDetails tabel

--saab vaadata k]iki tabeleid, mis on s�steemis olemas v�i on loodud kasutaja poolt
select Name from sysobjects
where Name like 'Gender'

--kustutame temp tabeli
drop table #PersonDetails

create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--Erinevused lokaalse ja globaalse ajutise tabeli osas:
--1. Lokaalsed ajutised tabelid on �he # m�rgiga, aga globaalsel on kaks t�kki.
--2. SQL server lisab suvalisi numbreid lokaalse ajutise tabeli nimesse, 
--aga globaalse puhul seda ei ole.
--3. Lokaalsed on n�htavad ainult selles sessioonis, mis on selle loonud, 
--aga globaalsed on n�htavad k�ikides sessioonides.
--4. Lokaalsed ajutised tabelid on automaatselt kustutatud, 
--kui selle loonud sessioon on kinni pandud, aga globaalsed 
--ajutised tabelid l�petatakse viimane viitav �hendus on kinni pandud.

--globaalse temp tabeli tegemine e paned kaks # tabeli nime ette
create table ##PersonDetails(Id int, Name nvarchar(20))

--index
create table EmployeeWithSalary (Id int primary key, Name nvarchar(25), Salary int, Gender nvarchar(10))

insert into EmployeeWithSalary values (1, 'Sam', 2500, 'Male')
insert into EmployeeWithSalary values (2, 'Pam', 6500, 'Female')
insert into EmployeeWithSalary values (3, 'John', 4500, 'Male')
insert into EmployeeWithSalary values (4, 'Sara', 5500, 'Female')
insert into EmployeeWithSalary values (5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

select * from EmployeeWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse j�rjestusse
create index IX_Employee_Salary
on EmployeeWithSalary (Salary asc)

-- saame teada, et mis on selle tabeli primaarv�ti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

select * from EmployeeWithSalary
with (index(IX_Employee_Salary))

--saame vaadata tabelit koos selle sisuga alates v�ga detailsest infost
select 
	TableName = t.name,
	IndexName = ind.name,
	IndexId = ind.index_id,
	ColumnId = ic.index_column_id,
	ColumnName = col.name,
	ind.*,
	ic.*,
	col.*
from
	sys.indexes ind
inner join
	sys.index_columns ic on ind.object_id = ic.object_id and ind.index_id = ic.index_id
inner join
	sys.columns col on ic.object_id = col.object_id and ic.column_id = col.column_id
inner join
	sys.tables t on ind.object_id = t.object_id
where
	ind.is_primary_key = 0
	and ind.is_unique = 0
	and ind.is_unique_constraint = 0
	and t.is_ms_shipped = 0
order by
	t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal;

--indeksi kustutamine
drop index EmployeeWithSalary.IX_Employee_Salary

---- indeksi t��bid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. T�istekst
--7. Ruumiline
--8. Veerus�ilitav
--9. Veergude indeksid
--10. V�lja arvatud veergudega indeksid

-- klastris olev indeks m��rab �ra tabelis oleva f��silise j�rjestuse 
-- ja selle tulemusel saab tabelis olla ainult �ks klastris olev indeks

create table EmployeeCity
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

exec sp_helpindex EmployeeCity

-- andmete �ige j�rjestuse loovad klastris olevad indeksid ja kasutab selleks Id nr-t
-- p�hjus, miks antud juhul kasutab Id-d, tuleneb primaarv�tmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

-- klastris olevad indeksid dikteerivad s�ilitatud andmete j�rjestuse tabelis 
-- ja seda saab klastrite puhul olla ainult �ks

select * from EmployeeCity

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

--- annab veateate, et tabelis saab olla ainult �ks klastris olev indeks
--- kui soovid, uut indeksit luua, siis kustuta olemasolev

--- saame luua ainult �he klastris oleva indeksi tabeli peale
--- klastris olev indeks on analoogne telefoni suunakoodile

-- loome composite indeksi
-- enne tuleb k�ik teised klastris olevad indeksid �ra kustutada
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
--index on eemaldatud ja n��d k�ivitame selle uuesti

select * from EmployeeCity

--Mitte klastris olev indeks
create nonclustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--teeme p�ringu tabelile
select * from EmployeeCity

---erinevused kahe indeksi vahel
---1. ainult �ks klastris olev indeks saab olla tabeli peale,
---mitte-klastris olevaid indekseid saab olla mitu
---2. klastris olevad indeksid on kiiremad kuna indeks peav tagasi viitama tabelile
---�juhul kui selekteeritud veerg ei ole olemas indeksis
---3. Klastris olev indeks m��ratlev �ra taveli ridade salvetusj�rjestuse
--- ja ei n�a kettal lisa ruumi. Samas mitte klastris olevad indeksid on
--- salvestatud tavelist eraldi ja n�uab lisa ruumi

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeFirstName
--- ei saa sisestada kahte samasuguse Id v��rtusega rida
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--
drop index EmployeeFirstName.PK__Employee__3214EC0758903E0C
--- kui k�ivitad �levalpool oleva koodi, siis tuleb veateade
--- et SQL server kasutab UNIQUE indeksit j�ustamaks v��rtuste unikaalsust 
--- ja primaarv�tit
--- koodiga Unikaalseid Indekseid ei saa kustutada, aga k�sitsi saab

--sisestame uuesti
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--- unikaalset indeksit kasutatakse kindlustamast v��rtuste unikaalsust (SH primaarv�ti)

create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, Lastname)


--lisame piirangu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstName_City
unique nonclustered(City)

--saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

delete EmployeeFirstName
where Id = 1

select * from EmployeeFirstName

insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'Berlin')

-- 1.Vaikimisi primaarv�ti loob unikaalse klastris oleva indeksi, samas unikaalne piirang
-- loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit v�i piirangut ei saa luua olemasolevasse tabelisse, kui tabel 
-- juba sisaldab v��rtusi v�tmeveerus
-- 3. Vaikimisi korduvaid v��rtusied ei ole veerus lubatud,
-- kui peaks olema unikaalne indeks v�i piirang. Nt, kui tahad sisestada 10 rida andmeid,
-- millest 5 sisaldavad korduviad andmeid, siis k�ik 10 l�katakse tagasi. Kui soovin ainult 5
-- rea tagasi l�kkamist ja �lej��nud 5 rea sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY

create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(3, 'John', 'Menco', 3512, 'Male', 'Madrid')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3523, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3520, 'Male', 'London1')

select * from EmployeeFirstName

---view 


---view on salvestatud SQL-i p�ring. Saab k�sitleda ka visrtuaalse tabelina.
select Name, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--loome view
create view vEmployeesByDepartment
as
select Name, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--- view p�ringu esile kutsumine
select * from vEmployeesByDepartment

-- view ei salvesta andmeid vaikimisi
-- seda tasub v�tta, kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsutamiseks,
-- mitte IT-inimesele
-- piiratud ligip��s andmetele, ei n�e k�iki veerge

-- teeme view, kus n�eb ainult IT-t��tajaid
-- view nimi on vITEmployeesInDepartment
--kasutame tabeleid Employees ja Department
create view vITEmployeesInDepartment
as
select Name, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where Department.DepartmentName = 'IT'
-- �levalpool olevat p�ringut saab liigitada reataseme turvalisuse alla
-- tahan ainult n�idata IT osakonna t��tajaid

select * from vITEmployeesInDepartment

-- veeru taseme turvalisus
-- peale selecti m��ratled veergude n�itamise �ra
create view vEmployeesInDepartmentSalaryNoShow
as
select Name, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

-- saab kasutada koondandmete esitlemist ja �ksikasjalike andmeid
-- view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

-- kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment
-- muuta saab alter k�suga
-- kustutada saab drop k�suga

--view, mida kasutame andmete uuendamiseks
create view vEmployeesDataExceptSalary
as
select Id, Name, Gender, DepartmentId
from Employees

--kasutame seda view-d, et uuendada andmeid
--muuta Id 2 all olev eesnimi Tom-ks
update vEmployeesDataExceptSalary
set Name = 'Tom' where Id = 2

--
alter view vEmployeesDataExceptSalary
as
select Id, Name, Gender, DepartmentId
from Employees

-- kustutame andmeid ja kasutame seda viewd: vEmployeesDataExceptSalary
-- Id 2 all olevad andmed
delete vEmployeesDataExceptSalary where Id = 2
--n��d lisame andmed
insert into vEmployeesDataExceptSalary (Id, Gender, DepartmentId, Name)
values(2, 'Female', 2, 'Pam')

-- indekseeritud view
-- MS SQL-s on indekseeritud view nime all ja 
-- Oracle-s materjaliseeritud view
create table product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product values (1, 'Books', 20)
insert into Product values (2, 'Pens', 14)
insert into Product values (3, 'Pencils', 11)
insert into Product values (4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

--loome view, mis annab meile veerud TotalSales ja TotalTransaction
create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = ProductSales.Id
group by Name

--- kui soovid luua indeksi view sisse, siis peab j�rgima teatud reegleid
-- 1. view tuleb luua koos schemabinding-ga
-- 2. kui lisafunktsioon select list viitab v�ljendile ja selle tulemuseks
-- v�ib olla NULL, siis asendusv��rtus peaks olema t�psustatud. 
-- Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL v��rtust
-- 3. kui GroupBy on t�psustatud, siis view select list peab
-- sisaldama COUNT_BIG(*) v�ljendit
-- 4. Baastabelis peaksid view-d olema viidatud kaheosalise nimega
-- e antud juhul dbo.Product ja dbo.ProductSales.

select * from vTotalSalesByProduct

create unique clustered index UIX_TotalSalesByProduct_Name
on vTotalSalesByProduct(Name)
