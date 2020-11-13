###################C6
##R����
#install.packages("randomForest")
library(randomForest) 
#install.packages("gbm")
library(gbm) 
#install.packages("e1071")
library(e1071)
library(RODBC)
ch=odbcConnect("mydata","root","1000") #��airdata���ӵ����ݿ�ӿڵ����ƺ�����
#ע:�����ض�Ӧ���ݿ��odbc����,����ϵͳ�н�������,��ͬϵͳ�ľ������÷��������в���

mydata=sqlQuery(ch,"select * from mydata")
tail(mydata)
mydata=mydata[complete.cases(mydata),]
dim(mydata)

mydata$Delay=as.factor(mydata$Delay)
mydata$MonthFactor=as.factor(mydata$MonthFactor)
mydata$DayOfWeekFactor=as.factor(mydata$DayOfWeekFactor)
mydata$CRSDepTimeFactor=as.factor(mydata$CRSDepTimeFactor)
mydata$CRSArrTimeFactor=as.factor(mydata$CRSArrTimeFactor)
mydata$UniqueCarrier=as.factor(mydata$UniqueCarrier)

index2=function(table) {
  Accuracy=table[1,1]+table[2,2]
  precision=table[2,2]/sum(table[,2])
  recall=table[2,2]/sum(table[2,])
  F_measure=2*precision*recall/(precision+recall)#����Recall��Precision��F-measure
  results=data.frame(Accuracy=Accuracy,recall=recall,precision=precision,F_measure=F_measure)
  return(results)
}

#�����ݷ�Ϊѵ�����Ͳ��Լ�
set.seed(100)
train=mydata[sample(1:dim(mydata)[1],ceiling(dim(mydata)[1]*0.6)),]
test=mydata[-sample(1:dim(mydata)[1],ceiling(dim(mydata)[1]*0.6)),]
#RF
summary(mydata$Delay)
rf.air=randomForest(Delay~.,data=train,mtry=5,importance=TRUE,ntree=500) 
help(predict)
rf.pred= predict(rf.air,newdata=test[,-1]) ####���޸�
rf.real=test$Delay
table_RF=table(rf.real,rf.pred)/nrow(test)
a=index2(table_RF)


#SVM_LINEAR
svmfit=svm(Delay~., data=train, kernel="linear", cost=1) 
svm.pred=predict(svmfit,test)
svm.real=test$Delay
table(svm.real,svm.pred)
table_svm1=table(svm.real,svm.pred)/nrow(test)


#SVM_RADIAL
svmfit1=svm(Delay~., data=train, kernel="radial", cost=100) 
svm.pred1=predict(svmfit1,test)
svm.real1=test$Delay
table(svm.real1,svm.pred1)
table_svm2=table(svm.real1,svm.pred1)/nrow(test)
