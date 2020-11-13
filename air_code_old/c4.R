##########################C4
install.packages("RODBC")
library(ggplot2)
library(RODBC)
library(plyr)
library(reshape2)
ch=odbcConnect("mydata","root","8888") #与airdata连接的数据库接口的名称和密码
#注:需下载对应数据库的odbc驱动,并在系统中进行设置,不同系统的具体设置方法可自行查阅

###各个月份的航班数量
data=sqlQuery(ch,"select Delay,Month from laxtobos")
names(data)
head(data)
data=prop.table(table(data),2)
write.csv(data,"E:/Machine Learning/lvxiaoling/process2/c2_各个月份航班数.txt")
x=barplot(data,main="各个月份的延误比例")
text(x,data[1,]-0.3,labels=round(data[1,],2))
text(x,data[1,]+0.07,labels=round(data[2,],2))

###每周各个工作日的航班数目和延误比例
data=sqlQuery(ch,"select Delay,DayOfWeek from laxtobos ")
data=prop.table(table(data),2)
write.csv(data,"E:/Machine Learning/lvxiaoling/process2/c2_每周各个工作日延误比例.txt")
x=barplot(data,main="每周各个工作日的延误比例")
text(x,data[1,]-0.3,labels=round(data[1,],2))
text(x,data[1,]+0.07,labels=round(data[2,],2))
