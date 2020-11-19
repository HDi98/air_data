-- 起飞延误
set hive.cli.print.header = true;
select year, 
origin, 
count(*) total_flight, 
count(if (depdelay > 0, true, null)) as delay_count, 
count(if(cancelled == 1, true, null)) as cancel_count, 
sum(if(depdelay>0, depdelay, null)) / count(if (depdelay > 0, true, null)) as avg_delaytime
from airdata.airdata_year
group by year, origin