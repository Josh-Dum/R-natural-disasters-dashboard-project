# ui.R
fluidPage(
  # Application title
  titlePanel("Life Expectancy vs GDP per Capita"),
  
  # Main panel
  mainPanel(plotOutput(outputId = "plot"))
)
