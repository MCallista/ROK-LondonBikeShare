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
              box(status = 'primary', title = 'eda-barplot', 
                  selectInput('val', 'Variables:', c('Season', 'Weekend', 'Holiday', 'Weather')),
                  
                  footer = ''),
              box(status = 'primary', title = 'eda-plot', 
                  selectInput('val2', 'Variables:', c('T1', 'T2', 'Humidity', 'Wind Speed')),
                  
                  footer = ''),
              #Boxes to display the plots
              box(plotOutput('barPlot'),
              box(plotOutput('plot2'))))))
)
# R Shiny server
server <- function(input, output) {
  
  output$barPlot <- renderPlot({
    val = ifelse(input$val == 'Season', 'ssn',
                     ifelse(input$val == 'Weekend', 'wk',
                                   ifelse(input$val == 'Holiday', 'hd',
                                          ifelse(input$val == 'Weather', 'wh',))))
    if(val=='ssn'){
      barplot(height = season$cnt, names = season$season, col=rgb(0.9,0.3,0.2),
              xlab = "season code", ylab = "Average Bike Share", main = "Bike share according to season")
    }
    if(val=='wk'){
      barplot(height = weekend$cnt, names=weekend$is_weekend, col=rgb(1,1,0.5),
              xlab = "weekend code" , ylab = "Average Bike Share", main = "Bike share according to weekend")
    }
    if(val=='hd'){
      barplot(height = holiday$cnt, names = holiday$is_holiday, col=rgb(0.5,1,0.3),
              xlab = "holiday code", ylab = "Average Bike Share", main = "Bike share according to holiday")
    }
    if(val=='wh'){
      barplot(height=weather$cnt, names=weather$weather_code, col=rgb(0,0.6,0.8),
              xlab = "Weather Code", ylab = "Average Bike share", main = "Bike share according to weather")
    }
  })
}

shinyApp(ui, server)
