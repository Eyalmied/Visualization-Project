# Server: one central reactive() filtered dataset per tab feeding all of
# that tab's charts (Filter operator), KPI tiles (Abstract/Elaborate),
# metric/color/log-scale toggles (Reconfigure/Encode), a reset button
# (Undo/Redo), and linked brushing between the scatter and the grid /
# between the heatmap and the map (Connect).

library(shiny)
library(dplyr)

kpi_tile <- function(label, value) {
  div(style = "display:inline-block; min-width:160px; padding:10px 16px; margin:4px;
               border:1px solid #e2e2e2; border-radius:6px; background:#fafafa;",
      div(style = "font-size:0.8em; color:#666;", label),
      div(style = "font-size:1.4em; font-weight:bold;", value))
}

server <- function(input, output, session) {

  # ---- Tab A: Traveler ---------------------------------------------------

  filtered_traveler <- reactive({
    d <- flights_df
    if (input$t_source != "All") d <- d[d$source_city == input$t_source, ]
    if (input$t_dest != "All") d <- d[d$destination_city == input$t_dest, ]
    d <- d[d$class %in% input$t_class, ]
    d <- d[d$stops %in% input$t_stops, ]
    d <- d[d$days_left >= input$t_days_left[1] & d$days_left <= input$t_days_left[2], ]
    d <- d[d$duration >= input$t_duration[1] & d$duration <= input$t_duration[2], ]
    d
  })

  output$t_kpi_tiles <- renderUI({
    d <- filtered_traveler()
    if (nrow(d) == 0) return(div("No flights match the current filters."))
    tagList(
      kpi_tile("Flights", format(nrow(d), big.mark = ",")),
      kpi_tile("Avg. price", paste0(round(mean(d$price)), " INR")),
      kpi_tile("Avg. duration", paste0(round(mean(d$duration), 1), " h")),
      kpi_tile("Avg. price/hour", paste0(round(mean(d$price_per_hour)), " INR/h"))
    )
  })

  output$chart_price_class <- renderPlot({
    chart_price_by_class(filtered_traveler(), log_scale = input$t_log_scale)
  })

  output$chart_booking_curve <- renderPlot({
    chart_booking_curve(filtered_traveler())
  })

  output$chart_scatter <- renderPlotly({
    chart_duration_price_scatter(filtered_traveler(), color_by = input$t_color_by)
  })

  # Connect: points lasso-selected on the scatter (#7) highlight the
  # matching flights as an overlay on the departure-time x airline grid (#8).
  scatter_selection <- reactive({
    event_data("plotly_selected", source = "duration_price_scatter")
  })

  output$chart_grid <- renderPlot({
    d <- filtered_traveler()
    base <- chart_time_airline_grid(d, metric = input$t_grid_metric)

    sel <- scatter_selection()
    if (!is.null(sel) && nrow(sel) > 0 && nrow(d) > 0) {
      # sel$key holds the row_id set via the `key` aesthetic in
      # chart_duration_price_scatter() — safe to index into `d` directly,
      # unlike pointNumber which resets per-trace when color_by splits the
      # scatter into multiple plotly traces.
      sel_df <- d[sel$key, ]
      sel_df <- sel_df[!is.na(sel_df$departure_time), ]
      if (nrow(sel_df) > 0) {
        overlay <- sel_df %>% count(departure_time, airline, name = "n_selected")
        base <- base +
          ggplot2::geom_point(data = overlay,
                               ggplot2::aes(x = airline, y = departure_time, size = n_selected),
                               shape = 21, color = "black", fill = NA, stroke = 1, inherit.aes = FALSE) +
          ggplot2::labs(caption = paste(nrow(sel_df), "selected flights highlighted (from scatter selection)"))
      }
    }
    base
  })

  observeEvent(input$t_reset, {
    updateSelectInput(session, "t_source", selected = "All")
    updateSelectInput(session, "t_dest", selected = "All")
    updateCheckboxGroupInput(session, "t_class", selected = levels(flights_df$class))
    updateCheckboxGroupInput(session, "t_stops", selected = levels(flights_df$stops))
    updateSliderInput(session, "t_days_left", value = c(1, 49))
    updateSliderInput(session, "t_duration", value = c(duration_min, duration_max))
    updateCheckboxInput(session, "t_log_scale", value = FALSE)
    updateSelectInput(session, "t_color_by", selected = "stops")
    updateRadioButtons(session, "t_grid_metric", selected = "price")
  })

  # ---- Tab B: Airline Analytics -------------------------------------------

  filtered_airline <- reactive({
    d <- flights_df
    d <- d[d$airline %in% input$a_airline, ]
    if (input$a_source != "All") d <- d[d$source_city == input$a_source, ]
    if (input$a_dest != "All") d <- d[d$destination_city == input$a_dest, ]
    d <- d[d$class %in% input$a_class, ]
    d
  })

  output$a_kpi_tiles <- renderUI({
    d <- filtered_airline()
    if (nrow(d) == 0) return(div("No flights match the current filters."))
    top_airline <- names(sort(table(d$airline), decreasing = TRUE))[1]
    cheapest_airline <- names(sort(tapply(d$price, d$airline, mean)))[1]
    tagList(
      kpi_tile("Flights", format(nrow(d), big.mark = ",")),
      kpi_tile("Market leader", top_airline),
      kpi_tile("Cheapest avg.", cheapest_airline),
      kpi_tile("Avg. price", paste0(round(mean(d$price)), " INR"))
    )
  })

  output$chart_avg_price <- renderPlot({
    chart_avg_price_by_airline(filtered_airline())
  })

  output$chart_market_share <- renderPlot({
    chart_market_share_by_airline(filtered_airline())
  })

  output$chart_heatmap <- renderPlotly({
    chart_route_heatmap(filtered_airline(), metric = input$a_metric)
  })

  # Select: clicking a heatmap cell (#5) highlights that route on the map (#6).
  heatmap_click <- reactive({
    event_data("plotly_click", source = "route_heatmap")
  })

  output$chart_map <- renderLeaflet({
    chart_india_route_map(filtered_airline(), metric = input$a_metric)
  })

  observeEvent(heatmap_click(), {
    click <- heatmap_click()
    d <- filtered_airline()
    if (is.null(click) || nrow(d) == 0) return(NULL)
    dest <- click$x
    src <- click$y
    route_df <- d[d$source_city == src & d$destination_city == dest, ]
    if (nrow(route_df) == 0) return(NULL)

    leafletProxy("chart_map") %>%
      clearGroup("selected_route") %>%
      addPolylines(
        lng = c(route_df$src_lon[1], route_df$dst_lon[1]),
        lat = c(route_df$src_lat[1], route_df$dst_lat[1]),
        weight = 6, color = "#c53030", opacity = 0.9, group = "selected_route",
        label = sprintf("%s -> %s: avg %.0f INR, %d flights", src, dest,
                         mean(route_df$price), nrow(route_df))
      )
  })

  observeEvent(input$a_reset, {
    updateCheckboxGroupInput(session, "a_airline", selected = levels(flights_df$airline))
    updateSelectInput(session, "a_source", selected = "All")
    updateSelectInput(session, "a_dest", selected = "All")
    updateCheckboxGroupInput(session, "a_class", selected = levels(flights_df$class))
    updateRadioButtons(session, "a_metric", selected = "price")
    leafletProxy("chart_map") %>% clearGroup("selected_route")
  })
}
