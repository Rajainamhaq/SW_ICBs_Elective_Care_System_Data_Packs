##############################################################################
#### function to create time series chart for 12+ week validation ######
##############################################################################

fun_12plus_week_validation_Plot_timeseries <- function(df_for_series) {
  ###### get max dates for foot note ####
  mon_rtt_date <- data_RTTt |>
    filter(Measure == "12+ week validation") 
    max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
    max_rtt_date_fn <- format(max_rtt_date_fn, "%d-%b-%y")
    
    min_y <- min(df_for_series$perf_perc - 0.02)
    max_y <- min(df_for_series$perf_perc + 0.02)
  
## plot the time series    
    df_for_series |> 
      select(date_timeseries, FY, perf_perc) |> 
      
      ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) + 
      
      geom_line(size=1) + 
      scale_x_date(date_labels = "%b", date_breaks = "1 month") + 
      
      
     # scale_linetype_manual(values = c("dashed","solid","dotted")) + # Specify dotted lines 
    #  scale_color_manual(values = c( "#768692", "#768692","red")) + 
      fy_colour_scale_wlmds_only() +
      fy_linetype_scale_wlmds_only() +
      
      
      scale_y_continuous(limits = c( min_y,0.99),labels = label_percent(accuracy = 1)) + 
      labs(x = NULL, y = NULL, title = NULL) + # theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      theme_bw() + labs( caption = paste0("Data source: WLMDS to w/e ",max_rtt_date_fn) )+ 
      theme( legend.position = "bottom", # Move legend to bottom 
             legend.title = element_blank(), # Optional: remove legend title 
             axis.text.x = element_text(angle = 45, hjust = 1), # Optional: rotate x labels 
             # axis.text.y = element_text(fontface = "bold"), 
             panel.grid.major.x = element_blank(), # Remove major Y grid lines 
             panel.grid.minor.x = element_blank(), # Remove minor Y grid lines 
             plot.caption = element_text(size = 9, hjust = 0, color = "gray30") 
             )
 
 #return (df_timeseries)
}
  
  