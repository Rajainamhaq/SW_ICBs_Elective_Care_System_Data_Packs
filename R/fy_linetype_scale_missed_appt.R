## to assign the colours to each line in the time series charts 
fy_linetype_scale_missed_appt <- function(drop = FALSE) {
  
  fy_vals1 <- get_last_two_fy_labels_monthly()
  fy_vals2 <- get_current_fy_plans_label()
  fy_vals3 <- "Target (5%)"
  fy_vals4 <- "Limit (5%)"
  
  fy_vals <- c(fy_vals1,fy_vals2,fy_vals3,fy_vals4)
  
  base_linetypes <- c("dashed", "solid","solid", "dotted","dotted")
  
  linetypes <- base_linetypes[seq_along(fy_vals)]
  names(linetypes) <- fy_vals
  
  scale_linetype_manual(
    values = linetypes,
    drop = drop
  )
}