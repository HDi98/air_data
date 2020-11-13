#! /usr/bin/python
#-*- coding:utf-8 -*-
import time

t0=time.time()

dict_month_to_season={'1':'3','2':'3','3':'0','4':'0','5':'0','6':'1','7':'1','8':'1','9':'2','10':'2','11':'2','12':'3'}
dict_dayofweek_to_weekday={'1':'0','2':'0','3':'0','4':'1','5':'1','6':'2','7':'3'}

def split_time(str):
    t=int(str)
    if t>=0 and t<500:
        return('0')
    elif t>=500 and t<800:
        return('1')
    elif t>=800 and t<1100:
        return('2')
    elif t>=1100 and t<1700:
        return('3')
    elif t>=1700 and t<21000:
        return('4')
    elif t>=2100 and t<24000:
        return('5')
    else:
        return(-1)


f=open('classdata0008.csv','r') #d1.txt中创建的文件
w=open('classdata_cleaned0008.csv','w')



i=0
for line in f:
    if 'NULL' in line:
        continue
    tmp=line.strip().split('\t')
    if line[0]=='-' or line[0]=='0':
        try:
            l=','.join(['0']+[dict_month_to_season[tmp[1]]]+[dict_dayofweek_to_weekday[tmp[2]]]+[split_time(tmp[3])]+[split_time(tmp[4])]+tmp[5:])
        except:
            continue
    else:
        try:
            l=','.join(['1']+[dict_month_to_season[tmp[1]]]+[dict_dayofweek_to_weekday[tmp[2]]]+[split_time(tmp[3])]+[split_time(tmp[4])]+tmp[5:])
        except:
            continue
    w.write(l+'\n')

    #if i==500:
    #    break
    #i+=1
f.close()
w.close()
print time.time()-t0
