create external table if not exists airdata.carriers(
    `code` string,
    `description` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION '/user/shared/dihaonan/db/carriers'
tblproperties("skip.header.line.count"="1");


load data inpath '/user/shared/dihaonan/raw_data/carriers.csv' 
overwrite into table airdata.carriers
;