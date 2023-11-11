# global.R

# Chargement des bibliothèques
library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(plotly)
library(tidyverse)
library(ggplot2)
library(gapminder)
library(zoo) # pour rollapply
library(tidyr) # pour pivot_wider

# Chargement et préparation des données du premier fichier
df_catastrophe <- read.csv("natural_disaster.csv",sep=",")
df_geoloc <- read.csv("new_dataframe.csv",sep=",")
global_temp_data <- read.csv("Global Temperature.csv", sep = ",")

# Renommer les colonnes pour éviter les problèmes d'espaces
names(global_temp_data) <- c("Year", "Month", "Monthly_Anomaly", "Monthly_Unc", 
                             "Annual_Anomaly", "Annual_Unc", "Five_Year_Anomaly", 
                             "Five_Year_Unc", "Ten_Year_Anomaly", "Ten_Year_Unc", 
                             "Twenty_Year_Anomaly", "Twenty_year_Unc")

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

# On importe nos données
disaster_data <- read_csv("./natural_disaster.csv")

