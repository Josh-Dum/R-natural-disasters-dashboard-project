# server.R
function(input, output) {
  output$plot <- renderPlot({
    
    gapminder %>%
      filter(year==2007) %>%
      ggplot(aes(x=gdpPercap, y=lifeExp)) +
      geom_point()
    
  })
}
