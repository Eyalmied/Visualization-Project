# Entry point. Run with: shiny::runApp() from this directory (or click
# "Run App" in RStudio with this file open).

library(shiny)
library(plotly)
library(leaflet)
library(ggplot2)
library(dplyr)

# local = TRUE keeps everything (functions, flights_df, ui, server) in the
# same environment that shiny::runApp() creates for this app.R — without it,
# source()'s default (evaluate in .GlobalEnv) splits data_prep.R's output
# from what ui.R/server.R can see, and flights_df "disappears".
source(file.path("R", "data_prep.R"), local = TRUE)
source(file.path("R", "theme.R"), local = TRUE)
source(file.path("R", "helpers_traveler.R"), local = TRUE)
source(file.path("R", "helpers_airline.R"), local = TRUE)

flights_df <- load_flights_cache()

source(file.path("R", "ui.R"), local = TRUE)
source(file.path("R", "server.R"), local = TRUE)

shinyApp(ui = ui, server = server)
