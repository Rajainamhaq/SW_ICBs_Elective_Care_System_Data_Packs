####################################################################
#### function to create time series chart for RTT Performance ######
###################################################################

fun_missed_appointments_Plot_timeseries <- function(df_pifu_utilisation) {
###### get max dates for foot note ####
    mon_rtt_date <- df_pifu_utilisation |>
    filter(data_tye == "RTT Monthly") 
    max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
    max_rtt_date_fn <- format(max_rtt_date_fn, "%b-%y")
    
    min_y_axis <- min(df_pifu_utilisation$perf_perc)-0.001
    max_y_axis <- max(df_pifu_utilisation$perf_perc)+0.002
    # Compute dynamic "nice" breaks (0.5% = 0.005)
    lower_break <- floor(min_y_axis / 0.001) * 0.001
    upper_break <- ceiling(max_y_axis / 0.002) * 0.002
    
  
    
## plot the time series    
    df_pifu_utilisation |>
    select(date_timeseries, FY, perf_perc) |>
    ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) +
    geom_line(size=1) +
      
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
  #  scale_linetype_manual(values = c("dashed", "solid","dotted")) +  # Specify dotted lines
   # scale_color_manual(values = c("#005EB8",  "#005EB8","red")) + 
      
      fy_colour_scale_missed_appt() +
      fy_linetype_scale_missed_appt() +
 
    scale_y_continuous(limits = c(lower_break, upper_break),
                      breaks = seq(lower_break,upper_break, by = 0.001 ), labels = label_percent(accuracy = 0.1)) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      
      
    theme_bw() +
    labs(
      caption = paste0("Data source: SUS OPA to ",max_rtt_date_fn)
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
  
  