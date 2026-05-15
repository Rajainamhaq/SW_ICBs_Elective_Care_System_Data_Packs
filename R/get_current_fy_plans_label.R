
## get the current financial year plan lable value to be used in filter in other functions e.g. '25/26 plans' or '26/27 plans'
get_current_fy_plans_label <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  start_year <- if (mo >= 4) yr else yr - 1
  
  sprintf("%02d/%02d plans", start_year %% 100, (start_year + 1) %% 100)
}