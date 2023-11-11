# server.R

server <- function(input, output) {
  
  # Traitement des données pour la température globale
  global_temp_data <- global_temp_data %>%
    mutate(Year = as.numeric(Year),
           Annual_Anomaly = as.numeric(Annual_Anomaly)) %>% 
    filter(!is.na(Year), !is.na(Annual_Anomaly), Year >= 1900, Year <= 2021)
  
  global_temp_data$Smoothed_Anomaly <- rollapply(global_temp_data$Annual_Anomaly, 50, mean, fill = NA, align = "center")
  
  # Traitement des données pour les catastrophes naturelles
  df_catastrophe$Year <- as.numeric(df_catastrophe$Year)
  disaster_count_per_year <- df_catastrophe %>%
    filter(!is.na(Year)) %>%
    group_by(Year) %>%
    summarize(Count = n())
  
  disaster_count_by_type <- df_catastrophe %>%
    filter(!is.na(Year)) %>%
    count(Year, `Disaster.Type`) %>%
    pivot_wider(names_from = `Disaster.Type`, values_from = n, values_fill = list(n = 0))
  
  
  # Graphique 1
  output$graph1 <- renderPlot({
    filtered_data <- disaster_data %>%
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2])
    
    ggplot(filtered_data, aes(x = `Total Deaths`)) + 
      geom_histogram(fill = "blue", color = "black", alpha = 0.7) + 
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5)) +  # Centrer le titre
      labs(title = "Histogramme global du nombre total de décès dus aux catastrophes naturelles",
           x = "Décès totaux",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
  
  # Graphique 2
  output$graph2 <- renderPlot({
    filtered_data <- disaster_data %>% 
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2], 
             `Total Deaths` >= 0, `Total Deaths` <= 10000)
    
    ggplot(filtered_data, aes(x = `Total Deaths`)) + 
      geom_histogram(fill = "blue", color = "black", alpha = 0.7) + 
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5)) +  # Centrer le titre
      labs(title = "Histogramme des décès (0 à 10,000) dus aux catastrophes naturelles",
           x = "Décès totaux",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
  
  # Graphique 3
  output$graph3 <- renderPlot({
    filtered_data <- disaster_data %>% 
      filter(Year >= input$year_slider[1], Year <= input$year_slider[2], 
             `Total Deaths` >= 0, `Total Deaths` <= 10000)
    
    ggplot(filtered_data, aes(x = `Total Deaths`, fill = `Disaster Subgroup`)) + 
      geom_histogram(bins = 30, color="black", alpha=0.7) +
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5)) +  # Centrer le titre
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
        title = "Histogramme 2D des Décès et Dommages", # Ajout du titre ici
        xaxis = list(title = "Total Deaths", range = c(0, 500)),
        yaxis = list(title = "Total Damages ('000 US$)", range = c(0, 1000000), type = "linear")
      )
    
    p4
  })
  
  
  output$map <- renderLeaflet({
    
    df_selected <-df_catastrophe_location %>%
      filter(Year >= input$range[1] & Year <= input$range[2])
    
    
    map <- leaflet(df_selected) %>%
      addProviderTiles(providers$Esri.WorldTopoMap) %>%
      setView(lng = 2.5840685, lat = 48.8398094, zoom = 3)
    # Ajout des marqueurs personnalisés
    
    for (i in 1:nrow(df_selected)) {
      catastrophe_type <- df_selected$Disaster.Type[i]
      
      marker_color <- marqueur_type_de_catastrophe[[catastrophe_type]]$color
      marker_icon <- marqueur_type_de_catastrophe[[catastrophe_type]]$icon
      
      map <- addAwesomeMarkers(
        map, 
        lng=df_selected$Longitude[i], 
        lat=df_selected$Latitude[i], 
        popup=df_selected$Location[i],
        icon=awesomeIcons(
          icon=marker_icon,
          markerColor=marker_color
        ),
        group = catastrophe_type
      )
      
    }
    
    
    
    map <- addLayersControl(
      map,
      overlayGroups = names(marqueur_type_de_catastrophe),
      options = layersControlOptions(collapsed = FALSE)
    )
    
    
    
    icons_for_legend <- sapply(marqueur_type_de_catastrophe, function(x) {gsub("-sign", "", x$icon)})
    colors_for_legend <- sapply(marqueur_type_de_catastrophe, function(x) x$color)
    
    generateLegendHTML <- function(icons, colors, labels) {
      html_legend <- '<div style="background-color: rgba(255,255,255,0.8); padding: 10px; border-radius: 5px;">'
      html_legend <- paste0(html_legend, "<h5>Types de Catastrophes</h5>")
      for (i in 1:length(icons)) {
        html_legend <- paste0(html_legend, sprintf('<i class="fa fa-%s" style="color: %s;"></i> %s<br/>', icons[i], colors[i], labels[i]))
      }
      html_legend <- paste0(html_legend, "</div>")
      return(html_legend)
    }
    html_legend <- generateLegendHTML(icons_for_legend, colors_for_legend, names(marqueur_type_de_catastrophe))
    map <- addControl(map, html=html_legend, position="bottomleft")
    
    
    map})
  
  #graphique 1 de navitem 3
  output$graph31 <- renderPlotly({
    fig1 <- plot_ly() %>%
      add_lines(x = ~Year, y = ~Count, data = disaster_count_per_year, name = 'Nombre de catastrophes', yaxis = "y") %>%
      add_lines(x = ~Year, y = ~Smoothed_Anomaly, data = global_temp_data, name = 'Écart de température', yaxis = "y2") %>%
      layout(title = "Nombre de catastrophes naturelles et écart de température par an",
             yaxis2 = list(overlaying = "y", side = "right"),
             xaxis = list(title = "Année"),
             yaxis = list(title = "Nombre de catastrophes"),
             yaxis2 = list(title = "Écart de température"))
    fig1
  })  
  
  #graphique 2 de navitem 3
  output$graph32 <- renderPlotly({
    fig2 <- plot_ly()
    for(disaster_type in colnames(disaster_count_by_type[-1])) {
      fig2 <- fig2 %>%
        add_lines(x = ~Year, y = disaster_count_by_type[[disaster_type]], data = disaster_count_by_type, name = disaster_type)
    }
    fig2 <- fig2 %>%
      layout(title = "Nombre de catastrophes naturelles par type par an",
             xaxis = list(title = "Année"),
             yaxis = list(title = "Nombre de catastrophes"))
    fig2    
  })  
  
  
  
}
