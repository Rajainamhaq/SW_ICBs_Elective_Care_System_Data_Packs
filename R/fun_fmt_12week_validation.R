####################################################################################
####### table formatting for 12+ week validation slide ####
####################################################################################
fun_fmt_12week_validation <- function(df_12plus_week_val) {
  
 # df_12plus_week_val
  df_12plus_week_val |>
    gt()  |>                 # put into a gt table
    tab_header(title = "12+ week validation") |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_percent(columns = 4, decimals = 1, scale_values = FALSE) |>
    cols_label(Validation_perc = "Validation %") |>
    fmt_percent(columns = 5, decimals = 1, scale_values = FALSE) |>
  
    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
    cols_align(align = "left", columns = c("Specialty")) |>
    ## color the 1st Col
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
        rows = nrow(df_12plus_week_val))
    ) |>
    
    #### make bottom row of each col bold#####
  # col2
  tab_style(
    style = cell_text(
      color="black",
      weight = "bold"),
    locations = cells_body(
      columns = 2,
      rows = nrow(df_12plus_week_val))
  ) |>
    # col3
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 3,
        rows = nrow(df_12plus_week_val))
    ) |>
    # col 4
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 4,
        rows = nrow(df_12plus_week_val))
    ) |>
    # col 5
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 5,
        rows = nrow(df_12plus_week_val))
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
    locations = cells_body(rows=nrow(df_12plus_week_val)-1)
  ) |>
  
    ###############################
  #highlight the baseline and target selected cells in table
  tab_style(
    style = cell_fill(color = "#E2EFDA"),
    locations = cells_body(
      columns = c(Target),
      rows = Target > 0
    ) ) |>
#    style = cell_fill(color = "#E2EFDA",alpha=.5), # #C6E0B4 for red #FAB4D9
#    locations = cells_body(columns = c(Target), rows = Target < 0.0)
#  )
    
    cols_label(
      In_scope = "In scope"
    ) |>
    
    tab_footnote(
      footnote = md(paste0("Green cells in table shows values above target.
                           \nData source: WLMDS for w/e ", week_ending_fn))
    ) |>
    
    
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold')  #%>% #add NHS blue coloring   
    }
