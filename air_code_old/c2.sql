####C2：
#各个年份的总航班数和延误数
select Year,count(*) as totalnum,count(if(ArrDelay>0,true,null)) as arrdelay from airdat 
group by Year into outfile "/var/lib/mysql/total_delay1.txt";

#各个年份的平均出发延误和到达延误
select Year,avg(DepDelay) as depdelay,  avg(ArrDelay) as arrdelay from airdat 
group by Year into outfile "/var/lib/mysql/avg_delay1.txt";


注：outfile需注意是否有写入该路径的权限，一般默认的导出路径为/var/lib/mysql，可存储于该路径后复制
若希望修改存储目录权限，请参考：http://blog.csdn.net/lichangzai/article/details/1873328