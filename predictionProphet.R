install.packages("prophet")
library(prophet)
library(lubridate)

londonBike <- read.csv("C:\\Users\\prisc\\OneDrive\\Documents\\SEM 5\\ROK\\london_merged.csv", header = TRUE)

testData <- subset(londonBike, select = c(timestamp, cnt))

str(testData)

names(testData)[names(testData) == "timestamp"] <- "ds"
names(testData)[names(testData) == "cnt"] <- "y"
testData$temp <- londonBike$t1
testData$hum <- londonBike$hum

model1 <- prophet()
model1 <- add_regressor(model1, 'temp')
model1 <- add_regressor(model1, 'hum')
model1 <- fit.prophet(model1, testData) 

future <- make_future_dataframe(model1, periods = 365)
future <- make_future_dataframe(model1, periods= 2160, freq = 3600, include_history = TRUE)
tail(future)
x <- data.frame(testData$temp)
colnames(x) <- 'temp'
y <- data.frame(runif(2160, -1, 16))
colnames(y) <- 'temp'
future$temp <- rbind(x,y)

x <- data.frame(testData$hum)
colnames(x) <- 'hum'
y <- data.frame(runif(2160, 50, 100))
colnames(y) <- 'hum'
future$hum <- rbind(x,y)

future <- as.matrix(future)
colnames(future) <- NULL
colnames(future) <- c('ds', 'temp', 'hum')
future <- data.frame(future)
future$temp <- as.numeric(future$temp)
future$hum <- as.numeric(future$hum)
future$ds <- ymd_hms(future$ds)

forecast <- predict(model1, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(model1, forecast)

prophet_plot_components(model1, forecast)


pred <- forecast$yhat[1:17414]
actual <- testData[,2]
plot(actual, pred)

abline(lm(pred~actual), col = 'red')
summary(lm(pred~actual))