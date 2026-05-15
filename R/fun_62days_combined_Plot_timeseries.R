####################################################################
#### function to create time series chart for RTT Performance ######
###################################################################

fun_62days_combined_Plot_timeseries <- function(df_cwt_62days_comb) {
###### get max dates for foot note ####
    mon_rtt_date <- df_cwt_62days_comb |>
    filter(data_tye == "RTT Monthly") 
    max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
    max_rtt_date_fn <- format(max_rtt_date_fn, "%b-%y")
    # to show the dips/pieak in line chart add lower and upper breaks (min/max values)
    min_y_axis <- min(df_cwt_62days_comb$perf_perc)-0.01
    max_y_axis <- max(df_cwt_62days_comb$perf_perc)+0.01
    # Compute dynamic "nice" breaks (0.5% = 0.005)
    lower_break <- floor(min_y_axis / 0.01) * 0.01
    upper_break <- ceiling(max_y_axis / 0.01) * 0.01
    # round to nearst 5th
    #lower_break_rounded <- floor(lower_break * 100 / 5) * 5 / 100
  
    
## plot the time series    
    df_cwt_62days_comb |>
    select(date_timeseries, FY, perf_perc) |>
    ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
   # scale_linetype_manual(values = c("dashed", "solid", "solid","dotted")) +  # Specify dotted lines
  #  scale_color_manual(values = c("#005EB8",  "#005EB8", "#AE2573","red")) + 
      
      fy_colour_scale_cancer() +
      fy_linetype_scale_cancer() +
      
    #  geom_text(aes(label = round(perf_perc, 1)), position = position_nudge(y = 5), size = 3) +
 #   geom_text(
#      aes(x = as.Date("2025-02-01"), y = 0.587, label = "25/26 plans"),  # Specify coordinates and text for "Group 2"
#      color = "#AE2573", size = 3, fontface = "bold"  # Text styling for "Group 2"
#    ) +
 #   geom_text(
#      aes(x = as.Date("2025-02-01"), y = 0.634, label = "Mar-26 target"),  # Specify coordinates and text for "Group 2"
 #     color = "red", size = 3  # Text styling for "Group 2"
  #  ) +
      scale_y_continuous(limits = c(lower_break, upper_break),
                         breaks = seq(lower_break,upper_break, by = 0.03 ), labels = label_percent(accuracy = 0.1)) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data source: Cancer Waiting Times data to ",max_rtt_date_fn)
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
  
  