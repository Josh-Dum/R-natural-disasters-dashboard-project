# Définir l'interface utilisateur
ui <- fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css")),
  titlePanel("Carte des catastrophes"),
  
  fluidRow(
    column(12, 
           sliderInput("range", 
                       "Sélectionnez une plage d'années:", 
                       min = min(annees), 
                       max = max(annees), 
                       value = c(max(annees)-1, max(annees)),
                       step = 1, 
                       sep = "",
                      width = "100%")
    )
  ),
  
  # Carte
  fluidRow(
    column(12,
           leafletOutput("map", width = "100%", height = "calc(100vh - 120px)")  # Soustrait pour la hauteur du titre et du sélecteur.
    )
  )
)