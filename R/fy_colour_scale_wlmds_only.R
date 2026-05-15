## to assign the colours to each line in the time series charts 
fy_colour_scale_wlmds_only <- function(drop = FALSE) {
  
  fy_vals2 <- get_last_two_fy_labels_wlmds()
  fy_vals4 <- "Target (90%)"
  
  
  fy_vals <- c(fy_vals2,fy_vals4)
  
  # Define colours in order 
  colours <- c("#768692", "#768692","red")
  
  names(colours) <- fy_vals
  
  scale_color_manual(
    values = colours,
    drop = drop
  )
}