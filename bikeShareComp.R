library(dplyr)

#season
seasonCnt <- (londonBike %>% group_by(season))%>%summarise(cnt = mean(cnt))
barplot(height = seasonCnt$cnt, names = seasonCnt$season, col=rgb(0.9,0.3,0.2),
        xlab = "season code", ylab = "Average Bike Share", main = "Bike share according to season")

#weekend
weekendCnt <- (londonBike %>% group_by(is_weekend))%>%summarise(cnt = mean(cnt))
barplot(height = weekendCnt$cnt, names=weekendCnt$is_weekend, col=rgb(1,1,0.5),
        xlab = "weekend code" , ylab = "Average Bike Share", main = "Bike share according to weekend")

#holiday
holidayCnt <- (londonBike %>% group_by(is_holiday))%>%summarise(cnt = mean(cnt))
barplot(height = holidayCnt$cnt, names = holidayCnt$is_holiday, col=rgb(0.5,1,0.3),
        xlab = "holiday code", ylab = "Average Bike Share", main = "Bike share according to holiday")

#weather
weatherCnt <- (londonBike %>% group_by(weather_code))%>%summarise(cnt = mean(cnt))
barplot(height=weatherCnt$cnt, names=weatherCnt$weather_code, col=rgb(0,0.6,0.8),
        xlab = "Weather Code", ylab = "Average Bike share", main = "Bike share according to weather")

#t1
t1Cnt <- (londonBike %>% group_by(t1))%>%summarise(cnt = mean(cnt))
plot(t1Cnt$t1, t1Cnt$cnt, type = "l", 
        xlab = "t1(Real Temperature)", ylab = "cnt", main = "Bike share according to t1", col = "blue")

#t2
t2Cnt <- (londonBike %>% group_by(t2))%>%summarise(cnt = mean(cnt))
plot(t2Cnt$t2, t2Cnt$cnt, type = "l", 
     xlab = "t2(Temperature Feels Like)", ylab = "cnt", main = "Bike share according to t2", col = "blue")
