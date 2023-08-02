use protfolio_project



select * from ['covid-death$']
where continent is not null
order by 3,4 

--select location,date,total_cases,total_deaths,((cast(total_cases as float)/(cast(total_deaths as float))*100)
--from ['covid-death$']
--group by location,date,total_cases,total_deaths
--order by 1,2





select location,population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100 as percentpopulationinfected
from ['covid-death$']
group by location,population
order by percentpopulationinfected desc 

--showing country with the highest death count per popluation 
select location, max(cast(total_deaths as int)) as totaldeathcount
from ['covid-death$']
where continent is not null
group by location,continent
order by totaldeathcount desc


select continent, max(cast(total_deaths as int)) as totaldeathcount
from ['covid-death$']
where continent is not null
group by continent
order by totaldeathcount desc

-- global numbers 
use protfolio_project

select date,total_cases,total_deaths,((cast(total_cases as float))/(cast(total_deaths as float)))*100 as Deathpercentage
from ['covid-death$']
where continent is not null
order by 2,3


-- looking at the total popluation vs vaccination 

select D.continent,D.location,D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as bigint)) over (partition by D.Location order by D.location,D.date) Rollingcount
-- (Rollingcount/popluation)*100
from ['covid-death$'] D
join ['covid-vaccination$'] V
  on D.location = V.location
  and D.date = V.date
where D.continent is not null
order by 2,3;


-- CTE

with percentagerollcount (continent,location,date,population,new_vaccinations,Rollingcount)
as
(
select D.continent,D.location,D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as bigint)) over (partition by D.Location order by D.location,D.date) Rollingcount
-- (Rollingcount/popluation)*100
from ['covid-death$'] D
join ['covid-vaccination$'] V
  on D.location = V.location
  and D.date = V.date
where D.continent is not null
)
select *,(Rollingcount/population)*100
from percentagerollcount;




--Temp

Drop table if exists Rollingpercentagecount
create table Rollingpercentagecount
(
continent nvarchar(225),
location nvarchar(225),
Date datetime,
population numeric,
new_vaccination numeric,
rollingcount numeric
)

insert into Rollingpercentagecount
select D.continent,D.location,D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as bigint)) over (partition by D.Location order by D.location,D.date) Rollingcount
-- (Rollingcount/popluation)*100
from ['covid-death$'] D
join ['covid-vaccination$'] V
  on D.location = V.location
  and D.date = V.date
where D.continent is not null
order by 2,3;

select *,(Rollingcount/population)*100
from Rollingpercentagecount;

-- creating view for visuallization
create view Rollingpercentagecount_01 as
select D.continent,D.location,D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as bigint)) over (partition by D.Location order by D.location,D.date) Rollingcount
from ['covid-death$'] D
join ['covid-vaccination$'] V
  on D.location = V.location
  and D.date = V.date
where D.continent is not null;