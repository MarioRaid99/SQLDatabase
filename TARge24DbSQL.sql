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

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla väärtust, siis
--- see automaatselt sisestab sellele reale väärtuse 3 e nagu meil on unknown
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
-- kõik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
select * from Person where City <> 'Gotham'

-- näitab teatud vanusega olevaid inimesi
select * from Person where Age = 100 or Age = 45 or Age = 19
select * from Person where Age in (100, 45, 19)

-- näitab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 27 and 31

-- wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
select * from Person where City like '%g%'

--näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

-- n'tiab kõiki, kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

-- kõik, kellel nimes ei ole esimene täht W, A, S
select * from Person where Name Like '[^WAS]%'
select * from Person

--kõik, kes elavad Gothamis ja New Yorkis
select * from Person where City in ('Gotham','New York')

--- kõik, kes elavad välja toodud linnades ja on nooremad 
--  kui 30 a 
select * from Person where (City = 'Gotham' or City = 'New York')
and Age < 30

-- kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
-- kuvab vastupidises järjestuses
select * from Person order by Name desc

-- võtab kolm esimest rida
select top 3 * from person

-- kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

-- 3tund 12.03.2025 

--näita esimesed 50% tabelis
select top 50 percent * from Person

--järjestab vanuse järgi
--see päring ei järesta numbreid õigesti kuna Age on varchar
select * from Person order by Age desc

--castime Age int andmetüübiks ja siis järjestab õigesti
select * from Person order by CAST(Age as int)

--kõikide iskute koondvanus
select sum(cast(Age as int)) as "Total Age" from Person

--kõige noorem isik
select min(cast(Age as int)) as "Kõige noorem" from Person
--kõige vanem isik
select max(cast(Age as int)) as "Kõige vanem" from Person

--näeme konkreetsetes linnades olevate isikute koonvanust
--enne oli Age string, aga enne päringut muudame selle int-ks
select City, sum(Age) as TotalAge from Person group by City

--nüüd muudame muutuja andmetüüpi koodiga
alter table Person
alter column Name nvarchar(25)

---kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i TotalAge-ks
---järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

---näitab, et mitu rida on selles tabelis
select count(*) from Person
select * from Person

---Näitab tulemust, et mitu inimest on GenderId väärtused 2 konkreetses linnas
---veel arvutab vanuse kokku
select City, GenderId, sum(Age) as TotalAge, count(Id)as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

insert into Person values
(10, 'Black Panther', 'b@b.com', 2, 34, 'New York')

---näitab ära inimeste koondvanuse, kelle vanus on vähemalt 29 a
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

-- arvutab kõikide palgad kokku
Select sum(cast(Salary as int)) from Employees
-- kõige väiksema palgasaaja palk
Select min(cast(Salary as int)) from Employees
-- ühe kuu palgafon linnade lõikes
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.id
group by Location

alter table Employees
add City nvarchar(30)

--sooline eripära palkade osas
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
--Sama nagu eelmine, aga linnad on tähestikulises järjekorras
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
order by City

--loeb ära, mitu rida andmeid on tabelis,
-- * aseme võin panna ka muid veergude nimetusi
select count(DepartmentID) from Employees

--mitu töötajat on soo ja linna kaupa selles tabelis
select Gender, City
count (Id) as [Total employee(s)]
from Employees
group by Gender, City

--näitab kõik mehed linnade kaupa
select Gender, City,
count (Id) as [Total employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--näitab kõk naised linnade kaupa
select Gender, City,
count (Id) as [Total employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--kelle palk on vähemalt üle 4000 ja toob välja ainult nime, linna ja palga
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

--kustutage ära City veerg Employees tabelist
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.id

--left join
--kuidas saada kõik andmed Employees tabelist kätte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.id

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.id

-- full outer join, kuidas saada kõikide tabelite väärtused ühte päringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.id

--cross join, võtab kaks allpool olevat tabelit kokku ja korrutab need omavahel läbi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--päringu sisu
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
--Mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.id is null

--Saame muuta tabeli nimetust, alguses vana tabeli nimi ja siis uus soovitud
sp_rename 'Department123' , 'Department'

--Teeme left join-i, aga Employees tabeli nimetus on lühendina E
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

alter table Employees
add ManagerId int

--Inner join
--kuvab inult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join
--kõik saavad kõikide ülemused olla
select E.name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select isnull('Asd', 'No Manager') as Manager

--NULL asemel kuab No Manager
select  coalesce(NULL, 'No Manager') as Manager

--neil kellel e ole ülemust, siis paneb neile No Manager
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teeme päringu, kus kasutame case-i
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

---igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
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

-- kasutame union all, näitab kõiki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

-- korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--- kasuta union all ja sorteeri nime järgi
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

--niimoodi saab sp tahetud järjekord mööda minna, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta s-d ja võti peale panna, et keegi teine peale teie ei saaks muuta.
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --paneb võtme peale
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

--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib tulemuse konsooli
declare @TotalCount int
execute spGetEmployeeCountByGender 'Female', @TotalCount out
if(@TotalCount = 0)
	print 'TotalCount is null'
else
	print '@Total is not null'
print @TotalCount

-- näitab ära, et mitu rid vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

-- sp sisu vaatamine
sp_help spGetEmployeeCountByGender
-- tabeli info
sp_help Employees
-- kui soovid sp tektsi näha
sp_helptext spGetEmployeeCountByGender

-- vaatame , millest see sp sõltub
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

--veateadet ei näita, aga tulemust ka ei ole
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

---