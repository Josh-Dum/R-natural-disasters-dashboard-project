library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(plotly)

df_catastrophe <- read.csv("1900_2021_DISASTERS.xlsx - emdat data.csv",sep=",")
df_geoloc <- read.csv("new_dataframe.csv",sep=",")

df_catastrophe$Latitude <- df_geoloc$Latitude
df_catastrophe$Longitude <- df_geoloc$Longitude

df_catastrophe_location <- df_catastrophe %>% filter(!is.na(Latitude) & !is.na(Longitude))

annees <- unique(df_catastrophe_location$Year)

marqueur_type_de_catastrophe <- list(
  "Drought" = list(color = 'beige', icon = 'tint'),
  "Drouuake" = list(color = 'beige', icon = 'tint'),
  "Volcanic activity" = list(color = 'orange', icon = 'fire'),
  "Mass movement (dry)" = list(color = 'black', icon = 'warning-sign'),
  "Storm" = list(color = 'darkblue', icon = 'cloud'),
  "Earthquake" = list(color = 'purple', icon = 'exclamation-sign'),
  "Earthquakeght" = list(color = 'purple', icon = 'exclamation-sign'),
  "Earthq" = list(color = 'purple', icon = 'exclamation-sign'),
  "Flood" = list(color = 'blue', icon = 'tint'),
  "Epidemic" = list(color = 'pink', icon = 'plus-sign'),
  "Landslide" = list(color = 'darkgreen', icon = 'arrow-down'),
  "Wildfire" = list(color = 'red', icon = 'fire'),
  "Extreme temperature" = list(color = 'darkred', icon = 'warning-sign'),
  "Fog" = list(color = 'lightgray', icon = 'cloud'),
  "Insect infestation" = list(color = 'green', icon = 'leaf'),
  "Impact" = list(color = 'black', icon = 'asterisk'),
  "Animal accident" = list(color = 'green', icon = 'leaf'),
  "Glacial lake outburst" = list(color = 'lightblue', icon = 'tint')
)


