# UI: navbarPage with two tabPanels (Traveler / Airline Analytics), each a
# sidebarLayout — fixed sidebar of filters + main panel with KPI tiles on
# top and two rows of two charts (Stephen Few single-screen principle,
# Lecture 8: no vertical scroll-chasing, no decorative chart-junk).

airline_choices <- levels(flights_df$airline)
city_choices <- sort(unique(as.character(flights_df$source_city)))
stops_choices <- levels(flights_df$stops)

# floor()/ceiling() (not round()) so the slider's default range always fully
# covers the true data range — round() alone could round the true max DOWN
# (e.g. 49.83 -> 49.8), silently excluding legitimate rows even when the
# slider is left at its default "full range" position.
duration_min <- floor(min(flights_df$duration) * 10) / 10
duration_max <- ceiling(max(flights_df$duration) * 10) / 10

ui <- navbarPage(
  title = "Indian Flights Explorer",
  theme = NULL,
  header = tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),

  tabPanel(
    "Traveler View",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h4("Filters"),
        selectInput("t_source", "Source city", choices = c("All", city_choices), selected = "All"),
        selectInput("t_dest", "Destination city", choices = c("All", city_choices), selected = "All"),
        checkboxGroupInput("t_class", "Class", choices = levels(flights_df$class), selected = levels(flights_df$class)),
        checkboxGroupInput("t_stops", "Stops", choices = stops_choices, selected = stops_choices),
        sliderInput("t_days_left", "Days left until departure",
                    min = 1, max = 49, value = c(1, 49), step = 1),
        sliderInput("t_duration", "Flight duration (hours)",
                    min = duration_min, max = duration_max,
                    value = c(duration_min, duration_max)),
        hr(),
        h4("Chart options"),
        checkboxInput("t_log_scale", "Log scale (price distribution)", value = FALSE),
        selectInput("t_color_by", "Color scatter by", choices = c("stops", "class", "airline"), selected = "stops"),
        radioButtons("t_grid_metric", "Grid metric", choices = c("Mean Price" = "price", "Flight Count" = "count"), inline = TRUE),
        hr(),
        actionButton("t_reset", "Reset all filters", icon = icon("rotate-left"))
      ),
      mainPanel(
        width = 9,
        uiOutput("t_kpi_tiles"),
        fluidRow(
          column(6, plotOutput("chart_price_class", height = 320)),
          column(6, plotOutput("chart_booking_curve", height = 320))
        ),
        fluidRow(
          column(6, plotlyOutput("chart_scatter", height = 380)),
          column(6, plotOutput("chart_grid", height = 380))
        ),
        div(style = "color:#666; font-size: 0.85em; margin-top: 8px;",
            "Tip: lasso-select points on the scatter plot to highlight the matching flights in the grid on the right.")
      )
    )
  ),

  tabPanel(
    "Airline Analytics",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h4("Filters"),
        checkboxGroupInput("a_airline", "Airline", choices = airline_choices, selected = airline_choices),
        selectInput("a_source", "Source city", choices = c("All", city_choices), selected = "All"),
        selectInput("a_dest", "Destination city", choices = c("All", city_choices), selected = "All"),
        checkboxGroupInput("a_class", "Class", choices = levels(flights_df$class), selected = levels(flights_df$class)),
        hr(),
        h4("Chart options"),
        radioButtons("a_metric", "Heatmap / map metric", choices = c("Mean Price" = "price", "Flight Count" = "count"), inline = TRUE),
        hr(),
        actionButton("a_reset", "Reset all filters", icon = icon("rotate-left"))
      ),
      mainPanel(
        width = 9,
        uiOutput("a_kpi_tiles"),
        fluidRow(
          column(6, plotOutput("chart_avg_price", height = 320)),
          column(6, plotOutput("chart_market_share", height = 320))
        ),
        fluidRow(
          column(6, plotlyOutput("chart_heatmap", height = 320)),
          column(6, leafletOutput("chart_map", height = 320))
        ),
        div(style = "color:#666; font-size: 0.85em; margin-top: 8px;",
            "Tip: click a cell on the route heatmap to highlight that route on the map.")
      )
    )
  )
)
