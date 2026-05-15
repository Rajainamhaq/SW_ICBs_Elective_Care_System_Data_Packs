## to get the end date of FY

get_fy_end_march_start <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  end_year <- if (mo >= 4) yr + 1 else yr
  
  as.Date(paste0(end_year, "-03-01"))
}