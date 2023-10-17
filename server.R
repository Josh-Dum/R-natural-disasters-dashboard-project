# server.R

server <- function(input, output) {
  output$histogram <- renderPlot({
    # Création de l'histogramme
    disaster_data %>%
      ggplot(aes(x = `Total Deaths`)) + 
      geom_histogram(binwidth = 0.1, fill = "blue", color = "black", alpha = 0.7) + 
      scale_x_log10(breaks = c(1, 10, 100, 1000, 10000, 100000, 1000000), 
                    labels = scales::comma) +
      scale_y_log10(labels = scales::comma) +
      theme_minimal() +
      labs(title = "Histogramme des décès totaux dus aux catastrophes naturelles (Échelles logarithmiques)",
           x = "Décès totaux (Échelle logarithmique)",
           y = "Nombre d'événements (Échelle logarithmique)")
  })
}

