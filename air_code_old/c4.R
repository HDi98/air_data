##########################C4
install.packages("RODBC")
library(ggplot2)
library(RODBC)
library(plyr)
library(reshape2)
ch=odbcConnect("mydata","root","8888") #��airdata���ӵ����ݿ�ӿڵ����ƺ�����
#ע:�����ض�Ӧ���ݿ��odbc����,����ϵͳ�н�������,��ͬϵͳ�ľ������÷��������в���

###�����·ݵĺ�������
data=sqlQuery(ch,"select Delay,Month from laxtobos")
names(data)
head(data)
data=prop.table(table(data),2)
write.csv(data,"E:/Machine Learning/lvxiaoling/process2/c2_�����·ݺ�����.txt")
x=barplot(data,main="�����·ݵ��������")
text(x,data[1,]-0.3,labels=round(data[1,],2))
text(x,data[1,]+0.07,labels=round(data[2,],2))

###ÿ�ܸ��������յĺ�����Ŀ���������
data=sqlQuery(ch,"select Delay,DayOfWeek from laxtobos ")
data=prop.table(table(data),2)
write.csv(data,"E:/Machine Learning/lvxiaoling/process2/c2_ÿ�ܸ����������������.txt")
x=barplot(data,main="ÿ�ܸ��������յ��������")
text(x,data[1,]-0.3,labels=round(data[1,],2))
text(x,data[1,]+0.07,labels=round(data[2,],2))