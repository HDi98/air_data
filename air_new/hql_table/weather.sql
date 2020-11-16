create external table if not exists airdata.weather(
    `yeartmp` INT,
    `monthtmp` INT,
    `daytmp` INT,
    `maxtemp` FLOAT,
    `meantemp` FLOAT,
    `mintemp` FLOAT,
    `maxdewpoint` FLOAT,
    `meandewpoint` FLOAT,
    `mindewpoint` FLOAT,
    `maxhumidity` FLOAT,
    `meanhumidity` FLOAT,
    `minhumidity` FLOAT,
    `maxsealevelpre` FLOAT,
    `meansealevelpre` FLOAT,
    `minsealevelpre` FLOAT,
    `maxvisibility` FLOAT,
    `meanvisibility` FLOAT,
    `minvisibility` FLOAT,
    `maxwindspeed` FLOAT,
    `meanwindspeed` FLOAT,
    `instantwindspeed` FLOAT,
    `rainfall` FLOAT,
    `cloudcover` INT,
    `events` string,
    `winddirdegrees` string,
    `airporttmp` string,
    `cityabbr`  string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION '/user/shared/dihaonan/weather';



load data inpath local '/user/shared/dihaonan/raw_data/rawweatherdata.csv' 
overwrite into table airdata.weather
;