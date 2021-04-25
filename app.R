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
    fluidRow(
      tabBox(
        title = "Tab Penjelasan",
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1", height = "250px",
        tabPanel("part1", "Setelah data dibuat dalam bentuk barplot dan dianalisa, terdapat hal-hal yang membuat peminjaman sepeda meningkat ataupun menurun. Jika dilihat dari peminjaman sepeda pada musim yang berbeda, terdapat perbedaan rata-rata dalam jumlah peminjaman sepeda. Dari barplot bisa diambil bahwa rata-rata paling banyak saat musim 1 (summer) dan kebalikannya, yang paling sedikit saat musim 3 (winter). Selain itu, peminjaman sepeda juga terdampak dari apakah sedang weekend atau tidak, dimana 0 (not weekend) mengalami rata-rata jumlah peminjamaan yang lebih banyak. Barplot juga menjelaskan bahwa rata-rata jumlah peminjaman sepeda pada hari libur lebih banyak dibandingkan saat hari biasa. Dan terakhir adalah peminjaman sepeda menurut cuaca. Yang bisa kami ambil adalah nomor 2 (cattered clouds / few clouds) memiliki rata-rata peminjaman sepeda yang paling banyak dibandingkan yang lan terutama saat cuaca 26 (snowfall)."),
        tabPanel("part2", "Jadi bisa dilihat dari lineplot yang sudah dibuat, rata-rata bike share mengalami kenaikan disaat t1 atau real temperature mengalami kenaikan juga meskipun terdapat kenaikan dan penurunan saat t1 berada 25 sampai 33. Hubungan rata-rata peminjaman sepeda dengan real temperature mengalami puncaknya saat di t1/real temperature berada di 35 dengan jumlah rata-rata peminjaman sepeda lebih dari 4000. Sama juga dengan halnya hubungan rata-rata bike share dengan t2(temperature feels like), dimana rata-rata peminjaman sepeda mengalami kenaikan bersamaan saat t2 mengalami kenaikan juga tetapi terjadi juga kenaikan disaat t2 berada di -5. Selanjutnya di line plot yang ketiga, bisa dilihat bahwa cnt atau rata-rata peminjaman sepeda mengalami penurunan saat humidity mengalami kenaikan. Line plot yang terakhir memiliki hubungan antara cnt dengan wind speed. Tidak seperti line plot sebelumnya, line plot ini mengalami beberapa kenaikan dan penurunan yang drastic. Misalnya disaat windspeed 10, 14, 25, 38, dan 42,memiliki jumlah cnt yang tinggi tetapi saat di 11, 15, 31, 50, dan 52, terjadi penurunan dalam jumlah cnt."),
        tabPanel("part3", "Pada grafik pertama, Bike share according to date, tidak ada banyak korelasi atau hubungan yang dapat dilihat dengan rata-rata jumlah bike share. Hal ini kemungkinan terjadi karena tanggal dalam sebuah bulan tidak terlalu menentukan apakah seseorang akan menggunakan sepeda. Misalnya tanggal 2 bisa jatuh pada hari kerja atau hari libur. Oleh karena itu, akan dilanjutkan dengan perbandingan jumlah bike share dengan hari (Senin, Selasa, dan seterusnya). Pada grafik Bike share according to days, dapat dilihat bahwa terdapat sedikit penurunan rata-rata jumlah bike share pada hari Sabtu dan Minggu. Sesuai dengan bar plot Bike share according to weekend yang telah dijelaskan sebelumnya, memang terdapat penggunaan yang lebih tinggi pada hari kerja. Selanjutnya adalah perbandingan penggunaan bike share dengan bulan. Dalam grafik ini dapat dilihat bahwa terdapat sedikit kenaikan pada bulan 6 (Juni) - 9 (September). Jika kita lihat lebih lanjut, bulan ini adalah musim panas (Summer) dan bisa di lihat kembali pada grafik Bike share according to season bahwa musim dengan penggunaan tertinggi adalah dengan kode 1 (Summer). Perbandingan dilanjutkan dengan variabel tahun. Data bike share yang digunakan terdiri atas 3 tahun (2015-2017) namun sebenarnya data ini secara keseluruhan hanya berjumlah 2 tahun. Hal ini karena data dimulai dari 4 Januari 2015 - 4 Januari 2017. Jika dilihat dari grafik diatas, tidak terdapat perbedaan yang signifikan antara tahun 2015 dan 2016. Sedangkan untuk tahun 2017 memiliki penurunan yang jauh disebabkan oleh datanya yang hanya mengandung 4 hari penggunaan pada tahun tersebut."),
        tabPanel("part4","Terakhir adalah perbandingan penggunaan bike share dengan jam di hari tersebut. Ini menjadi salah satu variabel yang dipertimbangkan karena salah satu asumsi yang dipikirkan adalah bahwa bike share digunakan oleh orang yang bekerja. Dapat dilihat pada grafik diatas, penggunaan bike share paling tinggi berada pada jam 8 pagi dan jam 5-6 sore. Perlu diingat bahwa jam tersebut adalah sekitaran jam berangkat kerja dan jam pulang kerja. Oleh karena itu terdapat peningkatan pengunaan bike share yang cukup signifikan pada periode tersebut. Begitu pula dengan penggunaan bike share yang sangat rendah pada jam 12 malam sampai jam 5 pagi. Hal ini kemungkinan besar terjadi karena jam tersebut adalah jam tidur untuk kebanyakan orang.")),
    tabItems(
      #Plots tab content
      tabItem('plots', 
              #Histogram filter
              box(background = "black", title = "Inputs", status = "warning",
                  "EDA", br(), 
                  selectInput('val', 'Variables:', c('Season', 'Weekend', 'Holiday', 'Weather','T1', 'T2', 'Humidity', 'Wind Speed', 'Date', 'Date of Week', 'Month', 'Year', 'Hour')),
                  
                  footer = ''),
              #Boxes to display the plots
              box(background = "black", status = "primary", solidHeader = TRUE,collapsible = TRUE,
                  plotOutput('barPlot')))))))
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
