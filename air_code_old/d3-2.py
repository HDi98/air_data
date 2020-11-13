#! /usr/bin/python
#-*-coding:utf-8-*-
import random

f=open('classdata_cleaned0008.csv','r') #d1.txt中创建的文件
w_train=open('classdata_cleaned0008_train.csv','w') #训练集
w_test=open('classdata_cleaned0008_test.csv','w') #测试集
#i=0
for line in f:
    if random.random()<0.6:
        w_train.write(line)
    else:
        w_test.write(line)
    #i+=1
    #if i==100:
    #    break
f.close()
w_train.close()
w_test.close()