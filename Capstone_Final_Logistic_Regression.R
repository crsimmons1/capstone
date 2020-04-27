#Packages
library(dplyr)
library(tidyverse)
library(car)

#Reading in Data
data1<-read.csv("baltimore_cleaned2.csv", header = TRUE) #baltimore 

#Initial Logistic Regression to Remove Insignificant Variables
logreg <- glm(Violent~Month+Year+Day+Inside+Weapon+District+Precipitation+Snow+SnowDepth+Tavg+Unemployment+CrimeType+Hour+DayPart, data=data1, family=binomial)
summary(logreg)

#Logistic Regression without Insignificant Variables
logreg1 <- glm(Violent~Month+Day+District+Precipitation+Tavg+Unemployment+Hour+DayPart, data=data1, family=binomial)
summary(logreg1)

#attaching data
attach(data1)

#Predicted Probabilities
probabilities <- predict(logreg1, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "Violent", "Non-Violent") #labeling greater than .5 as Violent
mydata <- data.frame(Month,Day,Tavg,Unemployment,Hour) #dataframe of just numerical variables
mydata1 <- mydata %>% 
  select_if(is.numeric) 
predictors <- colnames(mydata1)

#Calculating logit values and appending
logit <- log(probabilities/(1-probabilities)) #calculating logit probabilities
mydata3 <- cbind(mydata1,logit) #binding logit values to data
head(mydata3)
#-------------------------------------------------------------------------------------------------------------------
#Checking Linearity for Numerical Predictors: Month
plot(mydata3$Month, mydata3$logit, xlab="Month", ylab="Logit")
abline(lm(mydata3$logit~mydata3$Month), col="red") # regression line (y~x)
lines(lowess(mydata3$Month,mydata3$logit), col="blue")

#Checking Linearity for Numerical Predictors: Day
plot(mydata3$Day, mydata3$logit)
abline(lm(mydata3$logit~mydata3$Day), col="red") # regression line (y~x)
lines(lowess(mydata3$Day,mydata3$logit), col="blue")

#Checking Linearity for Numerical Predictors: Average Temperature
plot(mydata3$Tavg, mydata3$logit)
abline(lm(mydata3$logit~mydata3$Tavg), col="red") # regression line (y~x)
lines(lowess(mydata3$Tavg,mydata3$logit), col="blue")

#Checking Linearity for Numerical Predictors: Unemployment
plot(mydata3$Unemployment, mydata3$logit)
abline(lm(mydata3$logit~mydata3$Unemployment), col="red") # regression line (y~x)
lines(lowess(mydata3$Unemployment,mydata3$logit), col="blue")

#Checking Linearity for Numerical Predictors: Hour
plot(mydata3$Hour, mydata3$logit, xlab="Hour", ylab="logit")
abline(lm(mydata3$logit~mydata3$Hour), col="red") # regression line (y~x)
lines(lowess(mydata3$Hour,mydata3$logit), col="blue")

#All variables are linear except for Hour- consider a transformation
#--------------------------------------------------------------------------------------------------------------------------------
#Checking for Lack of Multicolinearity 

car::vif(logreg1)
# VIF are low so we can continue with all the variables- should still consider removing Hour since slightly over 5
#--------------------------------------------------------------------------------------------------------------------------------
#Logistic Regression- removing hour
final_logreg <- glm(Violent~Month+Day+District+Precipitation+Tavg+Unemployment+DayPart, data=data1, family=binomial)
summary(final_logreg)

#---------------------------------------------------------------------------------------------------------------------------------
#splitting data to determine accuracy of the model
set.seed(111) ## CHANGED FROM 50% TO 80% 
sample.data<-sample.int(nrow(data1), floor(.80*nrow(data1)), replace = F)
train<-data1[sample.data, ]
test<-data1[-sample.data, ]

#fitting a logistic regression model to our training data
result <- glm(Violent~Month+Day+District+Precipitation+Tavg+Unemployment+DayPart, data=train, family=binomial)
summary(result) #the predictor, day, is found to be insignificant
preds<-predict(result,newdata=test, type="response") #using the model to test against our testing data

#forming and ROC curve and finding the AUC
library(ROCR)
rates<-prediction(preds, test$Violent)
roc_result<-performance(rates, measure="tpr", x.measure="fpr")
plot(roc_result, main="ROC Curve")
lines(x = c(0,1), y = c(0,1), col="red")
auc<-performance(rates, measure = "auc")
auc

pred10_df <- data.frame(preds) #using the threshold of above 50% to be considered a violent crime
pred10_df$Violent[pred10_df$preds >= 0.5] <- 1 #a 1 is considered a violent crime
pred10_df$Violent[pred10_df$preds < 0.5] <- 0 #a 0 is considered a non-violent crime

#creating a confusion matrix to determine the sensitivity, specificity, and accuracy rates
library(caret)
confusionMatrix(as.factor(pred10_df$Violent), as.factor(test$Violent), positive = "1", dnn=c("Prediction", "Actual"), mode = "sens_spec")

#Used to calculate the MSE for our first version 
confusion.mat<- table(test$Violent, preds > 0.5)
overall.error<- (confusion.mat[1,2] + confusion.mat[2,1]) / sum(confusion.mat)

## TYPE 1 ERROR
type1.error<- confusion.mat[2,1] / (confusion.mat[1,1] + confusion.mat[2,1])
#----------------------------------------------------------------------------------------------------------------------------------------------
#We wanted to improve upon our initial model by increasing simplicity, and therefore, increasing interpretability
#We also wanted to increase or sensitivity and specificity rates, while keeping our accuracy rate where it is or higher

#Step-wise Regression
library(MASS)
install.packages("caret")
library(caret)
fullglm  <- glm(Violent~Month+Day+District+Precipitation+Tavg+Unemployment+DayPart, data=train, family=binomial)
stepwise1 <- stepAIC(fullglm,trace=FALSE) #chooses the best type of step-wise regression(front, backwards, both) for the data
summary(stepwise1)
coef(stepwise1) #the predictors that are kept and considered signficant (day has been removed)

#Producing a ROC curve and finding the AUC 
library(ROCR)
rates1<-prediction(preds1, test$Violent)
roc_result1<-performance(rates1,measure="tpr", x.measure="fpr")
plot(roc_result1, main="ROC Curve")
lines(x = c(0,1), y = c(0,1), col="red")
auc1<-performance(rates1, measure = "auc")
auc1 #0.592 #Very similar to previous model

#Reducing our threshold to a violent crime being greater than or equal to 35%
preds1<-predict(stepwise1, newdata=test, type="response")
pred1_df <- data.frame(preds1)
pred1_df$Violent[pred1_df$preds1 >= 0.35] <- 1
pred1_df$Violent[pred1_df$preds1 < 0.35] <- 0

#Create a Confusion Matrix to determine accuracy, sensitivity, and specificity rates
confusionMatrix(as.factor(pred1_df$Violent), as.factor(test$Violent), positive = "1", dnn=c("Prediction", "Actual"), mode = "sens_spec")
##From this we can compare and see that the sensitivity and specificity rates have improved drastically

#Calculating the MSE
confusion.mat1<-table(pred1_df$Violent,test$Violent)
overall.error1<- (confusion.mat1[1,2] + confusion.mat[2,1]) /sum(confusion.mat1)

## TYPE 1 ERROR
type1.error1<- confusion.mat1[2,1] / (confusion.mat1[1,1] + confusion.mat1[2,1])
#-------------------------------------------------------------------------------------------------------------------------------------------

#Potential Visualization
numdata <- cbind(data1$Month,data1$Day, data1$Precipitation, data1$Snow, data1$SnowDepth, data1$Tavg, data1$Unemployment, data1$Violent, data1$CrimeType, data1$Hour, data1$DayPart)
head(numdata)

# - correlation matrix 
install.packages("corrplot")
library(corrplot)
head(data1)
correlations <- cor(numdata) 
corrplot(correlations, method="circle") #8 is voolent or not
pairs(numdata, col=numdata[,8])
