#Find missing data
sum(is.na(londonBike))              #Result is 0

#Data Summary
summary(londonBike)

#Data Structure
str(londonBike)

#Data correlation, look at relationship between each data

pairs(londonBike[2:10])             #Matrix plot of scatterplot (lama)

corCoef <- cor(londonBike[2:10])    #Correlation Coeff w/ Pearson correlation
corrplot(corCoef)                   #Alternative - Correlation Matrix

#continue..
