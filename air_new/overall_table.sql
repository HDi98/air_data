	#####C1
create database airdata;   #创建新的数据库
use airdata;
DROP TABLE IF EXISTS airdat;
CREATE  TABLE airdat (
  `Year` int(255) DEFAULT NULL,
  `Month` tinyint(255) DEFAULT NULL,
  `DayofMonth` tinyint(255) DEFAULT NULL,
  `DayOfWeek` tinyint(255) DEFAULT NULL,
  `DepTime` varchar(255) DEFAULT NULL,
  `CRSDepTime` varchar(255) DEFAULT NULL,
  `ArrTime` varchar(255) DEFAULT NULL,
  `CRSArrTime` varchar(255) DEFAULT NULL,
  `UniqueCarrier` varchar(255) DEFAULT NULL,
  `FlightNum` varchar(255) DEFAULT NULL,
  `TailNum` varchar(255) DEFAULT NULL,
  `ActualElapsedTime` varchar(255) DEFAULT NULL,
  `CRSElapsedTime` varchar(255) DEFAULT NULL,
  `AirTime` varchar(255) DEFAULT NULL,
  `ArrDelay` varchar(255) DEFAULT NULL,
  `DepDelay` varchar(255) DEFAULT NULL,
  `Origin` varchar(255) DEFAULT NULL,
  `Dest` varchar(255) DEFAULT NULL,
  `Distance` varchar(255) DEFAULT NULL,
  `TaxiIn` varchar(255) DEFAULT NULL,
  `TaxiOut` varchar(255) DEFAULT NULL,
  `Cancelled` varchar(255) DEFAULT NULL,
  `CancellationCode` varchar(255) DEFAULT NULL,
  `Diverted` varchar(255) DEFAULT NULL,
  `CarrierDelay` varchar(255) DEFAULT NULL,
  `WeatherDelay` varchar(255) DEFAULT NULL,
  `NASDelay` varchar(255) DEFAULT NULL,
  `SecurityDelay` varchar(255) DEFAULT NULL,
  `LateAircraftDelay` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii; #创建表格

LOAD DATA LOCAL INFILE '/home/air_data/airdata.csv'   #文件路径(需加LOCAL以解决路径问题)
INTO TABLE airdat
CHARACTER SET ascii
FIELDS TERMINATED BY ',' ENCLOSED BY '"';#将数据导入mysql