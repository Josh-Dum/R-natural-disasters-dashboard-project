# ui.R

fluidPage(
  # Titre
  titlePanel("Histogramme des décès dus aux catastrophes naturelles"),
  
  # RangeSlider pour sélectionner la plage d'années
  sliderInput("year_slider", 
              "Sélectionnez une plage d'années:", 
              min = min(disaster_data$Year),
              max = max(disaster_data$Year),
              value = c(min(disaster_data$Year), max(disaster_data$Year)),
              step = 1,
              round = TRUE,
              sep = "",
              width = "100%"),
  
  # Histogrammes
  plotOutput("graph1"),
  plotOutput("graph2"),
  plotOutput("graph3"),
  plotlyOutput("graph4"),
  
  
  # Description
  div(children = list(
    "Les histogrammes représentent la distribution du nombre total de décès dus aux catastrophes naturelles."
  ))
  
)
