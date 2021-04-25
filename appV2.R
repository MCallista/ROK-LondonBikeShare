#Load libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyr)
library(prophet)
library(lubridate)
library(dygraphs)

#Importing datasets
londonBike <- read.csv("C:\\Users\\TOSHIBA\\Downloads\\UPH\\SEM 5\\Riset Operasional\\R Data\\london_merged.csv", header = TRUE)

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

#Prediction data
testData <- subset(londonBike, select = c(timestamp, cnt))

names(testData)[names(testData) == "timestamp"] <- "ds"
names(testData)[names(testData) == "cnt"] <- "y"
testData$temp <- londonBike$t1
testData$hum <- londonBike$hum

model1 <- prophet()
model1 <- add_regressor(model1, 'temp')
model1 <- add_regressor(model1, 'hum')
model1 <- fit.prophet(model1, testData)

#R Shiny ui
ui <- dashboardPage(
  
  #Dashboard title
  dashboardHeader(title = 'BIKE SHARING EXPLORER', titleWidth = 300),
  
  #Sidebar layout
  dashboardSidebar(
    width = 300, sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon('poll')),
      menuItem("Prediction", tabName = "pred", icon = icon('line-chart')),
      menuItem("More Info", tabName = "info", icon = icon('info'))
      )
  ),
  
  #Tabs layout
  dashboardBody(
    tabItems(
      
      tabItem('plots',
        fluidRow(
          tabBox(
        
        title = "Penjelasan Data [EDA]", id = "tabset1", height = "500px",

        tabPanel("Part 1",
                p("Penjelasan untuk variabel Season, Weekend, Holiday, dan Weather"),
                
                strong("Season"),
                p("Season Code: 0 - Spring, 1 - Summer, 2 - Fall, 3 - Winter"),
                p("Dari barplot season bisa diambil bahwa rata-rata peminjaman sepeda paling banyak 
                  saat musim 1 (summer) dan kebalikannya, yang paling sedikit saat musim 3 (winter)."),
                
                strong("Weekend"),
                p("Weekend Code: boolean field - 1 jika hari termasuk weekend"),
                p("Peminjaman sepeda juga terdampak dari apakah sedang weekend atau tidak, dimana 0 
                  (not weekend) mengalami rata-rata jumlah peminjamaan yang lebih banyak."),
                
                strong("Holiday"),
                p("Holiday Code: boolean field - 1 holiday / 0 non holiday"),
                p("Barplot 'Bike share according to holiday' menjelaskan bahwa rata-rata jumlah 
                  peminjaman sepeda pada hari libur lebih banyak dibandingkan saat hari biasa."),
                
                strong("Weather"),
                p("Weather Code: 1 - Clear, 2 - Few clouds, 3 - Broken Clouds, 4 - Cloudy, 7 - Light rain,
                  10 - Rain with thunderstorm, 26 - Snowfall, 94 - Freezing fog"),
                p("Dalam peminjaman sepeda menurut cuaca, nomor 2 (scattered clouds / few clouds) memiliki 
                  rata-rata peminjaman sepeda yang paling banyak dibandingkan yang lain terutama saat cuaca
                  26 (snowfall).")
                ),
                
        tabPanel("Part 2",
                 p("Penjelasan untuk variabel T1, T2, Humidity, dan Wind speed"),
                 p("Note: cnt - count of new bikeshare"),
                 
                 strong("T1"),
                 p("Real temperature in C"),
                 p("Rata-rata bike share mengalami kenaikan disaat t1 atau real temperature mengalami kenaikan
                 juga. Hubungan rata-rata peminjaman sepeda dengan real temperature mengalami puncaknya saat di 
                 t1/real temperature berada di 35 dengan jumlah rata-rata peminjaman sepeda lebih dari 4000."),
                 
                 strong("T2"),
                 p("Temperature in C [feels like]"),
                 p("Sama dengan t1, Nilai rata-rata bike share mengalami kenaikan bersamaan saat t2(temperature 
                 feels like) mengalami kenaikan juga."),
                 
                 strong("Humidity"),
                 p("Humidity in percentage"),
                 p("Pada line plot ini, bisa dilihat bahwa cnt atau rata-rata peminjaman sepeda mengalami 
                   penurunan saat humidity mengalami kenaikan."),
                 
                 strong("Wind speed"),
                 p("Wind speed in km/h"),
                 p("Hubungan antara cnt dengan wind speed pada line plot ini mengalami beberapa kenaikan dan 
                   penurunan yang drastik. Misalnya disaat windspeed 10, 14, 25, 38, dan 42, memiliki jumlah cnt 
                   yang tinggi. Tetapi saat di 11, 15, 31, 50, dan 52, terjadi penurunan dalam jumlah cnt."),
                ),
        
        tabPanel("Part 3",
                 p("Penjelasan untuk variabel Date, Day of Week, Month, Year, dan Hour"),
                 
                 strong("Date"),
                 p("Pada grafik ini tidak ada banyak korelasi karena sedikitnya perbedaan rata-rata jumlah 
                   bike share pada tiap tanggal."),
                 
                 strong("Day of Week"),
                 p("Pada grafik ini, dapat dilihat bahwa terdapat sedikit penurunan rata-rata jumlah bike 
                   share pada hari Sabtu dan Minggu. Hal ini sesuai dengan bar plot untuk variabel weeend 
                   yang memiliki penggunaan lebih tinggi pada hari biasa (hari kerja)"),
                 
                 strong("Month"),
                 p("Penggunaan bike share memiliki kenaikan pada bulan 6 (Juni) - 9 (September). Bulan 
                   tersebut masuk dalam musim panas (Summer) dan sesuai dengan bar plot untuk variabel 
                   season yang memiliki penggunaan paling tinggi pada season dengan kode 1 (Summer)"),
                 
                 strong("Year"),
                 p("Pada variabel tahun, tidak terdapat perbedaan yang signifikan. Perlu diperhatikan 
                   bahwa data pada tahun 2017, penggunaan jauh lebih sedikit karena hanya menghitung 
                   4 hari penggunaan bike share."),
                 
                 strong("Hour"),
                 p("Pada variabel jam, terdapat perbedaan yang terlihat terutama pada jam 8 pagi dan 
                   jam 5-6 sore. Hal ini dikarenakan jam tersebut adalah sekitaran jam berangkat 
                   kerja dan jam pulang kerja. Begitu pula dengan penggunaan yang renda pada jam 
                   12 malam sampai jam 5 pagi, yang kemungkinan besar terjadi karena termasuk jam 
                   tidur untuk kebanyakan orang."),
                )),
      
      #tabItems(
        #Plots tab content
        #tabItem('plots', 
                #Histogram filter
                box(background = "black", title = "Inputs", status = "warning", 
                    selectInput('val', 'Variables:', 
                                c('Season', 'Weekend', 'Holiday', 'Weather','T1', 'T2', 'Humidity', 
                                  'Wind Speed', 'Date', 'Date of Week', 'Month', 'Year', 'Hour')),
                    
                    footer = ''),
                
                #Boxes to display the plots
                box(background = "black", title = "Plots", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput('barPlot'))
      )),
        
        #Prediction tab content
        tabItem(tabName = "pred", 
                #Prediction plot
                h2("Prediction using Prophet Model"),
                br(),
          fluidRow( 
                box(title = "Predict Parameters", status = "info",
                    #paramater: periods
                    numericInput("periods","periods",value=24),
                    p("Note: Period in hours"),
                    actionButton("predButton", "Predict")),
                
                tabBox( id = "tabset2", height = "500px",
                    tabPanel("Forecast Plot", dygraphOutput('forecastPlot')),
                    tabPanel("Prophet component plot", plotOutput('prophetComp'))
                    )
                )),
        
        #Info tab content
        tabItem(tabName = "info", 
                h2("Project Info"),
                br(),
                p("Project based on London Bike Share Dataset"),
                p(tags$a(href="https://www.kaggle.com/hmavrodiev/london-bike-sharing-dataset",
                         "Link to London Bike Share Dataset")),
                p("Model used for prediction: Prophet"),
                p(tags$a(href="https://facebook.github.io/prophet/",
                         "Link to Prophet web page")))
    )))

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
  
  freqValue <- eventReactive(input$predButton, {
    input$periods
  })
  
  createForecast <- eventReactive(input$predButton, {
    
    future <- make_future_dataframe(model1, periods = freqValue(), freq = 3600, include_history = TRUE)
    tail(future)
    x <- data.frame(testData$temp)
    colnames(x) <- 'temp'
    y <- data.frame(runif(freqValue(), -1, 16))
    colnames(y) <- 'temp'
    future$temp <- rbind(x,y)
    
    x <- data.frame(testData$hum)
    colnames(x) <- 'hum'
    y <- data.frame(runif(freqValue(), 50, 100))
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
    
    return(forecast)
  })
  
  output$forecastPlot <- renderDygraph({
    dyplot.prophet(model1, createForecast())
  
  })
  
  output$prophetComp <- renderPlot({
    prophet_plot_components(model1, createForecast())
  })
}

shinyApp(ui, server)
