weather_unemployment_daily <- read.csv("weather_unemployment_daily.csv")

library('MASS')
library('tree')
library('randomForest')
library('gbm')
attach(weather_unemployment_daily)

# split data into half, half is train and half is test
sample.data<-sample.int(nrow(weather_unemployment_daily), floor(.50*nrow(weather_unemployment_daily)), replace = F)
train2<-weather_unemployment_daily[sample.data, ]
test2<-weather_unemployment_daily[-sample.data, ]

## Tree
tree.class.train<-tree(TotalCrime ~ PRCP+SNOW+SNWD+Unemployment+Year+Month+TAVG, data=train2)
summary(tree.class.train)

plot(tree.class.train)
text(tree.class.train, cex=0.75, pretty=0)

## Pruning
cv.crime<-cv.tree(tree.class.train, K=10) # same output as no pruning
cv.crime

# plotting the pruned tree
prune.crime=prune.tree(tree.class.train ,best=5)
plot(prune.crime)
text(prune.crime , pretty =0)

yhat.prune = predict(prune.crime ,newdata = test2)
data.test=test2["TotalCrime"]
diff = yhat.prune - data.test
sqrt(sum(diff^2)/913)
 ## Test MSE of pruned tree: 19.98526

yhat = predict(tree.class.train ,newdata = test2)
data.test=test2["TotalCrime"]
diff = yhat - data.test
sqrt(sum(diff^2)/913)
 ## Test MSE of unpruned tree: 22.93837




## Bagging
bag.class<-randomForest(TotalCrime~PRCP+SNOW+SNWD+Unemployment+Year+Month+TAVG, data=train2, mtry=7, importance=TRUE, ntree=2000)
bag.class
# %explained variance is a measure of how well out-of-bag predictions explain the target variance of the training set. 
# Unexplained variance would be to due true random behaviour or lack of fit.


yhat.bag = predict(bag.class ,newdata = test2)
data.test=test2["TotalCrime"]
diff.bag = yhat.bag - data.test
sqrt(sum(diff.bag^2)/913)
# Test MSE with bagging : 18.83332

## evaluate which predictors were the most important
importance(bag.class)
varImpPlot(bag.class)

RF.class<-randomForest(TotalCrime~PRCP+SNOW+SNWD+Unemployment+Year+Month+TAVG, data=train2, mtry=2, importance=TRUE, ntree=2000)
RF.class
# %explained variance is a measure of how well out-of-bag predictions explain the target variance of the training set. 
# Unexplained variance would be to due true random behaviour or lack of fit.
?randomForest

yhat.RF = predict(RF.class ,newdata = test2)
data.test=test2["TotalCrime"]
diff.RF = yhat.RF - data.test
sqrt(sum(diff.RF^2)/913)
# Test MSE with RF: 17.33683

## evaluate which predictors were the most important
importance(RF.class)
varImpPlot(RF.class)

dev.off()

## Boosting
boost.class<-gbm(TotalCrime~PRCP+SNOW+SNWD+Unemployment+Year+Month+TAVG, data=train2, distribution="gaussian", n.trees=2000)
summary(boost.class)
plot(boost.class,i="TAVG")
plot(boost.class,i="Unemployment")
plot(boost.class,i="Month")
# These plots illustrate the marginal effect of the selected variables on the 
# response after integrating out the other variables. 


yhat.boost=predict (boost.class ,newdata = test2 ,n.trees=500)
diff.boost = yhat.boost - data.test
sqrt(sum(diff.boost^2)/913)
  # Test MSE after boosting: 16.98436
dev.off()
