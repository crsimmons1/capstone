# Analysis on Baltimore PD Crime Data
Capstone project

## Project Objectives
Our primary goal is to find the best way to convey Baltimore’s crime data in a way that is helpful to the Baltimore Police Department. Our secondary goals were:

1) To predict what type of crime occured (violent or nonviolent)
2) To predict how many crimes will occur in a given day
3) To create visualizations that present interesting, informative findings

## Authors
1) Caroline Simmons
2) Sejal Patrikar
3) Jeannette Jiang
4) Jenny Jang


## Raw Data Files
* **BPD_Part_1_Victim_Based_Crime_Data_April25_2020.csv**: raw data from the Baltimore Police Department. Each row is an offense, with variables such as location, time, date, offense description, weapons, ect.
* **unemployment_version_final.csv** : Baltimore’s monthly unemployment rates from the Maryland Department of Labor from 2015-2019. Minor data cleaning has been done.
* **weather_final.csv** : weather data from the National Center for Environmental Information containing data on precipitation, snow, snow depth, average temperature, etc. for every day from 2015-2019. Minor data cleaning has been done.

## Cleaned/Created Data Files
* **baltimore_daily_cleaned.csv**: This contains all variables from 2014-2019 summarized by date. Run raw BPD data through Data_Cleaning_R.R and then through Balt_DataCleaning.ipynb to get this file.
* **baltimore_cleaned.csv**: This contains all variables from 2014-2019 as a transaction table. Run raw BPD data through Data_Cleaning_R.R and then through Balt_DataCleaning.ipynb to get this file.
* **neighborhood_balt.csv:** created data file compiling location and rank of top 5 most dangerous neighborhoods in 2020 for Baltimore.

## Predicting Daily Crime Totals
**Tree Method.R** contains several tree models
**TimeSeries.R** contains 2 SARIMA models
**LinearRegression.R** contains a simple MLR model

## Predicting Crime Type
**Capstone_Final_Logistic_Regression.R** - contains 2 logistic regression models.

## Visualizations
**TimeSeries.R** - contains COVID-19 time series plot
**Data_Visualization_Code.Rmd** - contains code for several graphs

## Dashboard 
**Capstone_dashboard.rmd**
NOTE: ggmap package is used in Capstone_dashboard.rmd. To run that file, one needs to register their device with an API in order to use ggmap and produce certain visualizations that require ggmap software.
