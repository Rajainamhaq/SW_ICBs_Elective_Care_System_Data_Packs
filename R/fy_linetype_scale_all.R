## to assign the line type to each of the timeseries and legends.

fy_linetype_scale_all <- function(drop = FALSE) {
  fy_vals1 <- get_last_two_fy_labels_monthly()
  fy_vals2 <- get_last_two_fy_labels_wlmds()
  fy_vals3 <- get_current_fy_plans_label()
  fy_vals4 <- get_current_fy_target()
  fy_vals5 <- get_current_fy_baseline()
  fy_vals_28dfds <- "Target (80%)"
  fy_vals_31dc <- "Target (96%)"
  fy_vals_62dc <- "Target (75%)"
  
  fy_vals <- c(fy_vals1,fy_vals2,fy_vals3,fy_vals4,fy_vals5)
  
  # Define colours in order (old → new, or however you want)
  #colours <- c("#005EB8","#005EB8", "#768692", "#768692", "#AE2573")
  base_linetypes <- c("dashed", "solid", "dashed", "solid", "solid","dotted","dotted","dotted","dotted","dotted")
  
  linetypes <- base_linetypes[seq_along(fy_vals)]
  names(linetypes) <- fy_vals
  
  scale_linetype_manual(
    values = linetypes,
    drop = drop
  )
}