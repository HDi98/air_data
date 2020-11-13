data<-read.csv("clusterdata.csv",sep="\t",col.names=c("origin","n_origin","n_dest","Cancel_origin",
"Cancel_dest","DepDelay","DepDelay_all","ArrDelay","ArrDelay_all","Distance_origin","nDistance_origin",
"Distance_dest","nDistance_dest"),header=F)
dim(data)###338个机场
data$iata<-data$origin
data$n<-data$n_origin+data$n_dest
data$PDepDelay<-data$DepDelay/data$DepDelay_all
data$PArrDelay<-data$ArrDelay/data$ArrDelay_all
data$PCancelled<-(data$Cancel_origin+data$Cancel_dest)/data$n
data$AveDistance<-(data$Distance_origin+data$Distance_dest)/(data$nDistance_dest+data$nDistance_origin)
airport<-data[,(ncol(data)-5):ncol(data)]

sum(is.na(airport))
summary(airport)

a=airport
detach(a)
attach(a)
###右偏
mar = c(1, 2, 2, 2)
hist(n)
hist(PDepDelay)
hist(PArrDelay)
hist(PCancelled)
hist(AveDistance)
###原变量值为0的变量值赋值为该变量除0以外的最小值
which(a$PCancelled==0)
a$PCancelled[which(a$PCancelled==0)]<-a$PCancelled[which(a$PCancelled==0)]+min(a[which(a$PCancelled!=0),]$PCancelled)
attach(a)
###取对数
hist(log(n))
hist(log(PDepDelay))
hist(log(PArrDelay))
hist(log(PCancelled))
hist(log(AveDistance))

a$n<-log(a$n)
a$PDepDelay<-log(a$PDepDelay)
a$PCancelled<-log(a$PCancelled)
a$AveDistance<-log(a$AveDistance)
detach(a)
attach(a)
head(a)
###kmeans
dist.a<-dist(scale(a[,2:6]))
plot(hclust(dist.a, method="ward"),labels=a[,1],xlab="airport",
     mar = c(13,2,6,1),main="Airport Cluster")
p<-NA
for(i in 2:6){
  model <- kmeans(scale(a[,2:6]),i,nstart =10)
  p[i-1]<-model$betweenss/model$totss
}
p
#轮廓系数
library(fpc)
silwidth<-NA
for (i in 2:6){
  model <- kmeans(scale(a[,2:6]),i,nstart=10)
  stats=cluster.stats(dist.a, model$cluster)
  silwidth[i-1]=stats$avg.silwidth#轮廓系数
}
silwidth
i=which.max(silwidth)+1;i
model <- kmeans(scale(a[,2:6]),3,nstart=10)
model
a$class<-model$cluster
model$size
model$betweenss/model$totss
a$sum<-NA
#插入机场地址数据
location<-read.csv("F:/air/airports.csv")
a<-merge(a,location, by = "iata",incomparables = NA)
M<-model$centers;M
#计算每个机场跟类中心的距离
a$sum[which(a$class==1)]<-rowSums((scale(a[,2:6])[which(a$class==1),]-M[1,])^2)
a$sum[which(a$class==2)]<-rowSums((scale(a[,2:6])[which(a$class==2),]-M[2,])^2)
a$sum[which(a$class==3)]<-rowSums((scale(a[,2:6])[which(a$class==3),]-M[3,])^2)
a1<-a[which(a$class==1),][which(rank(a[which(a$class==1),]$sum)<6),]
a2<-a[which(a$class==2),][which(rank(a[which(a$class==2),]$sum)<6),]
a3<-a[which(a$class==3),][which(rank(a[which(a$class==3),]$sum)<6),]
write.csv(a,file="class.csv")
###画图
library(maps)
#Airport Cluster of USA state
map('state',mar = c(3, 8, 6, 5), panel.first = grid(),col=9,cex=0.8)
axis(1, lwd = 0,cex=0.8); 
axis(2, lwd = 0,cex=0.8);  
title("Airport Cluster of USA state",cex=0.6)
points(long[which(a$class==1)],lat[which(a$class==1)], pch =22,col="blue",cex=0.8)
points(long[which(a$class==2)],lat[which(a$class==2)], pch =2,col="red",cex=0.8)
points(long[which(a$class==3)],lat[which(a$class==3)], pch =8,col="dark green",cex=0.8)
attach(a)

#Airport Cluster of Alaska
map('world',c('USA','Alaska'),mar = c(3, 8, 6, 5), 
    panel.first = grid(),ylim=c(50,75),xlim=c(-180,-120),col=9)
axis(1, lwd = 0); 
axis(2, lwd = 0);  
title("Airport Cluster of Alaska")
points(long[which(a$class==1)],lat[which(a$class==1)], pch =22,col="blue",cex=0.8)
points(long[which(a$class==2)],lat[which(a$class==2)], pch =2,col="red",cex=0.8)
points(long[which(a$class==3)],lat[which(a$class==3)], pch =8,col="dark green",cex=0.8)

#Airport Cluster of Hawaii
map('world', c("USA","Hawaii"),mar = c(3, 8, 6, 5),ylim=c(18,23),xlim=c(-160,-153),col=9)
axis(1, lwd = 0); 
axis(2, lwd = 0);  
title("Airport Cluster of Hawaii")
points(long[which(a$class==1)],lat[which(a$class==1)], pch =22,col="blue",cex=0.8)
points(long[which(a$class==2)],lat[which(a$class==2)], pch =2,col="red",cex=0.8)
points(long[which(a$class==3)],lat[which(a$class==3)], pch =8,col="dark green",cex=0.8)
legend("topright",c("class1","class2","class3"),pch=c(22,2,8),col=c("blue","red","dark green"))

