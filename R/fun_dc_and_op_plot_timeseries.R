####################################################################
#### function to create time series chart for Clock Starts  ######
###################################################################

fun_dc_and_op_plot_timeseries <- function(df_for_series) {
  ###### get max dates for foot note ####
 
  ## get the max and min values for the plot y axis.
  y_min <- min(df_for_series$Metric_Value-.015)
  y_max <- max(df_for_series$Metric_Value+.015)
  
  df_for_series |>  
    #filter(Reporting_Period >= "2024-04-01") |>
    select(date_timeseries, FY, Metric_Value) |>
    ggplot(aes(x = date_timeseries, y = Metric_Value, color = FY, linetype = FY)) +
    geom_line(size=1) +
    
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
    
    
   # scale_linetype_manual(values = c("dashed", "solid", "dotted")) +  # Specify dotted lines
  #  scale_color_manual(values = c("#005EB8", "#005EB8", "red")) + 
    
    fy_colour_scale_mthly_spec_adv() +
    fy_linetype_scale_mthly_spec_adv() +
    

    scale_y_continuous(limits = c(y_min, y_max), labels = label_percent() 
                      ) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data source: HES to ",
                       format(max(df_for_series$Reporting_Period),"%b-%y"))
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

