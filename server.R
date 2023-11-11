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
  
  # Créer une carte colorée en fonction du nombre de catastrophes
  output$carte41 <- renderLeaflet({
    
    debut <- input$year_slider_carte[1]
    fin <- input$year_slider_carte[2]
    
    # Filtrer les données
    df_filtered <- disaster_counts %>%
      filter(Year >= debut & Year <= fin)
    
    # Calculs pour les catastrophes et les morts
    country_disaster_counts <- df_filtered %>%
      group_by(ISO) %>%
      summarise(Disaster_Count = sum(`Disaster Count`))
    
    
    
    
    # Fusionner avec les données géographiques
    merged_disaster_data <- merge(country_geojson_sf, country_disaster_counts, by.x = "ISO_A3", by.y = "ISO")
    
    
    # Création de la carte avec leaflet
    map_disaster <- leaflet() %>%
      setView(lng = 2.5840685, lat = 48.8398094, zoom = 3) %>%
      addProviderTiles(providers$Esri.WorldTopoMap) %>%
      
      addPolygons(data = merged_disaster_data,
                  fillColor = ~colorNumeric("YlOrRd", Disaster_Count)(Disaster_Count),
                  weight = 1,
                  color = "black",
                  fillOpacity = 0.7,
                  label = ~paste0(ISO_A3, ": ", Disaster_Count),
                  layerId = ~ISO_A3,
                  group = "Nombre de catastrophes naturelles par pays"
      )%>%
      addLayersControl(overlayGroups = c("Nombre de catastrophes naturelles par pays"))%>%
      
      # Ajouter une légende pour les décès (ajuster en fonction des données)
      addLegend("bottomleft", 
                pal = colorNumeric("OrRd", domain = merged_disaster_data$Disaster_Count),
                values = merged_disaster_data$Disaster_Count,
                title = "Nombre de morts",
                opacity = 0.7)
    
    map_disaster
  })
  
  
  #graphique 1 de navitem 4
  output$graph41 <- renderPlotly({
    # manipuulation donnée pour le graphique 41
    # Filtrer les données en fonction de la sélection d'années
    filtered_data <- df_catastrophe %>%
      filter(Year >= input$year_slider_graph41[1], Year <= input$year_slider_graph41[2])
    
    # Agrégation des données pour obtenir le nombre total de morts et de catastrophes par pays et continent
    aggregated_data <- filtered_data %>%
      group_by(Continent, Country) %>%
      summarise(Total_Deaths = sum(`Total.Deaths`, na.rm = TRUE),
                Num_Disasters = n(), .groups = 'drop') # Compter les catastrophes et sommer les morts
    
    # Calculer le total des décès par continent
    continent_deaths <- aggregated_data %>%
      group_by(Continent) %>%
      summarise(Total_Deaths = sum(Total_Deaths, na.rm = TRUE), .groups = 'drop')
    
    # Ajouter une ligne pour chaque continent avec le monde comme parent
    world <- data.frame(Continent = rep("World", length(continent_deaths$Continent)), 
                        Country = continent_deaths$Continent, 
                        Total_Deaths = continent_deaths$Total_Deaths, 
                        Num_Disasters = NA)
    
    # Ajouter une ligne pour le monde sans parent
    world_total <- data.frame(Continent = NA, Country = "World", Total_Deaths = sum(continent_deaths$Total_Deaths, na.rm = TRUE), Num_Disasters = NA)
    
    # Combiner les dataframes
    hierarchy <- rbind(world_total, world, aggregated_data)
    
    # Remplacer les NA par des chaînes vides pour Plotly et des zéros pour les valeurs numériques
    hierarchy$Continent[is.na(hierarchy$Continent)] <- ""
    hierarchy$Total_Deaths[is.na(hierarchy$Total_Deaths)] <- 1 # Remplacer NA par 1 pour éviter log(0)
    hierarchy$Num_Disasters[is.na(hierarchy$Num_Disasters)] <- 0
    
    # Appliquer une échelle logarithmique pour les décès
    hierarchy$Log_Total_Deaths <- log10(hierarchy$Total_Deaths + 1) # Ajouter 1 pour éviter log(0)
    

    # Créer le treemap avec un titre
    fig <- plot_ly(
      type = "treemap",
      labels = hierarchy$Country,
      parents = hierarchy$Continent,
      values = hierarchy$Num_Disasters, # Utiliser le nombre de catastrophes pour la taille des cases
      textinfo = "label+value",
      marker = list(
        colors = hierarchy$Log_Total_Deaths, # Utiliser le logarithme du nombre total de morts pour la couleur des cases
        colorscale = 'RdBu', # Utiliser une échelle de rouge pour les morts
        cmin = min(hierarchy$Log_Total_Deaths, na.rm = TRUE), # Minimum basé sur le log du nombre minimal de morts
        cmax = max(hierarchy$Log_Total_Deaths, na.rm = TRUE), # Maximum basé sur le log du nombre maximal de morts
        colorbar = list(
          title = "Log Total Deaths",
          tickvals = log10(c(1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 15000000)),
          ticktext = c("1", "10", "100", "1k", "10k", "100k", "1M", "10M", "")
        )
      )
    ) %>%
      layout(title = "Répartition des catastrophes naturelles par pays et continent")
    
    fig # Retourner le graphique pour l'affichage
  })  
  
  
}
