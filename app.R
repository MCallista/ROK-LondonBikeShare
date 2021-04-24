#Load libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyr)
#Importing datasets
londonBike <- read.csv("C:/Users/zuqil/Desktop/ROK-LondonBikeShare-main/london_merged.csv", header = TRUE)
season <- (londonBike %>% group_by(season))%>%summarise(cnt = mean(cnt))
weekend <- (londonBike %>% group_by(is_weekend))%>%summarise(cnt = mean(cnt))
holiday <- (londonBike %>% group_by(is_holiday))%>%summarise(cnt = mean(cnt))
weather <- (londonBike %>% group_by(weather_code))%>%summarise(cnt = mean(cnt))
t1 <- (londonBike %>% group_by(t1))%>%summarise(cnt = mean(cnt))
t2 <- (londonBike %>% group_by(t2))%>%summarise(cnt = mean(cnt))
hum <- (londonBike %>% group_by(hum))%>%summarise(cnt = mean(cnt))
wind <- (londonBike %>% group_by(wind_speed))%>%summarise(cnt = mean(cnt))
londonBike2 <- separate(londonBike, timestamp, c("date", "time"), sep = " ", drop(FALSE))
londonBike2 <- separate(londonBike2, date, c("year", "month", "date"), sep = "-")
londonBike2 <- separate(londonBike2, time, c("hour"), sep = ":")
date = substr(londonBike2$timestamp,1,10)
days <- weekdays(as.Date(date))
londonBike2$timestamp = days

#R Shiny ui
ui <- dashboardPage(
  
  #Dashboard title
  dashboardHeader(title = 'BIKE SHARING EXPLORER', 
                  titleWidth = 290),
  #Sidebar layout
  dashboardSidebar(width = 290,
                   sidebarMenu(menuItem("Plots", tabName = "plots", icon = icon('poll')))),
  #Tabs layout
  dashboardBody(
    tabItems(
      #Plots tab content
      tabItem('plots', 
              #Histogram filter
              box(status = 'primary', title = 'eda', 
                  selectInput('val', 'Variables:', c('Season', 'Weekend', 'Holiday', 'Weather','T1', 'T2', 'Humidity', 'Wind Speed', 'Date', 'Date of Week', 'Month', 'Year', 'Hour')),
                  
                  footer = ''),
              #Boxes to display the plots
              box(plotOutput('barPlot'))))))
# R Shiny server
server <- function(input, output) {
  
  output$barPlot <- renderPlot({
    val = ifelse(input$val == 'Season', 'ssn',
                     ifelse(input$val == 'Weekend', 'wk',
                                   ifelse(input$val == 'Holiday', 'hd',
                                          ifelse(input$val == 'Weather', 'wh',
                                                 ifelse(input$val == 'T1', 't1',
                                                    ifelse(input$val == 'T2', 't2',
                                                         ifelse(input$val == 'Humidity', 'hm',
                                                                ifelse(input$val == 'Wind Speed', 'ws',
                                                                      ifelse(input$val == 'Date', 'dt',
                                                                            ifelse(input$val == 'Date of Week', 'dw',
                                                                                  ifelse(input$val == 'Month', 'mn',
                                                                                        ifelse(input$val == 'Year', 'yr',
                                                                                              ifelse(input$val == 'Hour', 'hr')))))))))))))
    if(val=='ssn'){
      barplot(height = season$cnt, names = season$season, col=rgb(0.9,0.3,0.2),
              xlab = "season code", ylab = "Average Bike Share", main = "Bike share according to season")
    }
    if(val == 'wk'){
      barplot(height = weekend$cnt, names=weekend$is_weekend, col=rgb(1,1,0.5),
              xlab = "weekend code" , ylab = "Average Bike Share", main = "Bike share according to weekend")
    }
    if(val == 'hd'){
      barplot(height = holiday$cnt, names = holiday$is_holiday, col=rgb(0.5,1,0.3),
              xlab = "holiday code", ylab = "Average Bike Share", main = "Bike share according to holiday")
    }
    if(val == 'wh'){
      barplot(height=weather$cnt, names=weather$weather_code, col=rgb(0,0.6,0.8),
              xlab = "Weather Code", ylab = "Average Bike share", main = "Bike share according to weather")
    }
    if(val == 't1'){
      plot(t1$t1, t1$cnt, type = "l", 
           xlab = "t1(Real Temperature)", ylab = "cnt", main = "Bike share according to t1", col = "blue")
    }
    if(val == 't2'){
      plot(t2$t2, t2$cnt, type = "l", 
           xlab = "t2(Temperature Feels Like)", ylab = "cnt", main = "Bike share according to t2", col = "blue")
    }
    if(val == 'hm'){
      plot(hum$hum, hum$cnt, type = "l", 
           xlab = "humidity", ylab = "cnt", main = "Bike share according to humidity", col = "blue")
    }
    if(val == 'ws'){
      plot(wind$wind_speed, wind$cnt, type = "l", 
           xlab = "wind speed", ylab = "cnt", main = "Bike share according to wind speed", col = "blue")
    }
    if(val == 'dt'){
      boxplot(cnt~date,data=londonBike2, main="Bike Share to Date", 
              xlab="Date", ylab="Bike Share count", col=rainbow(31, alpha=0.2))
    }
    if(val == 'dw'){
      boxplot(cnt~days,data=londonBike2, main="Bike Share to Days",
              xlab="Day", ylab="Bike Share count", col=rainbow(7, alpha=0.2))
    }
    if(val == 'mn'){
      boxplot(cnt~month,data=londonBike2, main="Bike Share to Month", 
              xlab="Month", ylab="Bike Share count", col=rainbow(12, alpha=0.2))
    }
    if(val == 'yr'){
      boxplot(cnt~year,data=londonBike2, main="Bike Share to Year", 
              xlab="Year", ylab="Bike Share count", col=rainbow(3, alpha=0.2))
    }
    if(val == 'hr'){
      boxplot(cnt~hour,data=londonBike2, main="Bike Share to Hour", 
              xlab="Hour", ylab="Bike Share count", col=rainbow(24, alpha=0.2))
    }
  })
}

shinyApp(ui, server)
