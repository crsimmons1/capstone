# Analysis on Baltimore PD Crime Data
Capstone project for the Spring of 2020. Completed on April 28th, 2020. 

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


## Data 
# Raw Data Files
* **BPD_Part_1_Victim_Based_Crime_Data_April25_2020.csv**: raw data from the Baltimore Police Department found [here](https://data.baltimorecity.gov/Public-Safety/BPD-Part-1-Victim-Based-Crime-Data/wsfq-mvij/data). Each row is an offense, with variables such as location, time, date, offense description, weapons, ect.
* **unemployment_version_final.csv** : Baltimore’s monthly unemployment rates from the Maryland Department of Labor from 2015-2019. Minor data cleaning has been done in Excel.
* **weather_final.csv** : weather data from the National Center for Environmental Information containing data on precipitation, snow, snow depth, average temperature, etc. for every day from 2015-2019. Minor data cleaning has been done in Excel.

# Cleaned/Created Data Files
* **baltimore_daily_cleaned.csv**: This contains all variables from 2014-2019 summarized by date. Run raw BPD data through DataCleaning_part1.R and then through DataCleaning_part2.ipynb to get this file.
* **baltimore_cleaned.csv**: This contains all variables from 2014-2019 as a transaction table. Run raw BPD data through DataCleaning_part1.R and then through DataCleaning_part2.ipynb to get this file.
* **neighborhood_balt.csv:** created data file compiling location and rank of top 5 most dangerous neighborhoods in 2020 for Baltimore.

## Predicting Daily Crime Totals
* **TreeMethod.R** contains several tree models
* **TimeSeries.R** contains 2 SARIMA models
* **LinearRegression.R** contains a simple MLR model.

## Predicting Crime Type
* **LogisticRegression.R** - contains 2 logistic regression models.

## Visualizations
* **TimeSeries.R** - contains COVID-19 time series plot
* **DataVisualization.Rmd** - contains code for several graphs

## Dashboard
* **Capstone_dashboard.rmd**- contains the code to run the flexdashboard [BaltimoreCrime](https://rpubs.com/jj_99/baltimorepdcrime). NOTE: ggmap package is used in Capstone_dashboard.rmd. To run that file, one needs to register their device with an API in order to use ggmap and produce certain visualizations that require ggmap software.
