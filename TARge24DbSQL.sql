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