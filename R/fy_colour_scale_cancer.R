## to assign the colours to each line in the time series charts 
fy_colour_scale_cancer <- function(drop = FALSE) {
  
  fy_vals1 <- get_last_two_fy_labels_monthly()
  fy_vals2 <- get_current_fy_plans_label()
  fy_vals_28dfds <- "Target (80%)"
  fy_vals_31dc <- "Target (96%)"
  fy_vals_62dc <- "Target (75%)"
  
  fy_vals <- c(fy_vals1,fy_vals2,fy_vals_28dfds,fy_vals_31dc,fy_vals_62dc)
  
  # Define colours in order 
  colours <- c("#005EB8","#005EB8", "#AE2573","red","red","red")
  
  names(colours) <- fy_vals
  
  scale_color_manual(
    values = colours,
    drop = drop
  )
}