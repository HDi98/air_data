
create external table if not exists airdata.airports(
    `iata` string,
    `airport` string,
    `city` string,
    `state` string,
    `country` string,
    `lat` float,
    `long` float
) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION '/user/shared/dihaonan/db/airports'
tblproperties("skip.header.line.count"="1");


load data inpath '/user/shared/dihaonan/raw_data/airports.csv' 
overwrite into table airdata.airports
;