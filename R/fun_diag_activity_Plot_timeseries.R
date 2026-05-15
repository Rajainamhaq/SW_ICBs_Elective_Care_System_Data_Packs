


fun_diag_activity_Plot_timeseries <- function(df_diag_activity) {
  ###### get max dates for foot note ####
  mon_rtt_date <- df_diag_activity |>
    filter(data_tye == "Diagnostic activity") 
  max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
  max_rtt_date_fn <- format(max_rtt_date_fn, "%b-%y")
  
  
  yaxis_min_val <- min(df_diag_activity$diag_activity) - 4000
  yaxis_max_val <- max(df_diag_activity$diag_activity) + 2000
  
  ## plot the time series    
  df_diag_activity |>
    select(date_timeseries, FY, diag_activity) |>
    ggplot(aes(x = date_timeseries, y = diag_activity, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
  
    #scale_linetype_manual(values = c("dashed", "solid", "solid")) +  # Specify dotted lines
    #scale_color_manual(values = c("#005EB8",  "#005EB8", "#AE2573")) + 
    
    fy_colour_scale_all() +
    fy_linetype_scale_all() +
    
   
    scale_y_continuous(limits = c(yaxis_min_val,  yaxis_max_val),labels = label_number()) + 
    labs(x = NULL, y = NULL, title =NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data Source: DM01 to ",max_rtt_date_fn)
    )+
    theme(
      legend.position = "bottom",          # Move legend to bottom
      legend.title = element_blank(),      # Optional: remove legend title
      axis.text.x = element_text(angle = 45, hjust = 1),  # Optional: rotate x labels
      #   axis.text.y = element_text(fontface = "bold"),
      panel.grid.major.x = element_blank(),  # Remove major Y grid lines
      panel.grid.minor.x =  element_blank(),  # Remove minor Y grid lines
      plot.caption = element_text(size = 9, hjust = 0, color = "gray30")
      
    )
  
  #return (df_timeseries)
}

