###################C6
##R代码
#install.packages("randomForest")
library(randomForest) 
#install.packages("gbm")
library(gbm) 
#install.packages("e1071")
library(e1071)
library(RODBC)
ch=odbcConnect("mydata","root","1000") #与airdata连接的数据库接口的名称和密码
#注:需下载对应数据库的odbc驱动,并在系统中进行设置,不同系统的具体设置方法可自行查阅

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
  F_measure=2*precision*recall/(precision+recall)#计算Recall，Precision和F-measure
  results=data.frame(Accuracy=Accuracy,recall=recall,precision=precision,F_measure=F_measure)
  return(results)
}

#将数据分为训练集和测试集
set.seed(100)
train=mydata[sample(1:dim(mydata)[1],ceiling(dim(mydata)[1]*0.6)),]
test=mydata[-sample(1:dim(mydata)[1],ceiling(dim(mydata)[1]*0.6)),]
#RF
summary(mydata$Delay)
rf.air=randomForest(Delay~.,data=train,mtry=5,importance=TRUE,ntree=500) 
help(predict)
rf.pred= predict(rf.air,newdata=test[,-1]) ####有修改
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

