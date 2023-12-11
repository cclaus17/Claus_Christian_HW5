use WeatherData
go

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

use WeatherData
go

create table SearchHistory (
    SearchId int primary key identity(1,1),
    UserId nvarchar(128),
    SearchDate datetime,
    MinTemperature decimal(5, 2),
    MaxTemperature decimal(5, 2),
    SelectedMonth int,
);
go

use WeatherData
go

select * from dbo.AspNetUsers
go

-- Add UserName column to SearchHistory table
alter table SearchHistory
add UserName nvarchar(256);

-- Update existing records to have valid UserId values
update sh
set sh.UserId = u.UserName
from SearchHistory sh
join dbo.AspNetUsers u on sh.UserId = u.UserName
where sh.UserId IS NOT NULL AND u.UserName IS NOT NULL;
go


alter table SearchHistory
use WeatherData;
go

alter column UserId nvarchar(256);
go


select * from SearchHistory
go

create or alter proc TrackSearch
    @UserName nvarchar(128),
    @MinTemperature decimal(5, 2),
    @MaxTemperature decimal(5, 2),
    @Month int
as
begin
    insert into SearchHistory (UserName, MinTemperature, MaxTemperature, SelectedMonth, SearchDate)
    values (@UserName, @MinTemperature, @MaxTemperature, @Month, GETDATE());
end;
go

drop proc TrackSearch
go

select * from SearchHistory
go




use WeatherData
go


