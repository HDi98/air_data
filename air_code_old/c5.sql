########C5
##########导入天气变量
DROP TABLE IF EXISTS weatherdata;
CREATE TABLE weatherdata(
yeartmp INT NOT NULL,
monthtmp INT NOT NULL,
daytmp INT NOT NULL,
maxtemp FLOAT NULL,
meantemp FLOAT NULL,
mintemp FLOAT NULL,
maxdewpoint FLOAT NULL,
meandewpoint FLOAT NULL,
mindewpoint FLOAT NULL,
maxhumidity FLOAT NULL,
meanhumidity FLOAT NULL,
minhumidity FLOAT NULL,
maxsealevelpre FLOAT NULL,
meansealevelpre FLOAT NULL,
minsealevelpre FLOAT NULL,
maxvisibility FLOAT NULL,
meanvisibility FLOAT NULL,
minvisibility FLOAT NULL,
maxwindspeed FLOAT NULL,
meanwindspeed FLOAT NULL,
instantwindspeed FLOAT NULL,
rainfall FLOAT NULL,
cloudcover INT NULL,
events varchar(50) NULL,
winddirdegrees varchar(50) NULL,
airporttmp varchar(50) NOT NULL,
cityabbr  varchar(50) NOT NULL) 
ENGINE=InnoDB DEFAULT CHARSET=ascii; #创建表格

LOAD DATA INFILE 'F:/air/rawweatherdata.csv ' #文件路径
INTO TABLE weatherdata
CHARACTER SET ascii
FIELDS TERMINATED BY ','
(yeartmp, monthtmp, daytmp, @vmaxtemp, @vmeantemp, @vmintemp, @vmaxdewpoint, @vmeandewpoint, @vmindewpoint, @vmaxhumidity, @vmeanhumidity, @vminhumidity, @vmaxsealevelpre, @vmeansealevelpre, @vminsealevelpre, @vmaxvisibility, @vmeanvisibility, @vminvisibility, @vmaxwindspeed, @vmeanwindspeed, @vinstantwindspeed, @vrainfall, @vcloudcover, @vevents, @vwinddirdegrees, airporttmp, cityabbr)
SET
maxtemp = nullif(@vmaxtemp,''),	
meantemp = nullif(@vmeantemp,''),	
mintemp = nullif(@vmintemp,''),	
maxdewpoint=nullif( @vmaxdewpoint,'')	,
meandewpoint=nullif( @vmeandewpoint	,''),	
mindewpoint=nullif( @vmindewpoint,''),
maxhumidity=nullif( @vmaxhumidity,''),
meanhumidity=nullif( @vmeanhumidity	,''),
minhumidity=nullif( @vminhumidity,''),
maxsealevelpre=nullif( @vmaxsealevelpre	,''),
meansealevelpre=nullif( @vmeansealevelpre,''),
minsealevelpre=nullif( @vminsealevelpre	,''),
maxvisibility=nullif(  @vmaxvisibility,''),
meanvisibility=nullif(  @vmeanvisibility,''),
minvisibility=nullif(  @vminvisibility,''),
maxwindspeed=nullif(  @vmaxwindspeed,''),
meanwindspeed=nullif(  @vmeanwindspeed,''),
instantwindspeed=nullif(  @vinstantwindspeed,''),
rainfall=nullif(  @vrainfall,''),
cloudcover=nullif(  @vcloudcover,''),
events =nullif(  @vevents,''),
winddirdegrees=nullif(  @vwinddirdegrees,'')
;

#创建表格laxtobos2,并将相关变量转化为分类变量
show tables;
create table laxtobos2 as (select Year,Month,DayofMonth,DayOfWeek,CRSDepTime,CRSArrTime,UniqueCarrier,Origin,Dest,ArrDelay,DepDelay from laxtobos);
#########修改选取的数据结构
alter table laxtobos2 add column MonthFactor varchar(20) not null after Month;
update laxtobos2 set MonthFactor="Spring" where Month in (3,4,5);
update laxtobos2 set MonthFactor="Summer" where Month in (6,7,8);
update laxtobos2 set MonthFactor="Autumn" where Month in (9,10,11);
update laxtobos2 set MonthFactor="Winter" where Month in (12,1,2);

alter table laxtobos2 add column DayOfWeekFactor varchar(20) not null after DayOfWeek;
update laxtobos2 set DayOfWeekFactor="HeadWeek" where DayOfWeek in (1,2);
update laxtobos2 set DayOfWeekFactor="MediumWeek" where DayOfWeek in (3,4,5);
update laxtobos2 set DayOfWeekFactor="Saturday" where DayOfWeek in (6);
update laxtobos2 set DayOfWeekFactor="Sunday" where DayOfWeek in (7);

alter table laxtobos2 add column CRSDepTimeFactor varchar(20) not null after CRSDepTime;
update laxtobos2 set CRSDepTimeFactor="Night" where CRSDepTime>=0000 and CRSDepTime<0500;
update laxtobos2 set CRSDepTimeFactor="EarlyMorning" where CRSDepTime>=0500 and CRSDepTime<0800;
update laxtobos2 set CRSDepTimeFactor="Morning" where CRSDepTime>=0800 and CRSDepTime<1100;
update laxtobos2 set CRSDepTimeFactor="Noon" where CRSDepTime>=1100 and CRSDepTime<1300;
update laxtobos2 set CRSDepTimeFactor="Afternoon" where CRSDepTime>=1300 and CRSDepTime<1700;
update laxtobos2 set CRSDepTimeFactor="Evening" where CRSDepTime>=1700 and CRSDepTime<2100;
update laxtobos2 set CRSDepTimeFactor="LateEvening" where CRSDepTime>=2100 and CRSDepTime<2400;

alter table laxtobos2 add column CRSArrTimeFactor varchar(20) not null after CRSArrTime;
update laxtobos2 set CRSArrTimeFactor="Night" where CRSArrTime>=0000 and CRSArrTime<0500;
update laxtobos2 set CRSArrTimeFactor="EarlyMorning" where CRSArrTime>=0500 and CRSArrTime<0800;
update laxtobos2 set CRSArrTimeFactor="Morning" where CRSArrTime>=0800 and CRSArrTime<1100;
update laxtobos2 set CRSArrTimeFactor="Noon" where CRSArrTime>=1100 and CRSArrTime<1300;
update laxtobos2 set CRSArrTimeFactor="Afternoon" where CRSArrTime>=1100 and CRSArrTime<1700;
update laxtobos2 set CRSArrTimeFactor="Evening" where CRSArrTime>=1700 and CRSArrTime<2100;
update laxtobos2 set CRSArrTimeFactor="LateEvening" where CRSArrTime>=2100 and CRSArrTime<2400;

alter table laxtobos2 add column Delay varchar(20) not null after ArrDelay;
update laxtobos2 set Delay="1" where ArrDelay>0;
update laxtobos2 set Delay="0" where ArrDelay<=0;

####提取LAX的天气数据
create table laxweatherdata as 
(select yeartmp as depyeartmp,monthtmp as depmonthtmp,daytmp as depdaytmp, 
airporttmp as depairporttmp, meantemp as depmeantemp,meandewpoint as depmeandewpoint, 
meanhumidity as depmeanhumidity, meansealevelpre as deppmeansealevelpre, 
meanvisibility as depmeanvisibility,meanwindspeed as depmeanwindspeed,
rainfall as deprainfall,cloudcover as depcloudcover
FROM  weatherdata where airporttmp="LAX");

####提取BOS的天气数据
create table bosweatherdata as 
(select yeartmp as arryeartmp,monthtmp as arrmonthtmp,daytmp as arrdaytmp, 
airporttmp as arrairporttmp, meantemp as arrmeantemp,meandewpoint as arrmeandewpoint, 
meanhumidity as arrmeanhumidity, meansealevelpre as arrmeansealevelpre, 
meanvisibility as arrmeanvisibility,meanwindspeed as arrmeanwindspeed,
rainfall as arrrainfall,cloudcover as arrcloudcover
FROM  weatherdata where airporttmp="BOS");

##处理异常值：云量的取值范围为0-10，超出此范围为缺失值；
update  bosweatherdata set arrcloudcover=NULL  where arrcloudcover<0 or  arrcloudcover>10;

#将航空数据与出发机场数据合并
DROP TABLE IF EXISTS airweathertmp;
create table airweathertmp as (select a.*,b.* from laxtobos2 a LEFT JOIN laxweatherdata b on 
a.Year=b.depyeartmp AND a.Month=b.depmonthtmp AND a.DayOfMonth=b.depdaytmp);

#将航空数据与到达机场数据合并
DROP TABLE IF EXISTS airweather;
create table airweather as (select a.*,b.* from airweathertmp a LEFT JOIN bosweatherdata b on 
a.Year=b.arryeartmp AND a.Month=b.arrmonthtmp AND a.DayOfMonth=b.arrdaytmp);

#从合并的表格中提取我们分类模型用到的变量
DROP TABLE IF EXISTS mydata;
create table mydata as (select Delay, MonthFactor, DayOfWeekFactor, CRSDepTimeFactor, 
CRSArrTimeFactor, UniqueCarrier, depmeantemp, depmeandewpoint, depmeanhumidity, 
deppmeansealevelpre, depmeanvisibility, depmeanwindspeed, deprainfall, depcloudcover,  
arrmeantemp, arrmeandewpoint, arrmeanhumidity, arrmeansealevelpre, arrmeanvisibility, 
arrmeanwindspeed, arrrainfall, arrcloudcover  from airweather);
