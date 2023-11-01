# server.R

server <- function(input, output) {
  output$graph1 <- renderPlot({
    filtered_data <- disaster_data %>%
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2])
    
    ggplot(filtered_data, aes(x = `Total Deaths`)) + 
      geom_histogram(fill = "blue", color = "black", alpha = 0.7) + 
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      labs(title = "Histogramme global du nombre total de décès dus aux catastrophes naturelles",
           x = "Décès totaux",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
  
  output$graph2 <- renderPlot({
    filtered_data <- disaster_data %>% 
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2], 
             `Total Deaths` >= 0, `Total Deaths` <= 10000)
    
    ggplot(filtered_data, aes(x = `Total Deaths`)) + 
      geom_histogram(fill = "blue", color = "black", alpha = 0.7) + 
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      labs(title = "Histogramme des décès (0 à 10,000) dus aux catastrophes naturelles",
           x = "Décès totaux",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
  
  output$graph3 <- renderPlot({
    filtered_data <- disaster_data %>% 
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2], 
             `Total Deaths` >= 0, `Total Deaths` <= 10000)
    
    ggplot(filtered_data, aes(x = `Total Deaths`, fill = `Disaster Subgroup`)) + 
      geom_histogram(bins = 30, color="black", alpha=0.7) +
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
      labs(title = "Histogramme des décès (0 à 10,000) dus aux catastrophes naturelles",
           x = "Décès totaux",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
  
  
  
  
  
  output$graph4 <- renderPlotly({
    filtered_data <- disaster_data %>%
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2], 
             `Total Deaths` <= 500, `Total Damages ('000 US$)` <= 1000000)
    
    p4 <- plot_ly(data = filtered_data) %>%
      add_histogram2d(x = ~`Total Deaths`, y = ~`Total Damages ('000 US$)`, nbinsx = 6, nbinsy = 6) %>%
      add_markers(x = ~`Total Deaths`, y = ~`Total Damages ('000 US$)`) %>%
      layout(
        xaxis = list(title = "Total Deaths", range = c(0, 500)),
        yaxis = list(title = "Total Damages ('000 US$)", range = c(0, 1000000), type = "linear")
      )
    
    p4
  })
  
  
  
  
  
  
  
  
}
