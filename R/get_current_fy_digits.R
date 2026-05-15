## get the current financial year digits only e.g. 25/26, 26/27

get_current_fy_digits <- function(date = Sys.Date()) {
  yr <- as.integer(format(date, "%Y"))
  mon <- as.integer(format(date, "%m"))
  
  if (mon >= 4) {
    start_yr <- yr %% 100
    end_yr <- (yr + 1) %% 100
  } else {
    start_yr <- (yr - 1) %% 100
    end_yr <- yr %% 100
  }
  
  sprintf("%02d/%02d", start_yr, end_yr)
}