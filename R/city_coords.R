# 6-city lat/lon lookup table for the India route map (chart #6).
# The raw dataset has no geospatial fields, so these coordinates are
# manually curated (city-center approximations) and joined on source_city /
# destination_city at render time.

city_coords <- data.frame(
  city = c("Delhi", "Mumbai", "Bangalore", "Kolkata", "Hyderabad", "Chennai"),
  lat  = c(28.6139, 19.0760, 12.9716, 22.5726, 17.3850, 13.0827),
  lon  = c(77.2090, 72.8777, 77.5946, 88.3639, 78.4867, 80.2707),
  stringsAsFactors = FALSE
)
