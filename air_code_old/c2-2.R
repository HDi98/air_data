##########################C2
#setwd("/home/air_data/")
library(reshape2)
library(ggplot2)

data1=read.table("total_delay1.txt",header=F)
colnames(data1)=c("year","总航班数","到达延迟航班数")
data1=melt(data1,id.vars="year")
ggplot(data1,aes(x=year,y=value))+geom_line(aes(x=year,colour=variable),size=2)+labs(title="各个年份的总航班数和延迟航班数",x="年份",y="航班数")+ylim(0,8000000)

#各个年份的平均延迟时间
data2=read.table("avg_delay1.txt",header=F)
colnames(data2)=c("year","平均出发延迟","平均到达延迟")
data2=melt(data2,id.vars = "year")
ggplot(data2,aes(x=year,y=value))+geom_line(aes(x=year,colour=variable),size=2)+labs(title="各个年份的平均延迟时间",x="年份",y="时间(min)")

