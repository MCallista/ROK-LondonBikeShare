#Info of data

#"timestamp" - timestamp field for grouping the data
#"cnt" - the count of a new bike shares
#"t1" - real temperature in C
#"t2" - temperature in C "feels like"
#"hum" - humidity in percentage
#"windspeed" - wind speed in km/h
#"weathercode" - category of the weather
#"isholiday" - boolean field - 1 holiday / 0 non holiday
#"isweekend" - boolean field - 1 if the day is weekend
#"season" - category field meteorological seasons: 0-spring ; 1-summer; 2-fall; 3-winter.

#"weather_code" category description:
#1 = Clear ; mostly clear but have some values with haze/fog/patches of fog/ fog in vicinity 
#2 = scattered clouds / few clouds 
#3 = Broken clouds 
#4 = Cloudy 
#7 = Rain/ light Rain shower/ Light rain 
#10 = rain with thunderstorm 
#26 = snowfall 
#94 = Freezing Fog

#Find missing data
sum(is.na(londonBike))              #Result is 0

#Data Summary
summary(londonBike)

#Data Structure
str(londonBike)

#Data correlation, look at relationship between each data

pairs(londonBike[2:10])                     #Matrix plot of scatterplot

dataSample <- sample_n(londonBike, 1000)    #Make data samples (decrease size)
pairs(dataSample[2:10])

corCoef <- cor(londonBike[2:10])            #Correlation Coeff w/ Pearson correlation
corrplot(corCoef)                           #Correlation Matrix

#continue..
