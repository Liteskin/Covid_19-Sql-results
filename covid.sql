SELECT *
FROM test.covid_deaths as d
order by 3,4

-- Total Cases vs Total deaths (Death Percentage) per location

SELECT location, date, total_cases, total_deaths,
(total_deaths / total_cases) * 100 as DeathPercentage
from test.covid_deaths 
order by 1,2

-- united states Deaths vs Cases

SELECT location, date, total_cases, total_deaths,
(total_deaths / total_cases) * 100 as DeathPercentage
from test.covid_deaths as d
where location like '%states%'
order by 1,2

-- 	shows the population that got covid (Infected %)

SELECT distinct location, population,total_cases, (total_cases / population) * 100 as InfectedPercentage
from test.covid_deaths
order by 1,2


-- Countries(location) with Highest Infection Rate compared to population

SELECT location, MAX(total_cases) as HighestInfectionCount,
 Max((total_cases / population)) * 100 as PercentPopulationInfected
from test.covid_deaths as d
group by location,population
order by HighestInfectionCount desc

-- continent highest death count 

SELECT continent, MAX(total_deaths) as TotalDeathCount
from test.covid_deaths as d
group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS 


SELECT  date, Sum(new_cases) as TotalNewCases, sum(new_deaths) as TotalNewDeaths,
Sum(new_deaths)/SUM( new_cases) * 100 as DeathPercentage
from test.covid_deaths as d
group by date
order by 1,2

-- Joins 

SELECT d.continent, d.location, d.date ,d.population, v.new_vaccinations
from test.covid_deaths as d
Join test.covid_vac as v 
	on d.location = v.location
    and d.date = v.date
order by 2,3

-- looking at total population vs Vaccinations 

SELECT d.continent, d.location, d.date ,d.population, v.new_vaccinations
, Sum(v.new_vaccinations) OVER 
(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
-- Rolling Count because of the partiton by
from test.covid_deaths as d
Join test.covid_vac as v 
	on d.location = v.location
    and d.date = v.date
order by 2,3

-- Use CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT d.continent, d.location, d.date ,d.population, v.new_vaccinations
, Sum(v.new_vaccinations) OVER 
(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
-- Rolling Count because of the partiton by
from test.covid_deaths as d
Join test.covid_vac as v 
	on d.location = v.location
    and d.date = v.date
)
Select *, (RollingPeopleVaccinated/population) * 100 as TotalVac
from PopvsVac

-- Creating views for visuals later


Create Database ETL;




