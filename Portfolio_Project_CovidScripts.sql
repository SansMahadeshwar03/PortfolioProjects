SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
order by 3,4

--SELECT * 
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
order by 1,2

--Total cases vs Total deaths
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS Death_percentage  
From PortfolioProject..CovidDeaths
WHERE location LIKE 'India'
order by 1,2

--Total cases vs Population
--Percentage of population that got Covid
Select location, date, total_cases, population,(total_cases/population)*100 AS InfectionPercentage  
From PortfolioProject..CovidDeaths
WHERE location LIKE 'India'
and continent is NOT NULL
order by 1,2

--Countries with Highest Infection rates compared to population
Select location, MAX(total_cases) AS HighInfCount, population,
MAX((total_cases/population))*100 AS InfectionPercentage  
From PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
--WHERE location LIKE 'India'
GROUP BY location, population
order by InfectionPercentage desc

--Countries with highest Death count
Select location, MAX(cast(total_deaths AS int)) AS HighDeathCount 
From PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
--WHERE location LIKE 'India'
GROUP BY location
order by HighDeathCount desc


--Grouping by Continent
--Continents with Highest Death Count per population

Select continent, MAX(cast(total_deaths AS int)) AS HighDeathCount 
From PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
--WHERE location LIKE 'India'
GROUP BY continent
order by HighDeathCount desc


--Global numbers

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as INT)) as total_deaths,
(SUM(cast(new_deaths as INT))/SUM(new_cases))*100 AS Death_percentage  
From PortfolioProject..CovidDeaths
--WHERE location LIKE 'India'
WHERE continent is NOT NULL
--Group by date
order by 1,2


--JOINS, Over clause, storing in temporary table

With temp_table (Continent,Location, Date, Population, New_vaccinations, Fibonacci_vaccines)
as(
Select a.continent, a.location, a.date, a.population, b.new_vaccinations,
SUM(cast(b.new_vaccinations as int)) OVER (Partition by a.location ORDER BY a.location, a.date) AS Fibonacci_vaccines
FROM PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
on a.location = b.location
and a.date = b.date
Where a.continent is NOT NULL
--order by 2,3
 )
 Select *,(Fibonacci_vaccines/population)*100
 FROM temp_table



 --Temporary table
 
 Drop Table IF Exists #PopulationVaccinatedPercentage
 Create Table #PopulationVaccinatedPercentage(
 Continent nvarchar(255),
 Location NVARCHAR(255),
 Date datetime,
 Population INT,
 New_vaccinations int,
 Fibonacci_vaccines Int
 )
 Insert INTO #PopulationVaccinatedPercentage
 Select a.continent, a.location, a.date, a.population, b.new_vaccinations,
SUM(cast(b.new_vaccinations as int)) OVER (Partition by a.location ORDER BY a.location, a.date) AS Fibonacci_vaccines
FROM PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
on a.location = b.location
and a.date = b.date
Where a.continent is NOT NULL
--order by 2,3

 Select *,(Fibonacci_vaccines/population)*100
 FROM #PopulationVaccinatedPercentage


 --Create View for Visualizations

Create View PopulationVaccinatedPercentage as
Select a.continent, a.location, a.date, a.population, b.new_vaccinations,
SUM(cast(b.new_vaccinations as int)) OVER (Partition by a.location ORDER BY a.location, a.date) AS Fibonacci_vaccines
FROM PortfolioProject..CovidDeaths a
JOIN PortfolioProject..CovidVaccinations b
on a.location = b.location
and a.date = b.date
Where a.continent is NOT NULL
--order by 2,3 

Select * from PopulationVaccinatedPercentage
