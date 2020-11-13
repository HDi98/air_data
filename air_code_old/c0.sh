#!/bin/bash
for ((i=1988;i<=2008;i++))
do
sed -i '1d' /airdata_temp/$i.csv #删除首行变量名
cat /airdata_temp/$i.csv /airdata_temp/airdata.csv >> /airdata_temp/airdata.csv
done
