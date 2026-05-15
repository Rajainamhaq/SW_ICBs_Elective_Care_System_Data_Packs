get_last_two_fy_start <- function(date = Sys.Date(), fy_start_month = 4, fy_start_day = 1) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  if (mo >= fy_start_month) {
    start_year <- yr - 1
  } else {
    start_year <- yr - 2
  }
  
  as.Date(sprintf("%d-%02d-%02d", start_year, fy_start_month, fy_start_day))
}