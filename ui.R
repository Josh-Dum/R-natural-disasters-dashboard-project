# ui.R

fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css")),
  
  titlePanel("Mon Dashboard"),
  
  tabsetPanel(
    tabPanel("Histogrammes",
             # Éléments de l'interface utilisateur de ui.R
             sliderInput("year_slider", "Sélectionnez une plage d'années:", min = 1900, max = 2021, value = c(1900, 2021),step = 1,round = TRUE,sep = "",width = "100%"),
             plotOutput("graph1"),
             plotOutput("graph2"),
             plotOutput("graph3"),
             plotlyOutput("graph4")
    ),
    tabPanel("Carte des catastrophes",
             # Éléments de l'interface utilisateur de ui_map.R
             fluidRow(
               column(12, 
                      sliderInput("range", "Sélectionnez une plage d'années:", min = min(annees), max = max(annees), value = c(max(annees)-1, max(annees)),step = 1,round = TRUE,sep = "",width = "100%")
               ),
               # ... (autres éléments de l'interface utilisateur pour la carte)
             ),
             leafletOutput("map")
    )
  )
)
