
## get the current financial year plan lable value to be used in filter in other functions e.g. Nov-24 baseline
get_current_fy_baseline <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  # Financial year ends in March
  end_year <- if (mo >= 4) yr + 1 else yr
  
  # Baseline is November two years before FY end
  baseline_year <- end_year - 2
  
  sprintf("Nov-%02d baseline", baseline_year %% 100)
}