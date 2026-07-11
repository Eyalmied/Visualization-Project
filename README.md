# Indian Flights Dashboard

R Shiny dashboard for the "Visualization of Information" course project. Full context, rubric, lecture theory citations, and the team task breakdown are in [`PLAN.md`](PLAN.md) — read that first.

## Requirements

- [R](https://cran.r-project.org/bin/windows/base/) and [RStudio Desktop](https://posit.co/download/rstudio-desktop/)
- R packages:
  ```r
  install.packages(c("shiny", "ggplot2", "plotly", "dplyr", "leaflet", "RColorBrewer"))
  ```

## Run the app

From this directory (or open `app.R` in RStudio and click "Run App"):

```r
shiny::runApp()
```

The first run builds and caches the cleaned dataset to `data/flights_clean.rds` (a few seconds for 300k rows); subsequent runs load the cache instantly.

## Run the EDA script

```r
source("scripts/explore_eda.R")
```

Prints structure, summary stats, and skew checks used as evidence for the report's Data Understanding section.

## Project layout

See `PLAN.md` → "Repository Structure" for the full annotated file tree.
