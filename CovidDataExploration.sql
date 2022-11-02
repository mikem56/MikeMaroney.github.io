

SELECT * FROM
CovidDeaths
ORDER BY 1,2

--SELECT * FROM
--CovidDeaths
--ORDER BY 1,2

--SELECT * FROM CovidVaccinations
--ORDER BY 1,2

-- Selecting that I am gong to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths cd
ORDER BY 1,2

--Looking at Total Cases vs. Total Deaths
-- Shows likelihood of dying if you contract covid in the United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) *100  DeathPercentage
FROM CovidDeaths cd
WHERE location like '%states%'
ORDER BY 1,2


-- Looking at Total Cases vs. Population
SELECT location, date, total_cases, population, (total_cases/population) *100 PercentPopulationInfected
FROM CovidDeaths cd
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at countries with the highest infection rate compared to population
SELECT location ,MAX(total_cases) as HighestInfectionCount, population, MAX(CAST(total_cases as REAL)/CAST(population as REAL))*100 as PercentPopulationInfected
FROM CovidDeaths cd
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths as integer)) AS TotalDeathCount
FROM CovidDeaths cd 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as integer)) AS TotalDeathCount
FROM CovidDeaths cd 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date, SUM(CAST(new_cases as real)) as TotalCases, SUM(CAST(new_deaths as real)) as TotalDeaths, (SUM(CAST(new_deaths as real)) / SUM(CAST(new_cases as real)) *100) DeathPercentage
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


-- LOOKING AT VACCINATION DATA 

-- Looking at Total Population vs Vaccinations

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as REAL)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) RollingPeopleVaccinated,
--(RollingPeopleVaccinated / population)*100
FROM CovidDeaths cd 
JOIN CovidVaccinations cv 
	ON cd.location = cv.location
	AND cd.date = cv.date 
WHERE cd.continent IS NOT NULL
ORDER BY 2,3


-- USING CTEs

WITH PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated)
AS
(
 
)

SELECT *, (RollingPeopleVaccinated / population) *100
FROM PopvsVac pv


-- TEMP TABLES
DROP TABLE IF EXISTS PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated 
(
Continent TEXT,
Location TEXT,
Date DATETIME,
Population REAL,
NewVaccinations REAL
RollingPeopleVaccinated REAL 
)

INSERT INTO PercentPopulationVaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as REAL)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date)
--(RollingPeopleVaccinated / population)*100
FROM CovidDeaths cd 
JOIN CovidVaccinations cv 
	ON cd.location = cv.location
	AND cd.date = cv.date 
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated / population) *100
FROM PercentPopulationVaccinated


-- Creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as REAL)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date)
--(RollingPeopleVaccinated / population)*100
FROM CovidDeaths cd 
JOIN CovidVaccinations cv 
	ON cd.location = cv.location
	AND cd.date = cv.date 
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3

SELECT * FROM PercentPopulationVaccinated ppv 



-