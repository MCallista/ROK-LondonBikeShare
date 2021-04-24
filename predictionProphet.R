install.packages("prophet")
library(prophet)
library(lubridate)

londonBike <- read.csv("C:\\Users\\prisc\\OneDrive\\Documents\\SEM 5\\ROK\\london_merged.csv", header = TRUE)

testData <- subset(londonBike, select = c(timestamp, cnt))

str(testData)

names(testData)[names(testData) == "timestamp"] <- "ds"
names(testData)[names(testData) == "cnt"] <- "y"

model1 <- prophet(testData) 

future <- make_future_dataframe(model1, periods = 365)
tail(future)

forecast <- predict(model1, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(model1, forecast)

prophet_plot_components(model1, forecast)

pred <- forecast$yhat[1:17414]
actual <- testData[,2]
plot(actual, pred)

abline(lm(pred~actual), col = 'red')
summary(lm(pred~actual))