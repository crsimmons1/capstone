#########################################################
# READ IN THE DATA AND SUBSET IT                        #
#########################################################
setwd("~/DataScience/capstone")

library(astsa) ##load package for acf2 and sarima functions


# line graph of total crime throughout the years with economics theme
library(zoo)
library(ggthemes)
library(ggplot2)
library(tidyverse)
library(dplyr)
#load in datafile
BPD <- read.csv("BPD_Part_1_Victim_Based_Crime_Data_April25_2020.csv") 


### Creating date columns
BPD$CrimeDate <- as.character(BPD$CrimeDate) #sets CrimeDate column as character variable

BPD$CrimeDate <- as.Date(BPD$CrimeDate, "%m/%d/%Y") #creates CrimeDate column as date variable

df_date <- data.frame(date = BPD$CrimeDate,
                      year = as.numeric(format(BPD$CrimeDate, format = "%Y")),
                      month = as.numeric(format(BPD$CrimeDate, format = "%m")),
                      day = as.numeric(format(BPD$CrimeDate, format = "%d"))) #creates year, month, and day as separate columns

df_date <- select(df_date, year, month, day) #selecting certain columns 

BPD_4 <- cbind(df_date, BPD) #binding date columns to original data frame

BPD_4$CrimeDate <- format(BPD_4$CrimeDate, "%m/%d/%Y") #reformatting CrimeDate Column to desired format

balt_clean <- BPD_4[BPD_4$year >= 2014,] #subsets dataframe to years 2014>


#adding season variable
yq <- as.yearqtr(as.yearmon(balt_clean$CrimeDate, "%m/%d/%Y") + 1/12) 
balt_clean$Season <- factor(format(yq, "%q"), 
                            levels=1:4, 
                            labels=c("Winter","Spring", "Summer", "Fall"))


tot_c2 <- balt_clean %>% group_by(CrimeDate) %>% summarise(Count=n()) # obtaining count of crimes for each day

tot_c2<- merge(tot_c2, balt_clean[,c(4,20)], by=c("CrimeDate"))

tot_c2$CrimeDate <- as.Date(tot_c2$CrimeDate, format="%m/%d/%Y") # changing CrimeDate variable to date format


BPDD<- tot_c2[!duplicated(tot_c2)]
# Replace outliers with the value 200 
BPDD$TotalCrime[BPDD$TotalCrime >= 200] <- 200

# Make into a Time Series Object
Crime2020 <-ts(BPDD$TotalCrime)

# Find the Number of Days
n <- length(Crime2020)
n
# Row number of last day of 2019 
n2019 <- 1826


# Subset to pre-2019 only 
DailyTotal <- Crime2020[1:n2019]

# Subset to only the last 100 days (excluding 2020)
Crime <- DailyTotal[(n2019-99):n2019]


length(Crime2020) #all crime daily totals (up to April 18th, 2020)
length(Crime) #subset to last 100 days of 2019
length(DailyTotal) #subset to 2015-2019

#########################################################
# TIME SERIES PLOTS                                     #
#########################################################

# plot of all data
plot.ts(Crime2020, main="Time Series Plot (Jan. 1st 2015 - April 18th 2020)")
# too scrunched up - subset to smaller time frame 

# plot of last 100 days of 2019 
plot.ts(Crime, main="Time Series Plot (Sept. 22nd - Dec. 31st 2019)")

# ACF plot of data
acf(DailyTotal, main="ACF for Daily Crime", lag.max=100)

# 2 rows of charts 
par(mfrow=c(2,1))

# Plot Various Differenced Data
plot.ts(diff(Crime), main="Time Series Plot for Differenced Data")
plot.ts(diff(Crime,7), main="Time Series Plot for Seasonal Differenced Data")

##log transform data
logCrime<-log(Crime)

# Plot Various Differenced Data
plot.ts(diff(logCrime), main="Time Series Plot for Differenced Log(Data)")
plot.ts(diff(logCrime,7), main="Time Series Plot for Seasonal Differenced Log(Data)")

plot.ts(diff(diff(Crime,365)), main="Time Series Plot for Seasonal Differenced Data")
plot.ts(diff(diff(DailyTotal,7)), main="Time Series Plot for Seasonal Differenced Data (all)")

# back to 1 plot in a row 
par(mfrow=c(1,1))

#########################################################
# DETERMINE DIFFERENCING                                #
#########################################################

#Periodogram 
mvspec(DailyTotal)

#Apply smoothing to the data 
k<-kernel("daniell",c(7,7)) ##the value 7 means we smooth using 4 terms before, 7 terms after, plus current term, so L=15. 
# daniell is specified when we apply equal weights to all 9 terms
soi.smooth<-mvspec(DailyTotal,k)

# plot of last 100 days of 2019 
plot.ts(Crime, main="Time Series Plot (Sept. 22nd - Dec. 31st 2019)")
plot.ts(diff(diff(Crime,7)), main="Time Series Plot for Differenced Data")

#########################################################
# DETERMINE MODEL PARAMS                                #
#########################################################


# ACF AND PACF Plot - Seasonal and Nonseasonal Differencing 
acf2(diff(diff(Crime,7)),35, 
     main="ACF/PACF with both regular and seasonal differencing")[-1:-35,]

#Calculate period (1/frequency)
1/0.15


# have d=1, D=1, s=7
# p, q, P, Q are 0 or 1 
fit1<-sarima(DailyTotal,1,1,0,1,1,0,7)  #diagnostics are OK 
fit2<-sarima(DailyTotal,1,1,0,1,1,1,7)  #diagnostics are off
fit3<-sarima(DailyTotal,0,1,1,1,1,0,7)  #diagnostics are OK
fit4<-sarima(DailyTotal,0,1,1,1,1,1,7)  #diagnostics are off
fit5<-sarima(DailyTotal,1,1,1,1,1,0,7)  #diagnostics are OK
fit6<-sarima(DailyTotal,1,1,1,1,1,1,7)  #diagnostics are off
fit7<-sarima(DailyTotal,1,1,1,0,1,1,7)  #diagnostics are OK, plots are OK

# p =2, 3, 4
# P= 0
fit8<-sarima(DailyTotal,2,1,1,0,1,1,7)  #diagnostics are off
fit9<-sarima(DailyTotal,3,1,1,0,1,1,7)  #diagnostics are off
fit10<-sarima(DailyTotal,4,1,1,0,1,1,7)  #diagnostics are off
# p=1 , P= 2, 3, 4, 5
fit11<-sarima(DailyTotal,1,1,1,2,1,1,7)  #diagnostics are OK, plots are OK
fit12<-sarima(DailyTotal,1,1,1,3,1,1,7)  #diagnostics are OK, plots are OK


# p=0, q=3
fit13<-sarima(DailyTotal,0,1,3,0,1,1,7)  #diagnostics are ok, plots are OK

# so model 1 will be fit 7
fit7
# and model 2 will be fit 13
fit13


#########################################################
# FIT MODEL 1                                           #
#########################################################


#predict the next 12 observations
preds<-sarima.for(DailyTotal,31,1,1,1,0,1,1,7)
preds

#overlay actual values on the plot with predictions
lines(1827:(1827+30), Crime2020[1827:(1827+30)], type="b", col="blue")
title(main="Predictions for SARIMA(1,1,1)x(0,1,1)7 Model")
legend("bottomleft", c("Actual Value", "Prediction"),lty = 1, col = c("blue", "red"))

#calculate lower and upper bounds of prediction intervals
lower<-preds$pred - 1.96*preds$se
upper<-preds$pred + 1.96*preds$se
actual <- Crime2020[1827:(1827+30)]
predictions <- preds$pred
interval <- list(lower,upper)

#create a table with lower bound, actual value, and upper bound
comp<-cbind(actual, predictions, lower, upper)

df <- data.frame(comp)
df$Interval <- FALSE
for (i in (1:nrow(df))){
  real <- df[i,"actual"]
  lower <- df[i,"lower"]
  upper <- df[i,"upper"]
  if (real > lower){
    if (real < upper){
      df[i,"Interval"] <- TRUE
    }
  }
}

# Evaluate forecast with package 
library(forecast)
accuracy(preds$pred, actual)
accuracy(fit7$preds, DailyTotal)s


# Manually evaluating forecasting - if you don't want to download the package 
# Calculate error
error <- actual - predictions

# Function that returns Root Mean Squared Error
rmse <- function(error)
{
  sqrt(mean(error^2))
}
# Calculate RMSE
rmse(error)

# Function that returns Mean Absolute Error
mae <- function(error)
{
  mean(abs(error))
}
#Calculate MAE
mae(error)




#########################################################
# FIT MODEL 2                                           #
#########################################################


#predict the next 12 observations
preds2<-sarima.for(DailyTotal,31,0,1,3,0,1,1,7)
preds2

#overlay actual values on the plot with predictions
lines(1827:(1827+30), Crime2020[1827:(1827+30)], type="b", col="blue")
title(main="Predictions for SARIMA(0,1,3)x(0,1,1)7 Model")
legend("bottomleft", c("Actual Value", "Prediction"),lty = 1, col = c("blue", "red"))

#calculate lower and upper bounds of prediction intervals
lower<-preds2$pred - 1.96*preds$se
upper<-preds2$pred + 1.96*preds$se
actual <- Crime2020[1827:(1827+30)]
predictions <- preds2$pred
interval <- list(lower,upper)

#create a table with lower bound, actual value, and upper bound
comp2<-cbind(actual, predictions, lower, upper)

df <- data.frame(comp2)
df$Interval <- FALSE
for (i in (1:nrow(df))){
  real <- df[i,"actual"]
  lower <- df[i,"lower"]
  upper <- df[i,"upper"]
  if (real > lower){
    if (real < upper){
      df[i,"Interval"] <- TRUE
    }
  }
}

# Evaluate forecast with package 
accuracy(preds2$pred, actual)

# Manually evaluating forecasting - if you don't want to download the package 
# Calculate error
error <- actual - predictions

# Calculate RMSE
rmse(error)

#Calculate MAE
mae(error)



#########################################################
# COVID 19                                              #
#########################################################

remove <- which(tot_c2$Count >= 250) #finding which row to remove
tot_c_fin <- tot_c2[-remove,] #subsetting to everything but the removed row

ggplot(tot_c_fin, aes(x=CrimeDate, y=Count, color=Season)) + 
  geom_line(aes(group=1)) +
  scale_x_date(date_labels="%b %Y", date_breaks="1 year") + 
  theme_economist() +
  scale_color_economist() +
  ggtitle("Total Crime Throughout the Years") +
  theme(plot.title=element_text(hjust=0.5))
