library(dplyr)
library(tidyr)

londonBike <- read.csv("[Change with file location]", header = TRUE)

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

#humidity
humCnt <- (londonBike %>% group_by(hum))%>%summarise(cnt = mean(cnt))
plot(humCnt$hum, humCnt$cnt, type = "l", 
     xlab = "humidity", ylab = "cnt", main = "Bike share according to humidity", col = "blue")

#wind speed
windCnt <- (londonBike %>% group_by(wind_speed))%>%summarise(cnt = mean(cnt))
plot(windCnt$wind_speed, windCnt$cnt, type = "l", 
     xlab = "wind speed", ylab = "cnt", main = "Bike share according to wind speed", col = "blue")

#Separate date and time
londonBike2 <- separate(londonBike, timestamp, c("date", "time"), sep = " ", drop(FALSE))
londonBike2 <- separate(londonBike2, date, c("year", "month", "date"), sep = "-")
londonBike2 <- separate(londonBike2, time, c("hour"), sep = ":")

#Add day of week
date1=substr(londonBike2$timestamp,1,10)
days <- weekdays(as.Date(date1))
londonBike2$days = days

#BAR PLOT AJA YANG DIPAKE

#date
boxplot(cnt~date,data=londonBike2, main="Bike Share to Date", 
        xlab="Date", ylab="Bike Share count", col=rainbow(31, alpha=0.2))

dateCnt <- (londonBike2 %>% group_by(date))%>%summarise(cnt = mean(cnt))
barplot(height=dateCnt$cnt, names=dateCnt$days, col=rainbow(31, alpha=0.2), 
        xlab="Date", ylab="Average Bike share", main="Bike share according to date")

#day of week
boxplot(cnt~days,data=londonBike2, main="Bike Share to Days",
        xlab="Day", ylab="Bike Share count", col=rainbow(7, alpha=0.2))

daysCnt <- (londonBike2 %>% group_by(days))%>%summarise(cnt = mean(cnt))
barplot(height=daysCnt$cnt, names=daysCnt$days, col=rainbow(7, alpha=0.2), 
        xlab="Days", ylab="Average Bike share", main="Bike share according to days")

#month
boxplot(cnt~month,data=londonBike2, main="Bike Share to Month", 
        xlab="Month", ylab="Bike Share count", col=rainbow(12, alpha=0.2))

monthCnt <- (londonBike2 %>% group_by(month))%>%summarise(cnt = mean(cnt))
barplot(height=monthCnt$cnt, names=monthCnt$month, col=rainbow(12, alpha=0.2), 
        xlab="Month", ylab="Average Bike share", main="Bike share according to month")

#year
boxplot(cnt~year,data=londonBike2, main="Bike Share to Year", 
        xlab="Year", ylab="Bike Share count", col=rainbow(3, alpha=0.2))

yearCnt <- (londonBike2 %>% group_by(year))%>%summarise(cnt = mean(cnt))
barplot(height=yearCnt$cnt, names=yearCnt$year, col=rainbow(3, alpha=0.2), 
        xlab="Year", ylab="Average Bike share", main="Bike share according to year")

#hour
boxplot(cnt~hour,data=londonBike2, main="Bike Share to Hour", 
        xlab="Hour", ylab="Bike Share count", col=rainbow(24, alpha=0.2))

hourCnt <- (londonBike2 %>% group_by(hour))%>%summarise(cnt = mean(cnt))
barplot(height=hourCnt$cnt, names=hourCnt$days, col=rainbow(24, alpha=0.2), 
        xlab="Hour", ylab="Average Bike share", main="Bike share according to hour")
