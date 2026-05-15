## to assign the colours to each line in the time series charts 
fy_colour_scale_diagperf <- function(drop = FALSE) {
  
  fy_vals1 <- get_last_two_fy_labels_monthly()
  fy_vals2 <- get_last_two_fy_labels_wlmds()
  fy_vals3 <- "Target (5%)"
  fy_vals4 <- "Ambition (15%)"
  
  
  fy_vals <- c(fy_vals1,fy_vals2,fy_vals3,fy_vals4)
  
  # Define colours in order 
  colours <- c("#005EB8","#005EB8", "#768692", "#768692", "red","orange")
  
  names(colours) <- fy_vals
  
  scale_color_manual(
    values = colours,
    drop = drop
  )
}