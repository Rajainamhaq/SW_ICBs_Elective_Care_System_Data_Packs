####################################################################
#### function to create time series chart for Clock Starts  ######
###################################################################

fun_clocks_plot_timeseries <- function(df_df_for_series) {
  ###### get max dates for foot note ####
  mon_cs_date <- data_RTT_datamarta |>
    filter(Measure == "Clock Starts" & Data_Source == "RTT monthly") 
    max_cs_date_fn <- max(mon_cs_date$Reporting_Period) 
    max_cs_date_fn <- format(max_cs_date_fn, "%b-%y")
  
    week_ending_fn <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")   
  
  ## get the max and min values for the plot y axis.
  y_min <- min(df_df_for_series$Metric_Value-2000)
  y_max <- max(df_df_for_series$Metric_Value+4000)
  
  
  
  ## plot the time series    
  df_df_for_series |>
 # df_for_series |>  
    filter(Reporting_Period >= get_last_two_fy_start()) |>
    select(date_timeseries, FY, Metric_Value) |>
    ggplot(aes(x = date_timeseries, y = Metric_Value, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
    #scale_linetype_manual(values = c("dashed", "dashed", "solid", "solid","solid")) +  # Specify dotted lines
    #scale_color_manual(values = c("#005EB8", "#768692", "#005EB8", "#AE2573","#768692")) + 
    fy_colour_scale_all() +
    fy_linetype_scale_all() +
    
    
    
    
    #  geom_text(aes(label = round(Metric_Value, 1)), position = position_nudge(y = 5), size = 3) +
    #   geom_text(
    #      aes(x = as.Date("2025-02-01"), y = 0.587, label = "25/26 plans"),  # Specify coordinates and text for "Group 2"
    #      color = "#AE2573", size = 3, fontface = "bold"  # Text styling for "Group 2"
    #    ) +
    #   geom_text(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVR4Xs2RQQrAMAgEfZgf7W9LAguybljJpR3wEse5JOL3ZObDb4x1loDhHbBOFU6i2Ddnw2KNiXcdAXygJlwE8OFVBHDgKrLgSInN4WMe9iXiqIVsTMjH7z/GhNTEibOxQswcYIWYOR/zAjBJfiXh3jZ6AAAAAElFTkSuQmCC
    #      aes(x = as.Date("2025-02-01"), y = 0.634, label = "Mar-26 target"),  # Specify coordinates and text for "Group 2"
    #     color = "red", size = 3  # Text styling for "Group 2"
    #  ) +
    scale_y_continuous(limits = c(y_min, y_max),labels = label_number()) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data sources: RTT monthly published statistics to ",max_cs_date_fn,", ","WLMDS to w/e ", week_ending_fn)
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

