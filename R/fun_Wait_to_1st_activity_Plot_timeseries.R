##############################################################################
#### function to create time series chart for Wiat to first Performance ######
##############################################################################

fun_Wait_to_1st_activity_Plot_timeseries <- function(df_df_for_series) {
  ###### get max dates for foot note ####
  mon_rtt_date <- df_timeseries |>
    filter(data_tye == "RTT Monthly") 
    max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
    max_rtt_date_fn <- format(max_rtt_date_fn, "%b-%y")
  
  mon_wlmds_date <- df_timeseries |>
    filter(data_tye == "WLMDS") 
    max_wlmds_date_fn <- max(mon_wlmds_date$Reporting_Period)
    max_wlmds_date_fn <- format(max_wlmds_date_fn, "%d-%b-%y")   
  
    #month_ending_fn <- format(max(data_RTT_datamarta$Reporting_Period),"%b-%y")  
     week_ending_fn <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")    
     
     perf_perc_min <- min(df_timeseries$perf_perc) - 0.02
     perf_perc_max <- max(df_timeseries$perf_perc) + 0.02
     
     
  
  
## plot the time series    
 df_timeseries |>
   distinct() |>
    select(date_timeseries, FY, perf_perc) |>
    ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
  #  scale_linetype_manual(values = c("dashed", "solid", "solid","dotted","dotted")) +  # Specify dotted lines
  #  scale_color_manual(values = c( "#768692", "#AE2573", "#768692","red","purple")) + 
   
   fy_colour_scale_all() +
   fy_linetype_scale_all() +
   
    #  geom_text(aes(label = round(perf_perc, 1)), position = position_nudge(y = 5), size = 3) +
 #   geom_text(
#      aes(x = as.Date("2025-02-01"), y = 0.587, label = "25/26 plans"),  # Specify coordinates and text for "Group 2"
#      color = "#AE2573", size = 3, fontface = "bold"  # Text styling for "Group 2"
#    ) +
 #   geom_text(
#      aes(x = as.Date("2025-02-01"), y = 0.634, label = "Mar-26 target"),  # Specify coordinates and text for "Group 2"
 #     color = "red", size = 3  # Text styling for "Group 2"
  #  ) +
    scale_y_continuous(limits = c(perf_perc_min, perf_perc_max ),labels = label_percent(accuracy = 1)) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data source: WLMDS to w/e ",week_ending_fn)
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
  
  