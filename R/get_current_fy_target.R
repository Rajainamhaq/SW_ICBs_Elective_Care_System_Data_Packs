
## get the current financial year plan lable value to be used in filter in other functions e.g. Mar-26 target
get_current_fy_target <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  # Financial year ends in March
  end_year <- if (mo >= 4) yr + 1 else yr
  
  sprintf("Mar-%02d target", end_year %% 100)
}