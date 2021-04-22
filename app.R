#Load libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
#Importing datasets
bike <- read.csv("[location]")
bike$yr <- as.factor(bike$yr)
bike$mnth <- factor(bike$mnth, levels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
bike$weekday <- factor(bike$weekday, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))
bike$season <- factor(bike$season, levels = c('Spring', 'Summer', 'Fall', 'Winter'))
#R Shiny ui
ui <- dashboardPage(
  
  #Dashboard title
  dashboardHeader(title = 'LONDON BIKE SHARE', 
                  titleWidth = 290),
  #Sidebar layout
  dashboardSidebar(width = 290,
                   sidebarMenu(menuItem("Plots", tabName = "plots", icon = icon('poll')),
                               menuItem("Dashboard", tabName = "dash", icon = icon('tachometer-alt')))),
  #Tabs layout
  dashboardBody(tags$head(tags$style(HTML('.main-header .logo {font-weight: bold;}'))),
                tabItems(
                  #Plots tab content
                  tabItem('plots', 
                          #Histogram filter
                          box(status = 'primary', title = 'Filter for the histogram plot', 
                              selectInput('num', "Numerical variables:", c('Temperature', 'Feeling temperature', 'Humidity', 'Wind speed', 'Casual', 'New', 'Total')),
                              footer = 'Histogram plot for numerical variables'),
                          #Frecuency plot filter
                          box(status = 'primary', title = 'Filter for the frequency plot',
                              selectInput('cat', 'Categorical variables:', c('Season', 'Year', 'Month', 'Hour', 'Holiday', 'Weekday', 'Working day', 'Weather')),
                              footer = 'Frequency plot for categorical variables'),
                          #Boxes to display the plots
                          box(plotOutput('histPlot')),
                          box(plotOutput('freqPlot'))),
                  #Dashboard tab content
                  tabItem('dash',
                          #Dashboard filters
                          box(title = 'Filters', status = 'primary', width = 12,
                              splitLayout(cellWidths = c('4%', '42%', '40%'),
                                          div(),
                                          radioButtons( 'year', 'Year:', c('2011 and 2012', '2011', '2012')),
                                          radioButtons( 'regis', 'Registrations:', c('Total', 'New', 'Casual')),
                                          radioButtons( 'weather', 'Weather choice:', c('All', 'Good', 'Fair', 'Bad', 'Very Bad')))),
                          #Boxes to display the plots
                          box(plotOutput('linePlot')),
                          box(plotOutput('barPlot'), 
                              height = 550, 
                              h4('Weather interpretation:'),
                              column(6, 
                                     helpText('- Good: clear, few clouds, partly cloudy.'),
                                     helpText('- Fair: mist, cloudy, broken clouds.')),
                              helpText('- Bad: light snow, light rain, thunderstorm, scattered clouds.'),
                              helpText('- Very Bad: heavy rain, ice pallets, thunderstorm, mist, snow, fog.')))))
)

# R Shiny server
server <- shinyServer(function(input, output) {
  
  #Univariate analysis
  output$histPlot <- renderPlot({
    #Column name variable
    num_val = ifelse(input$num == 'Temperature', 'temp',
                     ifelse(input$num == 'Feeling temperature', 'atemp',
                            ifelse(input$num == 'Humidity', 'hum',
                                   ifelse(input$num == 'Wind speed', 'windspeed',
                                          ifelse(input$num == 'Casual', 'casual',
                                                 ifelse(input$num == 'New', 'new', 'total'))))))
    
    #Histogram plot
    ggplot(data = bike, aes(x = bike[[num_val]]))+ 
      geom_histogram(stat = "bin", fill = 'steelblue3', 
                     color = 'lightgrey')+
      theme(axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 16, face = 'bold'))+
      labs(title = sprintf('Histogram plot of the variable %s', num_val),
           x = sprintf('%s', input$num),y = 'Frequency')+
      stat_bin(geom = 'text', 
               aes(label = ifelse(..count.. == max(..count..), as.character(max(..count..)), '')),
               vjust = -0.6)
  })
  output$freqPlot <- renderPlot({
    #Column name variable
    cat_val = ifelse(input$cat == 'Season', 'season',
                     ifelse(input$cat == 'Year', 'yr',
                            ifelse(input$cat == 'Month', 'mnth',
                                   ifelse(input$cat == 'Hour', 'hr',
                                          ifelse(input$cat == 'Holiday', 'holiday',
                                                 ifelse(input$cat == 'Weekday', 'weekday',
                                                        ifelse(input$cat == 'Working day', 'workingday', 'weathersit')))))))
    
    #Frecuency plot
    ggplot(data = bike, aes(x = bike[[cat_val]]))+
      geom_bar(stat = 'count', fill = 'mediumseagreen', 
               width = 0.5)+
      stat_count(geom = 'text', size = 4,
                 aes(label = ..count..),
                 position = position_stack(vjust = 1.03))+
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 16, face="bold"))+
      labs(title = sprintf('Frecuency plot of the variable %s', cat_val),
           x = sprintf('%s', input$cat), y = 'Count')
    
  })
  output$barPlot <- renderPlot({
    
    if(input$year != '2011 and 2012'){
      
      if(input$weather != 'All'){
        
        #Creating a table filter by year and weathersit for the bar plot
        weather <- bike %>% group_by(season, weathersit) %>% filter(yr == input$year) %>%  summarise(new = sum(new), casual = sum(casual), total = sum(total))
        
        weather <- weather %>% filter(weathersit == input$weather)
      } else{
        
        #Creating a table filter by year for the bar plot
        weather <- bike %>% group_by(season, weathersit) %>% filter(yr == input$year) %>%  summarise(new = sum(new), casual = sum(casual), total = sum(total))
        
      }
      
    } else{
      
      if(input$weather != 'All'){
        
        #Creating a table filter by weathersit for the bar plot
        weather <- bike %>% group_by(season, weathersit) %>% filter(weathersit == input$weather) %>%  summarise(new = sum(new), casual = sum(casual), total = sum(total))
        
      } else{
        
        #Creating a table for the bar plot
        weather <- bike %>% group_by(season, weathersit) %>%  summarise(new = sum(new), casual = sum(casual), total = sum(total))
        
      }
    }
    
    #Column name variable
    regis_val = ifelse(input$regis == 'Total', 'total', 
                       ifelse(input$regis == 'New', 'new','casual'))
    
    #Bar plot
    ggplot(weather, aes(x = season, y = weather[[regis_val]], 
                        fill = weathersit))+
      geom_bar(stat = 'identity', position=position_dodge())+
      geom_text(aes(label = weather[[regis_val]]),
                vjust = -0.3, position = position_dodge(0.9), 
                size = 4)+
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 16, face = 'bold'),
            plot.subtitle = element_text(size = 14),
            legend.text = element_text(size = 12))+
      labs(title = sprintf('%s bike sharing registrations by season and weather', input$regis),
           subtitle = sprintf('Throughout the year %s', input$year),
           x = 'Season', 
           y = sprintf("Count of %s registrations", regis_val))+
      scale_fill_manual(values = c('Bad' = 'salmon2', 'Fair' = 'steelblue3', 'Good' = 'mediumseagreen', 'Very Bad' = 'tomato4'), name = 'Weather')
    
  })
})
shinyApp(ui, server)
#belom gua apa apain sm bikeShareComp.R
