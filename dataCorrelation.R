#Data correlation

pairs(londonBike[2:10])             #Matrix plot of scatterplot (lama)

#Alternative - Correlation Matrix

corCoef <- cor(londonBike[2:10])    #Correlation Coeff w/ Pearson correlation
corrplot(corCoef)
