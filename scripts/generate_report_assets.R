# Generates the static chart images and summary statistics used in the
# written report (report/Report.docx). Re-run after any change to the
# cleaning logic or chart functions to refresh report/figures/ and
# report/stats.json.
#
# Note: charts #6 (India route map) and #7 (duration/price scatter) are
# interactive in the live app (leaflet / plotly); this script renders
# static ggplot equivalents purely for embedding in the written report.

library(ggplot2)
library(dplyr)
library(jsonlite)

source(file.path("R", "data_prep.R"), local = TRUE)
source(file.path("R", "theme.R"), local = TRUE)
source(file.path("R", "helpers_traveler.R"), local = TRUE)
source(file.path("R", "helpers_airline.R"), local = TRUE)

df <- load_flights_cache()

fig_dir <- file.path("report", "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

save_fig <- function(name, plot, width = 8, height = 5) {
  ggsave(file.path(fig_dir, name), plot = plot, width = width, height = height, dpi = 150, bg = "white")
  message("Saved ", name)
}

# --- Charts reused directly from the app's own chart functions -------------

save_fig("fig1_price_by_class.png", chart_price_by_class(df))
save_fig("fig2_avg_price_airline.png", chart_avg_price_by_airline(df))
save_fig("fig3_market_share.png", chart_market_share_by_airline(df))
save_fig("fig4_booking_curve.png", chart_booking_curve(df))
save_fig("fig8_time_airline_grid.png", chart_time_airline_grid(df, metric = "price"))

# --- Static equivalents of the two interactive (plotly/leaflet) charts -----
# (duplicated here rather than refactoring the app's plotly-wrapped
# functions, to avoid touching working app code just for report export)

route_agg <- df %>%
  group_by(source_city, destination_city) %>%
  summarise(mean_price = mean(price), n = n(), .groups = "drop")

fig5 <- ggplot(route_agg, aes(x = destination_city, y = source_city, fill = mean_price)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(mean_price)), size = 3, color = "black") +
  scale_fill_distiller(palette = sequential_palette, direction = 1) +
  labs(title = "Route heatmap: average price (INR)", x = "Destination", y = "Source", fill = "Avg. price") +
  theme_dashboard() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
save_fig("fig5_route_heatmap.png", fig5)

map_agg <- df %>%
  group_by(source_city, destination_city, src_lat, src_lon, dst_lat, dst_lon) %>%
  summarise(n = n(), .groups = "drop")

fig6 <- ggplot() +
  geom_segment(data = map_agg, aes(x = src_lon, y = src_lat, xend = dst_lon, yend = dst_lat, linewidth = n),
               color = "#2b6cb0", alpha = 0.4, lineend = "round") +
  geom_point(data = city_coords, aes(x = lon, y = lat), color = "#c53030", size = 4) +
  geom_text(data = city_coords, aes(x = lon, y = lat, label = city), vjust = -1, size = 3.5, fontface = "bold") +
  scale_linewidth(range = c(0.3, 4), guide = "none") +
  labs(title = "India route map (static export; interactive in the live app)",
       x = "Longitude", y = "Latitude") +
  theme_dashboard() +
  coord_fixed(1.1)
save_fig("fig6_india_map.png", fig6)

scatter_sample <- df[sample(nrow(df), min(5000, nrow(df))), ]
fig7 <- ggplot(scatter_sample, aes(x = duration, y = price, color = stops)) +
  geom_point(alpha = 0.35, size = 1) +
  labs(title = "Flight duration vs. price (5,000-point sample; colored by stops)",
       x = "Duration (hours)", y = "Price (INR)", color = "Stops") +
  theme_dashboard()
save_fig("fig7_duration_price_scatter.png", fig7)

# --- Summary statistics for the report narrative ----------------------------

price_by_class <- df %>% group_by(class) %>%
  summarise(mean_price = mean(price), median_price = median(price), .groups = "drop")

price_by_airline <- df %>% group_by(airline) %>%
  summarise(mean_price = mean(price), n = n(), .groups = "drop") %>% arrange(mean_price)

price_by_stops <- df %>% group_by(stops) %>%
  summarise(mean_price = mean(price), n = n(), .groups = "drop")

booking_early <- mean(df$price[df$days_left <= 3])
booking_late <- mean(df$price[df$days_left >= 30])

route_stats <- df %>% group_by(route) %>%
  summarise(mean_price = mean(price), n = n(), .groups = "drop")
top_expensive <- route_stats %>% arrange(desc(mean_price)) %>% head(3)
top_cheap <- route_stats %>% arrange(mean_price) %>% head(3)
top_busy <- route_stats %>% arrange(desc(n)) %>% head(3)

market_share <- df %>% count(airline) %>% mutate(share_pct = round(100 * n / sum(n), 1)) %>% arrange(desc(share_pct))

stats <- list(
  n_rows = nrow(df),
  n_airlines = length(unique(df$airline)),
  n_cities = length(unique(df$source_city)),
  n_routes = length(unique(df$route)),
  n_na = sum(is.na(df)),
  price_min = min(df$price), price_max = max(df$price),
  price_mean = round(mean(df$price)), price_median = round(median(df$price)), price_sd = round(sd(df$price)),
  duration_min = min(df$duration), duration_max = max(df$duration), duration_mean = round(mean(df$duration), 1),
  duration_price_cor = round(cor(df$duration, df$price), 3),
  price_by_class = price_by_class,
  price_by_airline = price_by_airline,
  price_by_stops = price_by_stops,
  booking_early_mean = round(booking_early), booking_late_mean = round(booking_late),
  booking_pct_diff = round(100 * (booking_early - booking_late) / booking_late, 1),
  top_expensive_routes = top_expensive,
  top_cheap_routes = top_cheap,
  top_busy_routes = top_busy,
  market_share = market_share
)

write_json(stats, file.path("report", "stats.json"), pretty = TRUE, auto_unbox = TRUE, digits = 4)
message("Saved report/stats.json")
message("\nDone. Figures in report/figures/, stats in report/stats.json")
