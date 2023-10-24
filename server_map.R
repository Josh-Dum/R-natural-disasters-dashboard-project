server <- function(input, output) {
  
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
     }

