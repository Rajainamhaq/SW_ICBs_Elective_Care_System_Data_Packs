get_last_two_fy_labels_monthly <- function(date = Sys.Date()) {
  
  yr <- as.integer(format(date, "%Y"))
  mo <- as.integer(format(date, "%m"))
  
  if (mo >= 4) {
    current_start <- yr
  } else {
    current_start <- yr - 1
  }
  
  prev_start <- current_start - 1
  
  c(
    sprintf("%02d/%02d monthly", prev_start %% 100, (prev_start + 1) %% 100),
    sprintf("%02d/%02d monthly", current_start %% 100, (current_start + 1) %% 100)
  )
}