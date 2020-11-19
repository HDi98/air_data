select origin, dest, 
count(if (depdelay > 0, true, null)) as delay_count,
count(*) as all_flights
from
    airdata.airdata_year
group by origin, dest 
order by delay_count DESC
limit 2