
baltimore <- read.csv("baltimore_daily_cleaned.csv")
# Read in the file
attach(baltimore)
# attached the data

scatter.smooth(x=Year, y=TotalCrime, main="") 
scatter.smooth(x=Month, y=TotalCrime, main="") 
scatter.smooth(x=Day, y=TotalCrime, main="") 
scatter.smooth(x=Temperature, y=TotalCrime, main="") 
scatter.smooth(x=Precipitation, y=TotalCrime, main="") 
scatter.smooth(x=Snow, y=TotalCrime, main="") 
scatter.smooth(x=SnowDepth, y=TotalCrime, main="") 
scatter.smooth(x=Unemployment, y=TotalCrime, main="") 
scatter.smooth(x=Morning_Noon, y=TotalCrime, main="") 
scatter.smooth(x=Night, y=TotalCrime, main="") 
scatter.smooth(x=Evening, y=TotalCrime, main="") 
scatter.smooth(x=Early.morning, y=TotalCrime, main="") 
scatter.smooth(x=Afternoon, y=TotalCrime, main="") 
dev.off()

# no baltimore riot
no_riot <- baltimore[!(baltimore$TotalCrime == 421),]
# took out the significant outlier
max(no_riot$TotalCrime)
attach(no_riot)
# creating scatter plots to see if they are linear
scatter.smooth(x=Year, y=TotalCrime, main="") 
scatter.smooth(x=Month, y=TotalCrime, main="") 
scatter.smooth(x=Day, y=TotalCrime, main="") 
scatter.smooth(x=Temperature, y=TotalCrime, main="") 
scatter.smooth(x=Precipitation, y=TotalCrime, main="") 
warnings()
scatter.smooth(x=Snow, y=TotalCrime, main="") # not linear
scatter.smooth(x=SnowDepth, y=TotalCrime, main="") # not linear
scatter.smooth(x=Unemployment, y=TotalCrime, main="") 
scatter.smooth(x=Morning_Noon, y=TotalCrime, main="") 
scatter.smooth(x=Night, y=TotalCrime, main="") 
scatter.smooth(x=Evening, y=TotalCrime, main="") 
scatter.smooth(x=Early.morning, y=TotalCrime, main="") 
scatter.smooth(x=Afternoon, y=TotalCrime, main="") 

# create liner model
lin_model <- lm(TotalCrime ~ Year+Month+Day+Temperature+Precipitation+Unemployment)
print(lin_model)
summary(lin_model)
