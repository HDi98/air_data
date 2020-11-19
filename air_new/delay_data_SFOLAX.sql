--延误次数最多的航班
select * from airdata.airdata_year t0

where t0.origin = 'LAX',
t0.dest = 'SFO'

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

into outfile 