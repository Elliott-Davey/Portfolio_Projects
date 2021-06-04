--Make queries on the following topics from IBM Data Analyst Certiciation...
--From WEEK 1: Select Statements, Count-Distinct-Limit functions, Insert-Update-Delete functions
--From WEEK 2: SQL Statements types, Create Table Statement, Alter-Drop-Truncate tables
--From WEEK 3: Like and wildcards, sorting, grouping, Having, Aggregate functions, Sub-Queries & Nested Selects, JOINS
--From WEEK 4: Accessing Databases in Python
--From WEEK 5: Getting table and column details - LOADING DATA, SQL chicago crime data assignment
--From WEEK 6: VIEWS, STORED PROCEDURES, INNER JOINS, OUTER JOINS


--LOOKING AT THE DATASETS
SELECT *
FROM [Covid Data Portfolio Project]..Covid_Deaths

SELECT *
FROM [Covid Data Portfolio Project]..Covid_Vaccinations



--LIST OF COUNTRIES
SELECT DISTINCT(location) AS COUNTRY_LIST
FROM [Covid Data Portfolio Project]..Covid_Deaths
ORDER BY COUNTRY_LIST



--NUMBER OF COUNTRIES
SELECT COUNT(DISTINCT(location)) AS NUMBER_OF_COUNTRIES
FROM [Covid Data Portfolio Project]..Covid_Deaths



--LOOKING AT ALL COUNTRIES BEGINNING WITH 'A'
SELECT continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null AND location like 'A%'
ORDER BY location, date

SELECT continent, location, date, total_vaccinations, new_vaccinations
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null AND location like 'A%'
ORDER BY location, date



--TOTAL CASES/DEATHS/VACCINATIONS BY CONTINENT
SELECT continent, SUM(new_cases) as TOTAL_CASES
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TOTAL_CASES DESC

SELECT continent, SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TOTAL_DEATHS DESC

SELECT continent, SUM(CAST(new_vaccinations AS INT)) AS TOTAL_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY continent
ORDER BY TOTAL_VACCINATIONS DESC



--TOTAL CASES/DEATHS VACCINATIONS BY COUNTRY
SELECT location, SUM(new_cases) AS TOTAL_CASES
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY location
ORDER BY TOTAL_CASES DESC

SELECT location, SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY location
ORDER BY TOTAL_DEATHS DESC

SELECT location, SUM(CAST(new_vaccinations AS INT)) AS TOTAL_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY location
ORDER BY TOTAL_VACCINATIONS DESC




--FINDING COUNTRY WITH THE HIGHEST VACCINATIONS IN A SINGLE DAY USING SUBQUERY
SELECT continent, location, date, new_vaccinations
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE new_vaccinations = (SELECT MAX(CAST(new_vaccinations AS INT)) FROM [Covid Data Portfolio Project]..Covid_Vaccinations WHERE continent is not null)
GROUP BY continent, location, date, new_vaccinations

SELECT continent, location, MAX(CAST(new_vaccinations AS INT)) AS RECORD_DAILY_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY continent, location
ORDER BY RECORD_DAILY_VACCINATIONS DESC



--FINDING INFECTION RATES BY COUNTRY AND CONTINENT
SELECT continent, location, date, total_cases , population, (total_cases/population)*100 AS INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
ORDER BY location, date

SELECT location, date, total_cases, population, (total_cases/population)*100 AS INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null
ORDER BY location, date



--FINDING DEATH RATES BY COUNTRY AND CONTINENT
SELECT continent, location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DEATH_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
ORDER BY location, date

SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DEATH_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null
ORDER BY location, date



--FINDING VACCINATION PERCENTAGE OF TOTAL POPULATION USING JOINS FOR COUNTRIES AND CONTINENTS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, (CAST(vac.total_vaccinations as int)/dea.population)*100 AS VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date

SELECT dea.location, dea.date, dea.population, vac.total_vaccinations, (CAST(vac.total_vaccinations as int)/dea.population)*100 AS VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null
ORDER BY dea.location, dea.date



--FINDING DAILY VACCINATION PERCENTAGE BASED ON POPULATION USING JOINS FOR COUNTRIES AND CONTINENTS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, (CAST(vac.new_vaccinations AS INT)/dea.population)*100 AS DAILY_VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date

SELECT dea.location, dea.date, dea.population, vac.new_vaccinations, (CAST(vac.new_vaccinations AS INT)/dea.population)*100 AS DAILY_VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null
ORDER BY dea.location, dea.date



--FINDING HIGHEST INFECTION RATES FOR EACH COUNTRY AND CONTINENT
SELECT continent, location, MAX(total_cases) AS HIGHEST_INFECTION_COUNT, MAX((total_cases/population)*100) AS HIGHEST_INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent, location
ORDER BY HIGHEST_INFECTION_RATE DESC

SELECT location, MAX(total_cases) AS HIGHEST_INFECTION_COUNT, MAX((total_cases/population)*100) AS HIGHEST_INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null
GROUP BY location
ORDER BY HIGHEST_INFECTION_RATE DESC



--FINDING HIGHEST DEATH RATES FOR EACH COUNTRY AND CONTINENT
SELECT continent, location, MAX(CAST(total_deaths as int)) AS HIGHEST_DEATH_COUNT, MAX((CAST(total_deaths as int)/total_cases)*100) AS HIGHEST_DEATH_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent, location
ORDER BY HIGHEST_DEATH_PERCENTAGE DESC

SELECT location, MAX(CAST(total_deaths as int)) AS HIGHEST_DEATH_COUNT, MAX((CAST(total_deaths as int)/total_cases)*100) AS HIGHEST_DEATH_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null
GROUP BY location
ORDER BY HIGHEST_DEATH_PERCENTAGE DESC



--FINDING HIGHEST VACCINATION PERCENTAGE FOR EACH COUNTRY AND CONTINENT
SELECT dea.continent, dea.location, MAX(CAST(vac.total_vaccinations as int)) AS TOTAL_VACCINATIONS, MAX((CAST(vac.total_vaccinations as int)/dea.population)*100) AS HIGHEST_VACCINATION_PERCENTAGE, dea.population
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
GROUP BY dea.continent, dea.location, dea.population
ORDER BY HIGHEST_VACCINATION_PERCENTAGE DESC

SELECT dea.location, MAX(CAST(vac.total_vaccinations as int)) AS TOTAL_VACCINATIONS, MAX((CAST(vac.total_vaccinations as int)/dea.population)*100) AS HIGHEST_VACCINATION_PERCENTAGE, dea.population
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null
GROUP BY dea.continent, dea.location, dea.population
ORDER BY HIGHEST_VACCINATION_PERCENTAGE DESC



--FINDING HIGHEST DAILY VACCINATION AS A PERCETAGE OF POPULATION BY COUNTRY AND CONTINENT
SELECT dea.continent, dea.location, MAX(CAST(vac.new_vaccinations as int)) AS HIGHEST_DAILY_VACCINATIONS, MAX((CAST(vac.new_vaccinations as int)/dea.population)*100) DAILY_VACINNATION_PERCENTAGE, dea.population
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
GROUP BY dea.continent, dea.location, dea.population
ORDER BY DAILY_VACINNATION_PERCENTAGE DESC

SELECT dea.location, MAX(CAST(vac.new_vaccinations as int)) AS HIGHEST_DAILY_VACCINATIONS, MAX((CAST(vac.new_vaccinations as int)/dea.population)*100) DAILY_VACINNATION_PERCENTAGE, dea.population
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null
GROUP BY dea.continent, dea.location, dea.population
ORDER BY DAILY_VACINNATION_PERCENTAGE DESC



--CREATING VIEWS FROM THE ABOVE QUERIES FOR VISUALISATIONS
CREATE VIEW TOTAL_CASES_CONTINENT AS
SELECT continent, SUM(new_cases) as TOTAL_CASES
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent

CREATE VIEW TOTAL_DEATHS_CONTINENT AS
SELECT continent, SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY continent

CREATE VIEW TOTAL_VACCINATIONS_CONTINENT AS
SELECT continent, SUM(CAST(new_vaccinations AS INT)) AS TOTAL_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY continent

CREATE VIEW TOTAL_CASES_COUNTRY AS
SELECT location, SUM(new_cases) AS TOTAL_CASES
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY location

CREATE VIEW TOTAL_DEATHS_COUNTRY AS
SELECT location, SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null
GROUP BY location

CREATE VIEW TOTAL_VACCINATIONS_COUNTRY AS
SELECT location, SUM(CAST(new_vaccinations AS INT)) AS TOTAL_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY location

CREATE VIEW HIGHEST_DAILY_VACCINATIONS_COUNTRY AS
SELECT continent, location, MAX(CAST(new_vaccinations AS INT)) AS RECORD_DAILY_VACCINATIONS
FROM [Covid Data Portfolio Project]..Covid_Vaccinations
WHERE continent is not null
GROUP BY continent, location

CREATE VIEW CASE_PERCENTAGE_COUNTRY AS
SELECT continent, location, date, total_cases , population, (total_cases/population)*100 AS INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null

CREATE VIEW CASE_PERCENTAGE_CONTINENT AS
SELECT location, date, total_cases, population, (total_cases/population)*100 AS INFECTION_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null

CREATE VIEW DEATH_PERCENTAGE_COUNTRY AS
SELECT continent, location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DEATH_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is not null

CREATE VIEW DEATH_PERCENTAGE_CONTINENT AS
SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS DEATH_RATE
FROM [Covid Data Portfolio Project]..Covid_Deaths
WHERE continent is null

CREATE VIEW VACCINATION_PERCENTAGE_COUNTRY AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, (CAST(vac.total_vaccinations as int)/dea.population)*100 AS VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null

CREATE VIEW VACCINATION_PERCENTAGE_CONTINENT AS
SELECT dea.location, dea.date, dea.population, vac.total_vaccinations, (CAST(vac.total_vaccinations as int)/dea.population)*100 AS VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null

CREATE VIEW DAILY_VACCINATION_PERCENTAGE_COUNTRY AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, (CAST(vac.new_vaccinations AS INT)/dea.population)*100 AS DAILY_VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null

CREATE VIEW DAILY_VACCINATION_PERCENTAGE_CONTINENT AS
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations, (CAST(vac.new_vaccinations AS INT)/dea.population)*100 AS DAILY_VACCINATION_PERCENTAGE
FROM [Covid Data Portfolio Project]..Covid_Deaths dea
JOIN [Covid Data Portfolio Project]..Covid_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is null