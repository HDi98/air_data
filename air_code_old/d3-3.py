#! /usr/bin/env python
from pyspark import SparkContext,SparkConf
from pyspark.mllib.regression import LabeledPoint
from pyspark.mllib.classification import LogisticRegressionWithLBFGS
from pyspark.mllib.tree import RandomForest
from pyspark.sql import SQLContext

# Configuration if you use spark-submit 
conf = SparkConf().setAppName("Test Application")
conf = conf.setMaster("local[10]")
sc = SparkContext(conf=conf)
sqlCtx = SQLContext(sc)

def create_label_point(line):
    line=line.strip().split(',')
    #line = [0 if x == '' or x == '-' or x == 'NULL' else x for x in line]
    #depdelay = 1.0
    #if float(line[0]) == 0:
     #   depdelay = 0.0
    return LabeledPoint(line[0], [float(x) for x in line[1:]])
    #return LabeledPoint(depdelay, [float(x) for x in line[1:]])


train=sc.textFile("classdata_cleaned0008_train.csv").map(create_label_point)
test=sc.textFile("classdata_cleaned0008_test.csv").map(create_label_point)


#data=sc.textFile("classdata_cleaned.csv")
#parsedData=data.map(create_label_point)
#train,test=parsedData.randomSplit([0.6,0.4],seed=11L)

#traintmp=sc.textFile("train0120.csv")
#train=traintmp.map(create_label_point)
#testtmp=sc.textFile("test0120.csv")
#test=testtmp.map(create_label_point)
#print "random start"


#train_size = train.count()
#test_size = test.count()
#print train_size
#print test_size

print "rf start"
# Train a RandomForest model.
model = RandomForest.trainClassifier(train, numClasses=2,
                            categoricalFeaturesInfo={0:4,1:4,2:7,3:7},
                            numTrees=20,
                            featureSubsetStrategy="auto",
                            impurity="gini",
                            maxDepth=5,
                            maxBins=64)

# Evaluate model on test instances and compute test error
predictions = model.predict(test.map(lambda x: x.features))
labels_and_preds = test.map(lambda p: p.label).zip(predictions)
#testErr = labels_and_preds.filter(lambda (v, p): v != p).count() / float(test_size)
#print "Testing Error = " + str(testErr)

# Confusion Matrix
testErr_11 = labels_and_preds.filter(lambda (v, p): (v, p) == (1, 1)).count()
testErr_10 = labels_and_preds.filter(lambda (v, p): (v, p) == (1, 0)).count()
testErr_01 = labels_and_preds.filter(lambda (v, p): (v, p) == (0, 1)).count()
testErr_00 = labels_and_preds.filter(lambda (v, p): (v, p) == (0, 0)).count()

print testErr_11
print testErr_10
print testErr_01
print testErr_00

accuracy=(float(testErr_11)+float(testErr_00))/(float(testErr_11)+float(testErr_10)+float(testErr_01)+float(testErr_00))
recall=float(testErr_11)/(float(testErr_11)+float(testErr_10))
precision=float(testErr_11)/(float(testErr_11)+float(testErr_01))
F1_measure=2*precision*recall/(precision+recall)

print 'accuracy:\t',accuracy
print 'recall:\t',recall
print 'precision:\t',precision
print 'F1_measure:\t',F1_measure
