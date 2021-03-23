library(dplyr)

#weather
wthrCnt <- londonBike %>% group_by(weather_code)
temp <- wthrCnt %>% summarise(cnt = mean(cnt))
barplot(height=temp$cnt, names=temp$weather_code, col=rgb(0.2,0.4,0.6,0.6), xlab="Weather Code", ylab="Average Bike share", main="Bike share according to weather")

#season
barplot(height = temp2$cnt, names = temp2$season, xlab = "season code", ylab = "Average Bike Share", main = "Bike share according to season")

#weekend
barplot(height = temp3$cnt, names=temp3$is_weekend, xlab = "weekend code" , ylab = "Average Bike Share", main = "Bike share according to weekend")

#holiday
barplot(height = temp4$cnt, names = temp4$is_holiday, xlab = "holiday code", ylab = "Average Bike Share", main = "Bike share according to holiday")
