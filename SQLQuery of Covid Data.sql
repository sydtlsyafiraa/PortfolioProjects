Select *
	FROM PortfolioProject..CovidDeaths
	Where continent is not null 
	order by 3,4
	--Select *
	--FROM PortfolioProject..CovidVaccination
	--order by 3,4


	-- Select data that we are going to use
	Select Location, date, total_cases, new_cases, total_deaths, population
	FROM PortfolioProject..CovidDeaths
	Where continent is not null 
	order by 1,2

	-- Looking at the Total Cases vs. Total Deaths
	-- How many percent die from total case
	-- Shows likelihood
	Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	Where location like '%Malaysia%'
	Where continent is not null 
	order by 1,2

	-- Looking at Total Cases vs Population
	-- Percentage population got covid 

	Select Location, date, population, total_cases, (total_cases/population) *100 as PercentPopulationInfected
	FROM PortfolioProject..CovidDeaths
	Where location like '%Malaysia%'
	Where continent is not null 
	order by 1,2

	-- Looking at country with highest Infection Rate compared to Population
Select Location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as
PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
	-- Where location like '%Malaysia%'
	Where continent is not null 
	Group by Location, Population
	order by PercentPopulationInfected desc

	-- Showing country with Highest Death Count per Population
	Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
	FROM PortfolioProject..CovidDeaths
	-- Where location like '%Malaysia%'
	Where continent is not null 
	Group by Location, Population
	order by TotalDeathCount desc

	--Dividing by continents
		Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
	FROM PortfolioProject..CovidDeaths
	-- Where location like '%Malaysia%'
	Where continent is not null 
	Group by continent
	order by TotalDeathCount desc

	-- Showing continents with the highest death count per population
		Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
	FROM PortfolioProject..CovidDeaths
	-- Where location like '%Malaysia%'
	Where continent is not null 
	Group by continent
	order by TotalDeathCount desc

	-- Global numbers
	Select SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
	FROM PortfolioProject..CovidDeaths
	-- Where location like '%Malaysia%'
	Where continent is not null 
	-- Group by date
	order by 1,2

	Select *
	From PortfolioProject..CovidVaccination


	Select *
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date 

	-- Looking at Total population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/popilation)*100
From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations,RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/popilation)*100
From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric,
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/popilation)*100
From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualisation

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/popilation)*100
From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
--order by 2,3

Select*
From PercentPopulationVaccinated