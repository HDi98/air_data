##########################C2
#setwd("/home/air_data/")
library(reshape2)
library(ggplot2)

data1=read.table("total_delay1.txt",header=F)
colnames(data1)=c("year","�ܺ�����","�����ӳٺ�����")
data1=melt(data1,id.vars="year")
ggplot(data1,aes(x=year,y=value))+geom_line(aes(x=year,colour=variable),size=2)+labs(title="������ݵ��ܺ��������ӳٺ�����",x="���",y="������")+ylim(0,8000000)

#������ݵ�ƽ���ӳ�ʱ��
data2=read.table("avg_delay1.txt",header=F)
colnames(data2)=c("year","ƽ�������ӳ�","ƽ�������ӳ�")
data2=melt(data2,id.vars = "year")
ggplot(data2,aes(x=year,y=value))+geom_line(aes(x=year,colour=variable),size=2)+labs(title="������ݵ�ƽ���ӳ�ʱ��",x="���",y="ʱ��(min)")
