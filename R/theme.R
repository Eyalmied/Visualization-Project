# Shared ggplot theme + colorblind-safe palette. Loaded by both
# helpers_traveler.R and helpers_airline.R so every chart in the app looks
# like one system (Lecture 11: consistent, accessible color mapping).

library(ggplot2)
library(RColorBrewer)

theme_dashboard <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor = element_blank(),
      plot.title = element_text(face = "bold", size = base_size + 1),
      legend.position = "bottom",
      legend.title = element_text(size = base_size - 1),
      axis.title = element_text(size = base_size - 1)
    )
}

# One consistent color per airline, reused across both tabs, so the same
# airline is always the same color everywhere it appears.
airline_levels <- c("AirAsia", "Air_India", "GO_FIRST", "Indigo", "SpiceJet", "Vistara")
airline_palette <- setNames(RColorBrewer::brewer.pal(6, "Set2"), airline_levels)

# Two-level qualitative palette for class (Economy / Business).
class_palette <- setNames(RColorBrewer::brewer.pal(3, "Dark2")[1:2], c("Economy", "Business"))

# Sequential palette for continuous fills (heatmap, map route weight) —
# colorblind-safe, works in grayscale.
sequential_palette <- "YlOrRd"
