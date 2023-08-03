select location,date,total_cases,total_deaths,population
from protfolio_project..['covid-death$']


--looking at the total case vs total death
select location, date, total_cases, total_deaths, (((cast(total_cases as int))/(convert(int,total_deaths))))*100
as deathprecentage
from protfolio_project..['covid-death$']

--select sum(new_cases) total_cases, sum(convert(int,new_deaths)) total_deaths,
--case 
--	when sum((convert(int,new_deaths))/(convert(int,new_cases))) =0 then null
--else (sum(new_deaths))/(convert(int,new_cases))))*100 end as Deathpercentage
--from protfolio_project..['covid-death$']
----where continent is not null
--order by 1,2

-- --visuallization 

--1
SELECT 
    SUM(new_cases) as total_cases, 
    SUM(convert(int,new_deaths)) as total_deaths, 
    (SUM(new_deaths)/SUM(new_cases))*100 as Deathpercentage 
FROM 
    protfolio_project..['covid-death$'] 
WHERE 
    continent IS NOT NULL
ORDER BY 
    total_cases, total_deaths
	

--2 
SELECT 
	location,
    SUM(convert(int,new_deaths)) as total_deathscount
FROM 
    protfolio_project..['covid-death$'] 
WHERE 
    continent IS NULL
	AND 
	location not in ('World','European Union','International')
GROUP BY location
ORDER by 2

--3 
SELECT 
	location,population,
    Max(total_cases) as Highestinfectioncount,
	Max((total_cases/population))*100 as percentpopluationinfected
FROM 
    protfolio_project..['covid-death$'] 
GROUP BY location,population
ORDER by 4 desc

--4
SELECT 
	location,population,date,
    Max(total_cases) as Highestinfectioncount,
	Max((total_cases/population))*100 as percentpopluationinfected
FROM 
    protfolio_project..['covid-death$'] 
GROUP BY location,population,date
order by 5 desc