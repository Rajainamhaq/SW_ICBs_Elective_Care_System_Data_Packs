####################################################################################
####### table formatting for Spec Adv for Pre referral Utilisation ####
####################################################################################
fun_fmt_ip_dc_and_op <- function(df_for_table) {
  
  ## 1st get the max date for foot note
  max_date_dc_op_ext <- data_mhst |>
      filter(Measure == "DC and OP rates - specialty level" &
      Metric_Type == "Calculated %") |>
      filter(latest_period == 1) 
  max_date_dc_op <- max(max_date_dc_op_ext$Reporting_Period)
  
# max_date_dc_opa <- format(max_date_sus_opa,"%B-%y")
  
 # df_for_table <- data_mhst_tab_dc_op
  
  df_for_table |>
    gt()  |>                 # put into a gt table
    tab_header(title = "Day case and outpatient procedure rates by specialty") |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_percent(columns = c(2,3), decimals = 1, scale_values = FALSE) |>

    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
   data_color(
      columns = c("Specialty"),
      colors = "#005eb8"
      #colors = parameter_NHS_Blue  
    ) |>
    
 tab_style(
    style = cell_text(
      color="white",
      weight = "bold"),
    locations = cells_body(
      columns = 1,
      rows = nrow(df_for_table))
  ) |>
    
    #### make bottom row of each col bold#####
  # col2&3
  tab_style(
    style = cell_text(
      color="black",
      weight = "bold"),
    locations = cells_body(
      columns = c(2,3),
      rows = nrow(df_for_table))
  ) |>
   
    
    #######################  
  
  ## make the bottom two rows borders bold
  tab_style(
    style = list(
      cell_borders(
        sides = "bottom", 
        weight = px(2),  # 3px for a thicker border
        #color = "black"
        color = parameter_NHS_Blue
      )
    ),
    locations = cells_body(rows=nrow(df_for_table)-1)
  ) |>
    
    ###############################
  #highlight the baseline and target selected cells in table
  tab_style(
    style = cell_fill(color = "#E2EFDA"),
    locations = cells_body(
      columns = 3,
      rows = ppt_from_target > 0
    ) ) |>
       # style = cell_fill(color = "#E2EFDA",alpha=.5), # #C6E0B4 for red #FAB4D9
      #  locations = cells_body(columns = vars(Target), rows = Target < 0.0)
   
    
    
    tab_footnote(
      footnote = md(paste0("Data source: HES for ",
                           format(max_date_dc_op,"%b-%y")))
        ) |>
    
    cols_label(
      ppt_from_target = "ppt from target") |>
    
    
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold')  #%>% #add NHS blue coloring   
    
}
