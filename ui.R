# ui.R
library(shinydashboard)

# Dashboard UI
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  
  # Sidebar avec des éléments de navigation
  dashboardSidebar(
    width = 200, # La largeur peut être fixe
    sidebarMenu(
      menuItem("Histogrammes", tabName = "histograms", icon = icon("chart-bar")),
      menuItem("Carte des catastrophes", tabName = "map", icon = icon("globe"))
    )
  ),
  
  # Corps principal du tableau de bord
  dashboardBody(
    tabItems(
      # Premier onglet : Histogrammes
      tabItem(tabName = "histograms",
              div(style = "text-align: center;", h2("Histogrammes des catastrophes")),
              fluidRow(
                box(title = "Filtres", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("year_slider", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, value = c(1900, 2021),
                                step = 1, round = TRUE, sep = "", width = "100%")
                )
              ),
              fluidRow(
                box(plotOutput("graph1"), width = 6),
                box(plotOutput("graph2"), width = 6)
              ),
              fluidRow(
                box(plotOutput("graph3"), width = 6),
                box(plotlyOutput("graph4"), width = 6)
              )
      ),
      
      # Deuxième onglet : Carte
      tabItem(tabName = "map",
              div(style = "text-align: center;", h2("Carte des catastrophes")),
              fluidRow(
                box(title = "Filtres", status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("range", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, # Ces valeurs devront être dynamiques, ajustées selon vos données
                                value = c(2020, 2021), 
                                step = 1, round = TRUE, sep = "", width = "100%")
                )
              ),
              fluidRow(
                box(leafletOutput("map", height = 800), width = 12)
              )
      )
    )
  )
)
