# Chart-building functions for Tab B (Airline Analytics view):
#   #2 average price by airline (ordered bar)
#   #3 market share by airline (ordered bar, NOT pie — see PLAN.md)
#   #5 route price/volume heatmap (source x destination)
#   #6 India route map (leaflet flow map)

library(ggplot2)
library(plotly)
library(dplyr)
library(leaflet)

source(file.path("R", "theme.R"), local = TRUE)
source(file.path("R", "city_coords.R"), local = TRUE)

#' #2 — Average price by airline, ordered bar.
#' Bar length = position on a common scale (Cleveland-McGill's most accurate
#' encoding; Stevens' bar-length exponent ~1.0).
chart_avg_price_by_airline <- function(df) {
  agg <- df %>%
    group_by(airline) %>%
    summarise(mean_price = mean(price), .groups = "drop") %>%
    arrange(mean_price)

  ggplot(agg, aes(x = mean_price, y = reorder(airline, mean_price), fill = airline)) +
    geom_col() +
    scale_fill_manual(values = airline_palette, guide = "none") +
    labs(title = "Average price by airline", x = "Average price (INR)", y = NULL) +
    theme_dashboard()
}

#' #3 — Market share by airline (ordered bar, not pie).
#' See PLAN.md's "Pie chart decision": 6 non-extreme-share categories is
#' exactly where pie-angle misjudgment (Cleveland-McGill, Stevens' Power Law)
#' causes real ranking errors, so a bar chart is used instead.
chart_market_share_by_airline <- function(df) {
  agg <- df %>%
    count(airline, name = "n") %>%
    mutate(share = n / sum(n)) %>%
    arrange(share)

  ggplot(agg, aes(x = share, y = reorder(airline, share), fill = airline)) +
    geom_col() +
    scale_x_continuous(labels = scales::percent) +
    scale_fill_manual(values = airline_palette, guide = "none") +
    labs(title = "Market share by airline (flights operated)", x = "Share of flights", y = NULL) +
    theme_dashboard()
}

#' #5 — Route price/volume heatmap.
#' Good for broad trend, weak for exact readout (Lecture 9) — compensated
#' with a plotly hover tooltip (details-on-demand, Shneiderman's mantra).
#' @param metric "price" or "count" — the Reconfigure operator.
chart_route_heatmap <- function(df, metric = "price") {
  agg <- df %>%
    group_by(source_city, destination_city) %>%
    summarise(mean_price = mean(price), n = n(), .groups = "drop")

  fill_var <- if (metric == "price") "mean_price" else "n"
  fill_label <- if (metric == "price") "Avg. price (INR)" else "Flight count"

  p <- ggplot(agg, aes(x = destination_city, y = source_city, fill = .data[[fill_var]],
                        text = paste0(source_city, " -> ", destination_city,
                                      "<br>Avg price: ", round(mean_price),
                                      "<br>Flights: ", n))) +
    geom_tile(color = "white") +
    scale_fill_distiller(palette = sequential_palette, direction = 1) +
    labs(title = "Route heatmap", x = "Destination", y = "Source", fill = fill_label) +
    theme_dashboard() +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))

  ggplotly(p, tooltip = "text", source = "route_heatmap") %>%
    event_register("plotly_click")
}

#' #6 — India route map (leaflet flow map).
#' Flat 2D line-width/color encoding avoids 3D/volume distortion. India-only
#' scope is geographically honest to the domestic-only dataset (no world
#' map — see PLAN.md's confirmed decisions).
#' @param metric "price" or "count" — shared Reconfigure toggle with the heatmap.
chart_india_route_map <- function(df, metric = "price") {
  agg <- df %>%
    group_by(source_city, destination_city, src_lat, src_lon, dst_lat, dst_lon) %>%
    summarise(mean_price = mean(price), n = n(), .groups = "drop")

  weight_var <- if (metric == "price") agg$mean_price else agg$n
  w <- scales::rescale(weight_var, to = c(1, 8))

  m <- leaflet(agg) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lng = 78.9629, lat = 22.5937, zoom = 4.5)

  for (i in seq_len(nrow(agg))) {
    m <- m %>% addPolylines(
      lng = c(agg$src_lon[i], agg$dst_lon[i]),
      lat = c(agg$src_lat[i], agg$dst_lat[i]),
      weight = w[i], color = "#2b6cb0", opacity = 0.5,
      label = sprintf("%s -> %s: avg %.0f INR, %d flights",
                       agg$source_city[i], agg$destination_city[i],
                       agg$mean_price[i], agg$n[i])
    )
  }

  cities_in_data <- city_coords[city_coords$city %in% unique(c(df$source_city, df$destination_city)), ]
  m %>% addCircleMarkers(
    data = cities_in_data, lng = ~lon, lat = ~lat,
    radius = 6, color = "#c53030", fillOpacity = 0.9, label = ~city
  )
}
