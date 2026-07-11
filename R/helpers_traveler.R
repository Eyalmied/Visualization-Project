# Chart-building functions for Tab A (Traveler view):
#   #1 price distribution by class (violin + sina/jitter)
#   #4 price vs. days_left booking curve (line/scatter + smooth)
#   #7 duration vs. price scatter, colored by stops (plotly, brushable)
#   #8 departure_time x airline grid (small multiples)

library(ggplot2)
library(plotly)
library(dplyr)

source(file.path("R", "theme.R"), local = TRUE)

#' #1 — Price distribution by class.
#' Violin + jitter chosen over boxplot because Economy/Business price is
#' bimodal; a boxplot would hide that (Lecture 9).
#' @param log_scale if TRUE, apply scale_y_log10() (Lecture 4: log transform
#'   for skewed data) — this is the app's Encode-operator toggle.
chart_price_by_class <- function(df, log_scale = FALSE) {
  p <- ggplot(df, aes(x = class, y = price, fill = class)) +
    geom_violin(alpha = 0.6, trim = FALSE) +
    geom_jitter(width = 0.15, alpha = 0.08, size = 0.6) +
    scale_fill_manual(values = class_palette, guide = "none") +
    labs(title = "Price distribution by class", x = NULL, y = "Price (INR)") +
    theme_dashboard()

  if (log_scale) {
    p <- p + scale_y_log10()
  }
  p
}

#' #4 — Price vs. days_left booking curve.
#' Answers "when should I book?" directly; geom_smooth per Lecture 4.
#' Aggregates to mean price per (days_left, class) first — days_left only
#' has 49 distinct values, so this is both a cleaner trend line than a
#' smooth over raw points and avoids fitting LOESS directly on up to 300k
#' raw rows, which is far too slow (LOESS scales poorly with n and can hit
#' R's loess() k-d-tree point-count limit outright).
chart_booking_curve <- function(df) {
  agg <- df %>%
    group_by(days_left, class) %>%
    summarise(mean_price = mean(price), .groups = "drop")

  ggplot(agg, aes(x = days_left, y = mean_price, color = class)) +
    geom_point(alpha = 0.4, size = 1) +
    geom_smooth(method = "loess", se = TRUE, linewidth = 1) +
    scale_color_manual(values = class_palette) +
    labs(title = "Price vs. days before departure", x = "Days left until departure",
         y = "Mean price (INR)", color = NULL) +
    theme_dashboard()
}

#' #7 — Duration vs. price scatter, colored by a chosen variable.
#' Scatter (not bubble) avoids Lecture 9's dual position+size critique.
#' @param color_by one of "stops", "class", "airline" — the Encode operator.
#' Points are plotted in `df` row order (1..nrow(df)). Because color_by
#' splits the plot into multiple plotly traces, pointNumber alone would
#' reset per-trace, so each point also carries its row index via the `key`
#' aesthetic (mapped by ggplotly to plotly's customdata / event_data$key) —
#' this is what makes the Connect/linked-brushing lookup in server.R correct.
#' Rendering all rows in an interactive plotly scatter is far too slow in a
#' browser once the filtered set gets into the tens/hundreds of thousands
#' (e.g. the unfiltered 300k-row baseline) — points are capped to a random
#' sample of `max_points` for display. row_id is assigned from the *full*
#' filtered_traveler() row positions before sampling, so the Connect lookup
#' in server.R (`d[sel$key, ]`) still indexes correctly into the un-sampled
#' filtered data.
chart_duration_price_scatter <- function(df, color_by = "stops", max_points = 5000) {
  df$color_var <- df[[color_by]]
  df$row_id <- seq_len(nrow(df))
  if (nrow(df) > max_points) {
    df <- df[sample(nrow(df), max_points), ]
  }
  p <- ggplot(df, aes(x = duration, y = price, color = color_var, key = row_id,
                       text = paste0(route, "<br>", airline, " · ", class))) +
    geom_point(alpha = 0.35, size = 1) +
    labs(title = "Flight duration vs. price", x = "Duration (hours)",
         y = "Price (INR)", color = color_by) +
    theme_dashboard()

  ggplotly(p, tooltip = "text", source = "duration_price_scatter") %>%
    layout(dragmode = "select") %>%
    event_register("plotly_selected")
}

#' #8 — Departure-time x airline grid.
#' Rows ordered by time-of-day (not alphabetical); Reconfigure operator lets
#' the user switch the fill metric between mean price and flight count.
#' @param metric "price" or "count"
chart_time_airline_grid <- function(df, metric = "price") {
  agg <- df %>%
    group_by(departure_time, airline) %>%
    summarise(mean_price = mean(price), n = n(), .groups = "drop")

  fill_var <- if (metric == "price") "mean_price" else "n"
  fill_label <- if (metric == "price") "Avg. price (INR)" else "Flight count"

  ggplot(agg, aes(x = airline, y = departure_time, fill = .data[[fill_var]])) +
    geom_tile(color = "white") +
    scale_fill_distiller(palette = sequential_palette, direction = 1) +
    labs(title = "Departure time x airline", x = NULL, y = NULL, fill = fill_label) +
    theme_dashboard() +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}
