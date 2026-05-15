
## get the current finantial year start data to be used in filtering plan data.

get_fy_start <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  if (mo >= 4) {
    as.Date(paste0(yr, "-04-01"))
  } else {
    as.Date(paste0(yr - 1, "-04-01"))
  }
}