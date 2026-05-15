##############################################################################
#### function to create time series chart for Wiat to first Performance ######
##############################################################################

fun_theatre_cancellation_Plot_timeseries <- function(df_for_thtr_canc_series) {
 
  
max_thtr_date <-  format(max(df_for_thtr_canc_series$Reporting_Period),"%b-%y")
  
  
 #df_timeseries |>
df_for_thtr_canc_series |>
  select(date_timeseries, FY1, Metric_Value) |>
  ggplot(aes(
    x = date_timeseries,
    y = Metric_Value / 100,
    colour = FY1,
    linetype = FY1
  )) +
  geom_line(size = 1) +
  
  ## commented out line chart lables
  #geom_text(
  #  aes(label = percent(Metric_Value / 100, accuracy = 0.1)),
  #  vjust = -0.5,
  #  show.legend = FALSE
  #) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  scale_linetype_manual(values = c(
    "24/25 cancelled 0-3 days" = "dashed",
    "25/26 cancelled 0-3 days" = "solid"
  )) +
  scale_colour_manual(values = c(
    "24/25 cancelled 0-3 days" = "#0041C2",
    "25/26 cancelled 0-3 days" = "#0041C2"
  )) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(
      NA,
      max(df_for_thtr_canc_series$Metric_Value / 100, na.rm = TRUE) + 0.01
    )
  ) +
  labs(
    x = NULL,
    y = NULL,
    caption = paste0(
      "Data source: National Theatre Data Collection to ",
      max_thtr_date
    )
  ) +
  theme_bw() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    legend.key.width = unit(2, "cm"),
    plot.caption = element_text(size = 10, hjust = 0, color = "gray30")
  ) 
 
 #return (df_timeseries)
}
  
  