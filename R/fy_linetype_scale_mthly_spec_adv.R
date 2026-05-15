## to assign the line type to each of the timeseries and legends.

fy_linetype_scale_mthly_spec_adv <- function(drop = FALSE) {
  fy_vals1 <- get_last_two_fy_labels_monthly()
  fy_vals2 <- "Target (12.6%)"
  fy_vals3 <- "Limit (45%)"
  fy_vals4 <- "Target 85%"
  
  
  fy_vals <- c(fy_vals1,fy_vals2,fy_vals3,fy_vals4)
  
  # Define colours in order (old → new, or however you want)
  #colours <- c("#005EB8","#005EB8", "#768692", "#768692", "#AE2573")
  base_linetypes <- c("dashed", "solid","dotted","dotted","dotted")
  
  linetypes <- base_linetypes[seq_along(fy_vals)]
  names(linetypes) <- fy_vals
  
  scale_linetype_manual(
    values = linetypes,
    drop = drop
  )
}