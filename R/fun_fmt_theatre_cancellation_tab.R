

fun_fmt_theatre_cancellation_tab <- function(df_for_thtr_canc_table) {
  
  ## get max date for foot note
  max_date_fn <- format(max(df_for_thtr_canc_table$Reporting_Period),"%b-%y")
    
  df_for_thtr_canc_table |>
    select(Metrics,`cases %`) |>
    gt() |>
    tab_header(title = "Case cancellation metrics") |> 
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_percent(columns = 2, decimals = 1) |>
    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
 
     tab_footnote(
       footnote = paste0("Data Source: National Theatre data collection for ", max_date_fn)) |>
      
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold')  #%>% #add NHS blue coloring   
}