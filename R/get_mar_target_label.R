## get the lable for current year target eg. for 25/26 is 'Mar-26 target'

get_mar_target_label <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  end_year <- if (mo >= 4) yr + 1 else yr
  
  sprintf("Mar-%02d target", end_year %% 100)
}