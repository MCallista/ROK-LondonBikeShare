install.packages("prophet")
library(prophet)
library(lubridate)

londonBike <- read.csv("C:\\Users\\TOSHIBA\\Downloads\\UPH\\SEM 5\\Riset Operasional\\R Data\\london_merged.csv", header = TRUE)

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
