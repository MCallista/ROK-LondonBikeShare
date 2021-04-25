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
date1=substr(londonBike2$timestamp,1,10)
days <- weekdays(as.Date(date1))
londonBike2$days = days
date <- (londonBike2 %>% group_by(date))%>%summarise(cnt = mean(cnt))
days <- (londonBike2 %>% group_by(days))%>%summarise(cnt = mean(cnt))
month <- (londonBike2 %>% group_by(month))%>%summarise(cnt = mean(cnt))
year <- (londonBike2 %>% group_by(year))%>%summarise(cnt = mean(cnt))
hour <- (londonBike2 %>% group_by(hour))%>%summarise(cnt = mean(cnt))
#R Shiny ui
ui <- dashboardPage(
  
  #Dashboard title
  dashboardHeader(title = 'BIKE SHARING EXPLORER', 
                  titleWidth = 500),
  #Sidebar layout
  dashboardSidebar(width = 500,
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
      barplot(height=date$cnt, names=date$days, col=rainbow(31, alpha=0.2), 
              xlab="Date", ylab="Average Bike share", main="Bike share according to date")
    }
    if(val == 'dw'){
      barplot(height=days$cnt, names=days$days, col=rainbow(7, alpha=0.2), 
              xlab="Days", ylab="Average Bike share", main="Bike share according to days")
    }
    if(val == 'mn'){
      barplot(height=month$cnt, names=month$month, col=rainbow(12, alpha=0.2), 
              xlab="Month", ylab="Average Bike share", main="Bike share according to month")
    }
    if(val == 'yr'){
      barplot(height=year$cnt, names=year$year, col=rainbow(3, alpha=0.2), 
              xlab="Year", ylab="Average Bike share", main="Bike share according to year")
    }
    if(val == 'hr'){
      barplot(height=hour$cnt, names=hour$days, col=rainbow(24, alpha=0.2), 
              xlab="Hour", ylab="Average Bike share", main="Bike share according to hour")
    }
  })
}

shinyApp(ui, server)
