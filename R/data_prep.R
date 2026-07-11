# Data cleaning, factor ordering, and feature engineering for the Indian
# domestic flights dataset. Produces the cleaned data frame used by every
# chart in the app, and caches it to data/flights_clean.rds so the Shiny
# app doesn't have to re-clean 300k rows on every runApp().

library(dplyr)

source(file.path("R", "city_coords.R"), local = TRUE)

#' Load airlines_flights_data.csv, clean it, and engineer features.
#'
#' @param path path to the raw CSV
#' @return a cleaned data.frame ready for the dashboard
load_and_clean_flights <- function(path = "airlines_flights_data.csv") {
  df <- read.csv(path, stringsAsFactors = FALSE)

  # --- Cleaning ---------------------------------------------------------
  # `index` is a row-number artifact, not analytical data.
  df$index <- NULL

  n_na <- sum(is.na(df))
  n_dup <- sum(duplicated(df))
  message(sprintf("load_and_clean_flights(): %d NA values, %d duplicate rows found", n_na, n_dup))
  df <- df[!duplicated(df), ]

  # --- Factor ordering ----------------------------------------------------
  # departure_time/arrival_time/stops are plain strings in the raw data and
  # would sort alphabetically on a chart axis (e.g. "Afternoon, Early_Morning,
  # Evening..."), which misrepresents the data's natural order. Lecture 2's
  # "order" property of visual variables requires categorical axes to reflect
  # the data's real order.
  time_levels <- c("Early_Morning", "Morning", "Afternoon", "Evening", "Night", "Late_Night")
  df$departure_time <- factor(df$departure_time, levels = time_levels, ordered = TRUE)
  df$arrival_time   <- factor(df$arrival_time,   levels = time_levels, ordered = TRUE)

  df$stops <- factor(df$stops, levels = c("zero", "one", "two_or_more"), ordered = TRUE)
  df$class <- factor(df$class, levels = c("Economy", "Business"))
  df$airline <- factor(df$airline)

  # --- Feature engineering -------------------------------------------------
  # price_per_hour: normalizes ticket cost by flight length, so travelers can
  # compare "value" across short vs long routes, and airlines can compare
  # pricing efficiency.
  df$price_per_hour <- df$price / df$duration

  # route: collapses source/destination into one categorical field for
  # route-level charts (30 unique ordered pairs).
  df$route <- paste(df$source_city, "→", df$destination_city)

  # days_left_bucket: coarser binning of the 1-49 day booking lead time for
  # cleaner group comparisons (raw days_left stays available for the
  # continuous slider filter and the booking-curve chart).
  df$days_left_bucket <- cut(
    df$days_left,
    breaks = c(0, 7, 28, Inf),
    labels = c("Last-minute (1-7 days)", "2-4 weeks (8-28 days)", "1+ month (29-49 days)"),
    right = TRUE
  )

  # Join city coordinates for the India route map.
  df <- merge(df, setNames(city_coords, c("source_city", "src_lat", "src_lon")),
              by = "source_city", all.x = TRUE)
  df <- merge(df, setNames(city_coords, c("destination_city", "dst_lat", "dst_lon")),
              by = "destination_city", all.x = TRUE)

  df
}

#' Build/refresh the cached cleaned dataset.
#'
#' @param csv_path path to the raw CSV
#' @param rds_path path to write the cached .rds
build_flights_cache <- function(csv_path = "airlines_flights_data.csv",
                                 rds_path = file.path("data", "flights_clean.rds")) {
  df <- load_and_clean_flights(csv_path)
  dir.create(dirname(rds_path), showWarnings = FALSE, recursive = TRUE)
  saveRDS(df, rds_path)
  message(sprintf("Cached cleaned dataset (%d rows) to %s", nrow(df), rds_path))
  invisible(df)
}

#' Load the cached cleaned dataset, building it first if missing.
load_flights_cache <- function(csv_path = "airlines_flights_data.csv",
                                rds_path = file.path("data", "flights_clean.rds")) {
  if (!file.exists(rds_path)) {
    return(build_flights_cache(csv_path, rds_path))
  }
  readRDS(rds_path)
}
