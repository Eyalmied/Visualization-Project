# Throwaway EDA script — evidence for the report's "Data Understanding"
# section (source/structure, trends/outliers/patterns, visual summaries).
# Run from the project root: Rscript scripts/explore_eda.R

source(file.path("R", "data_prep.R"))

df <- build_flights_cache()

cat("\n--- Structure ---\n")
str(df)

cat("\n--- Summary ---\n")
print(summary(df[, c("price", "duration", "days_left", "price_per_hour")]))

cat("\n--- Price skew check (mean vs median; a large gap signals right-skew) ---\n")
cat(sprintf("price:    mean = %.0f, median = %.0f, sd = %.0f\n",
            mean(df$price), median(df$price), sd(df$price)))
cat(sprintf("price by class:\n"))
print(aggregate(price ~ class, df, function(x) c(mean = mean(x), median = median(x))))

cat("\n--- Category counts ---\n")
cat("airline:\n"); print(table(df$airline))
cat("stops:\n"); print(table(df$stops))
cat("class:\n"); print(table(df$class))
cat("route (top 10 by volume):\n")
print(head(sort(table(df$route), decreasing = TRUE), 10))

cat("\n--- Anscombe-style sanity check: summary stats alone can mislead ---\n")
cat("Economy vs Business price distributions look very different despite\n")
cat("both being 'price' — this is why chart #1 uses violin/sina, not just a\n")
cat("single boxplot or a mean/median table (Lecture 1: Anscombe's Quartet;\n")
cat("Lecture 9: violin/sina beats boxplot for bimodal distributions).\n")

cat("\nEDA complete. See PLAN.md §Report Structure for how these findings map\n")
cat("into the written report's Data Understanding / Data Processing sections.\n")
