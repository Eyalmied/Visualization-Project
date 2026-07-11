# Empty marker file. Its presence tells Shiny's runApp() not to
# auto-source every .R file in this directory before app.R runs (Shiny's
# default "R/ folder" convention) — app.R sources these files itself, in a
# specific order, with local = TRUE, because ui.R/server.R need flights_df
# (built in app.R) to already exist when they're evaluated.
