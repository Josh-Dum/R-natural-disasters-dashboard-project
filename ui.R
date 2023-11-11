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
      menuItem("Carte des catastrophes", tabName = "map", icon = icon("globe")),
      menuItem("Evolution des morts", tabName = "navitem3", icon = icon("chart-pie")),
      menuItem("Evolution des catastrophes", tabName = "navitem4", icon = icon("chart-line"))
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
      ),
      
      # troisième onglet : Evolution des morts
      tabItem(tabName = "navitem3",
              div(style = "text-align: center;", h2("Evolution des morts")),
              fluidRow(
                box(plotlyOutput("graph31"), width = 12)
              ),
              fluidRow(
                box(plotlyOutput("graph32"), width = 12)
              )
      ),
      
      # 4e onglet : Evolution des catastrophes
      tabItem(tabName = "navitem4",
              div(style = "text-align: center;", h2("Evolution des catastrophes")),
              fluidRow(
                box(title = "Filtres", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                    sliderInput("year_slider_carte", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, value = c(1900, 2021),
                                step = 1, round = TRUE, sep = "", width = "100%")
                )
              ),
              fluidRow(
                box(leafletOutput("carte41", height = 800), width = 12)
              ),
              fluidRow(
                box(plotlyOutput("carte42"), width = 12)
              ),
              # Ajout d'une rangée fluide avec un slider pour filtrer les années
              fluidRow(
                box(title = "Filtres", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                    sliderInput("year_slider_graph41", "Sélectionnez une plage d'années :", 
                                min = 1900, max = 2021, value = c(1900, 2021),
                                step = 1, round = TRUE, sep = "", width = "100%")
                )
              ),
              fluidRow(
                box(plotlyOutput("graph41"), width = 12)
              )
      )
      
      
    )
  )
)
