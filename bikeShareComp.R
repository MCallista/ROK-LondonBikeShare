library(dplyr)
#season
barplot(height = temp2$cnt, names = temp2$season, xlab = "season code", ylab = "Average Bike Share", main = "Bike share according to season")
#weekend
barplot(height = temp3$cnt, names=temp3$is_weekend, xlab = "weekend code" , ylab = "Average Bike Share", main = "Bike share according to weekend")
#holiday
barplot(height = temp4$cnt, names = temp4$is_holiday, xlab = "holiday code", ylab = "Average Bike Share", main = "Bike share according to holiday")
