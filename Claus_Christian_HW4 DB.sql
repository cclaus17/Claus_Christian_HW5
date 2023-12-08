
create database WeatherData;
go


use WeatherData;
go
--table to store information about cities
create table Cities (
    CityID int primary key,
    CityName varchar(100) NOT NULL,
    Country varchar(50),
    Region varchar(50),
    Population int,
    Latitude decimal(9, 6),
    Longitude decimal(9, 6)
);
go

--table to store average temperature data per month
create table AverageTemperature (
    TemperatureID int primary key,
    CityID int,
    Month int,
    AverageTemp decimal(5, 2),
    foreign key (CityID) references Cities(CityID)
);
GO
-- Create a table to store average precipitation data per month
create table AveragePrecipitation (
    PrecipitationID int primary key,
    CityID int,
    Month int,
    AveragePrecipitation decimal(5, 2),
    foreign key (CityID) references Cities(CityID)
);
go
--table to store sunny days data per year
create table SunnyDays (
    SunnyDaysID int primary key,
    CityID int,
    Year int,
    SunnyDaysCount int,
    foreign key (CityID) references Cities(CityID)
);
go

--This is where I create some stored procedures

-- Create a stored procedure to filter cities by average temperature and month
create or alter proc FilterCitiesByTemperatureAndMonth
    @MinTemp decimal(5, 2),
    @MaxTemp decimal(5, 2),
    @Month int
as
begin
    select 
        Cities.CityID,
        Cities.CityName,
        Cities.Country,
        Cities.Region,
        Cities.Population,
        Cities.Latitude,
        Cities.Longitude,
        AverageTemperature.Month,
        AverageTemperature.AverageTemp
    from
        Cities
    inner join
        AverageTemperature on Cities.CityID = AverageTemperature.CityID
    where
        AverageTemperature.AverageTemp between @MinTemp and @MaxTemp
        and AverageTemperature.Month = @Month;
end;
go

exec FilterCitiesByTemperatureAndMonth @MinTemp =60, @MaxTemp = 80, @Month = 12;
go



