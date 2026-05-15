###

fun_plot_timeseries_RTT_perf <- function(){
  
  df_for_series |>
    select(date_timeseries, FY, perf_perc) |>
    ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
    scale_linetype_manual(values = c("dashed", "dashed", "solid", "solid","dotted")) +  # Specify dotted lines
    scale_color_manual(values = c("#005EB8", "#768692", "#AE2573", "#768692","red")) + 
    #  geom_text(aes(label = round(perf_perc, 1)), position = position_nudge(y = 5), size = 3) +
    geom_text(
      aes(x = as.Date("2025-02-01"), y = 0.587, label = "25/26 plans"),  # Specify coordinates and text for "Group 2"
      color = "#AE2573", size = 3, fontface = "bold"  # Text styling for "Group 2"
    ) +
    geom_text(
      aes(x = as.Date("2025-02-01"), y = 0.634, label = "Mar-26 target"),  # Specify coordinates and text for "Group 2"
      color = "red", size = 3  # Text styling for "Group 2"
    ) +
    scale_y_continuous(limits = c(0.54, 0.65)) + 
    labs(x = "Month", y = "Percentage", title = "RTT Performance") +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal() +
    theme(
      legend.position = "bottom",          # Move legend to bottom
      legend.title = element_blank(),      # Optional: remove legend title
      axis.text.x = element_text(angle = 45, hjust = 1),  # Optional: rotate x labels
      #   axis.text.y = element_text(fontface = "bold"),
      panel.grid.major.x = element_blank(),  # Remove major Y grid lines
      panel.grid.minor.x =  element_blank(),  # Remove minor Y grid lines
      panel.border = element_blank(),
      axis.line = element_line(size = 0.3),  # thin axis lines
      panel.border = element_rect(color = "black", fill = NA, size = 0.5)  # Draw border
    )
  
  
}