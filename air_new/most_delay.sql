--延误次数最多的航班
select airdata_year.* from airdata.airdata_year t0

inner join
(
    select origin, dest, count(if (depdelay > 0, true, null)) as delay_count
    from
    airdata.airdata_year
    group by origin, dest 
    order by delay_count DESC
    limit 1
)t1 
on t0.origin = t1.origin, 
t0.dest = t1.dest

left join 
airdata.weather t2
on 
t2.yeartmp = t0.year,
t2.monthtmp = t0.month,
t2.daytmp = t0.dayofmonth,
t2.airporttmp = t0.origin
