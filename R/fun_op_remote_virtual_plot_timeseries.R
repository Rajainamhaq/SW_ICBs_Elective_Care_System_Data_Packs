####################################################################
#### function to create time series chart for Clock Starts  ######
###################################################################

fun_op_remote_virtual_plot_timeseries <- function(df_for_series) {
  ###### get max dates for foot note ####
 
  ## get the max and min values for the plot y axis.
  y_min <- min(df_for_series$Metric_Value-50)
  y_max <- max(df_for_series$Metric_Value+50)
  
  df_for_series |>  
    #filter(Reporting_Period >= "2024-04-01") |>
    select(date_timeseries, FY, Metric_Value) |>
    ggplot(aes(x = date_timeseries, y = Metric_Value, color = FY, linetype = FY)) +
    geom_line(size=1) +
    
    ## commented out line labels as not required
    #geom_text(
    #  data = dplyr::filter(df_for_series, Reporting_Period >= min(date_timeseries) %m+% years(1)),
    #  aes(label = comma(round(Metric_Value, 0))),
    #  vjust = -0.5,
    #  size = 3,
    #  show.legend = FALSE
    #)+
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
   
     scale_linetype_manual(values = c("dashed", "dashed", "solid", "solid")) +  # Specify dotted lines
    scale_color_manual(values = c("#005EB8", "#768692", "#005EB8","#768692")) + 
    
    #fy_colour_scale_all() +
    #fy_linetype_scale_all() +

    scale_y_continuous(limits = c(y_min, y_max), 
                       ) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data source: SUS OPA specific acute activity to ",
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

