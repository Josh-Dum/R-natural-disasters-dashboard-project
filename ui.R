# ui.R
library(shinydashboard)

# Dashboard UI
ui <- dashboardPage(
  dashboardHeader(title = "Mon Dashboard"),
  
  # Sidebar avec des éléments de navigation
  dashboardSidebar(
    width = 200, # La largeur peut être fixe
    sidebarMenu(
      menuItem("Histogrammes", tabName = "histograms", icon = icon("chart-bar")), # correction d'icône
      menuItem("Carte des catastrophes", tabName = "map", icon = icon("globe"))
    )
  ),
  
  # Corps principal du tableau de bord
  dashboardBody(
    tabItems(
      # Premier onglet : Histogrammes
      tabItem(tabName = "histograms",
              fluidRow(
                box(sliderInput("year_slider", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, value = c(1900, 2021),
                                step = 1, round = TRUE, sep = "", width = "100%")),
                box(plotOutput("graph1"), width = 6),
                box(plotOutput("graph2"), width = 6),
                box(plotOutput("graph3"), width = 6),
                box(plotlyOutput("graph4"), width = 6)
              )
      ),
      
      # Deuxième onglet : Carte
      tabItem(tabName = "map",
              fluidRow(
                box(sliderInput("range", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, # Ces valeurs devront être dynamiques, ajustées selon vos données
                                value = c(2020, 2021), 
                                step = 1, round = TRUE, sep = "", width = "100%")),
                box(leafletOutput("map"), width = 12)
              )
      )
    )
  )
)
