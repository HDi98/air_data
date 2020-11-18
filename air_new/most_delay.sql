--延误次数最多的航班
select * from airdata.airdata_year t0

inner join
(
    select origin, dest, count(if (depdelay > 0, true, null)) as delay_count
    from
    airdata.airdata_year
    group by origin, dest 
    order by delay_count DESC
    limit 1
) t1 
on t0.origin = t1.origin
and t0.dest = t1.dest

left join 
airdata.weather dep
on 
dep.yeartmp = t0.year
and dep.monthtmp = t0.month
and dep.daytmp = t0.dayofmonth
and dep.airporttmp = t0.origin

left join 
airdata.weather arr 
on 
arr.yeartmp = t0.year
and arr.monthtmp = t0.month
and arr.daytmp = t0.dayofmonth
and arr.airporttmp = t0.dest
