CREATE EXTERNAL TABLE if not exists `airdata.airdata_year`(                     
  `year` int,                                      
  `month` int,                                     
  `dayofmonth` int,                                
  `dayofweek` int,                                 
  `deptime` int,                                   
  `crsdeptime` int,                                
  `arrtime` int,                                   
  `crsarrtime` int,                                
  `uniquecarrier` string,                          
  `flightnum` string,                              
  `tailnum` string,                                
  `actualelapsedtime` int,                         
  `crselapsedtime` int,                            
  `airtime` int,                                   
  `arrdelay` int,                                  
  `depdelay` int,                                  
  `origin` string,                                 
  `dest` string,                                   
  `distance` int,                                  
  `taxiin` int,                                    
  `taxiout` int,                                   
  `cancelled` int,                                 
  `cancellationcode` string,                       
  `diverted` int,                                  
  `carrierdelay` int,                              
  `weatherdelay` int,                              
  `nasdelay` int,                                  
  `securitydelay` int,                             
  `lateaircraftdelay` int
)
partitioned BY (`dt` int)                         
COMMENT 'this is all of the 21 sheets' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION '/user/shared/dihaonan/airdata_year'
tblproperties("skip.header.line.count"="1");