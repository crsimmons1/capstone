###################
## Data Cleaning ##
###################

### Read in the data and import packages 
setwd("~/DataScience/capstone")

BPD <- read.csv("BPD_Part_1_Victim_Based_Crime_Data_March14_2020.csv") 

library(dplyr)


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

final <- BPD_4[BPD_4$year >= 2014,] #subsets dataframe to years 2014>

"""
### Add GDP Values 
head(final)
final$GDP <- 0
head(final)
final$GDP[final$year == 2020] <- 183.09
final$GDP[final$year == 2019] <- 183.09
final$GDP[final$year == 2018] <- 178.41
final$GDP[final$year == 2017] <- 177.08
final$GDP[final$year == 2016] <- 171.57
final$GDP[final$year == 2015] <- 169.11
final$GDP[final$year == 2014] <- 167.04
View(final)

"""


a<- final
b<- read.csv("weather_date.csv")
e<- read.csv("unemployment_version_final.csv")
c<- merge(a, b, by=c("year", "month", "day"))
d <- merge(c,e, by=c("month", "year"))



write.csv(d,"Baltimore_partiallycleaned_March14_2020.csv", row.names = FALSE)




