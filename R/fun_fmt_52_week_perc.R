####################################################################################
####### table formatting for RTT % Performance slide ####
####################################################################################
fun_fmt_52_week_perc <- function(RTT_tablet) {
  
  if (nrow(RTT_tablet) > 1) {
  RTT_tablet |>
    gt()  |>                 # put into a gt table
    tab_header(title = "52+ weeks % by specialty") |>
              # subtitle = md(paste("Table below display RTT performance by Specialty with the % point change and highlight pink if below Baseline and green if Above target."))) |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_percent(columns = 4, decimals = 1, scale_values = FALSE) |>
    cols_label(RTT_percentage = "52+ weeks %") |>
    fmt_percent(columns = 5, decimals = 1, scale_values = FALSE) |>
   # cols_label(Percent_Val = "Baseline") |>
   # fmt_percent(columns = 6, decimals = 1, scale_values = FALSE) |>
    #cols_label(Specialty_Modality = "Specialty") |>
    
    
    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
    cols_align(align = "left", columns = vars("Specialty")) |>
    ## color the 1st Col
    data_color(
      columns = vars("Specialty"),
      colors = "#005eb8"
      #colors = parameter_NHS_Blue  
    ) |>
    
    
    ## highlight the medium and high percentages of not validated  
    ### colors not needed yet so commenting out #####
  # data_color(
  #    columns = vars("Percent_not_val"),
  #   colors = scales::col_bin(
  #    palette = c("orange","red"),
  #   bins = c(10,15,100)
  #  ),
  #  apply_to = "text"
  #) |>
  
 
  tab_style(
      style = cell_text(
        color="white",
        weight = "bold"),
      locations = cells_body(
        columns = 1,
        rows = nrow(RTT_tablet))
    ) |>
    
    #### make bottom row of each col bold#####
  # col2
  tab_style(
    style = cell_text(
      color="black",
      weight = "bold"),
    locations = cells_body(
      columns = 2,
      rows = nrow(RTT_tablet))
  ) |>
    # col3
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 3,
        rows = nrow(RTT_tablet))
    ) |>
    # col 4
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 4,
        rows = nrow(RTT_tablet))
    ) |>
    # col 5
 #   tab_style(
  #    style = cell_text(
   #     color="black",
    #    weight = "bold"),
     # locations = cells_body(
      #  columns = 5,
       # rows = nrow(RTT_tablet))
  #  ) |>
    
    
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
    locations = cells_body(rows=nrow(RTT_tablet)-1)
  ) |>
  
    ###############################
  #highlight the baseline and target selected cells in table
  tab_style(
    style = cell_fill(color = "#E2EFDA"),
    locations = cells_body(
      columns = vars(Target),
      rows = Target < 0
    ) ) |>
#    style = cell_fill(color = "#E2EFDA",alpha=.5), # #C6E0B4 for red #FAB4D9
#    locations = cells_body(columns = vars(Target), rows = Target < 0.0)
#  )
 #   tab_style(
  #    style = cell_fill(color = "#ffc7ce"),
   #   locations = cells_body(
   #     columns = vars(Baseline),
   #     rows = Baseline < 0
   #   ) ) |>
    
    

  
  tab_footnote(
    footnote = md(paste0("Note: Table displays 52+ weeks percentage by Specialty with the % point change and highlights green if below target.
                          \nData source: WLMDS for w/e ", week_ending_fn))
  ) |>
    

    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold') |> #%>% #add NHS blue coloring   
    cols_label(
          Target = "Diff from target"
          )
  }
}
