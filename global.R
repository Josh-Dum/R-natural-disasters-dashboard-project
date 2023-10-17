# global.R
library(tidyverse)
library(shiny)
library(gapminder)
library(dplyr)
library(ggplot2)
library(plotly)

# On importe nos données
disaster_data <- read_csv("./natural_disaster.csv")

