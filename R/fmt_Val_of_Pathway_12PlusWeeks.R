####################################################################################
####### table formatting for Validation of pathways currently waiting 12+ weeks ####
####################################################################################
fmt_Val_of_Pathway_12PlusWeeks <- function(Total_12_plus_wks_main_df) {
  
  Total_12_plus_wks_main_df
  Total_12_plus_wks_main_df |>
    gt()  |>                 # put into a gt table
    tab_header(title = "Validation of pathways currently waiting 12+ weeks",
               subtitle = md(paste("Pathways by specialty waiting 12+ weeks by validation status for w/e ",week_ending))) |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_percent(columns = 7, decimals = 1, scale_values = FALSE) |>
    cols_label(Percent_not_val = "% not validated") |>
    fmt_percent(columns = 8, decimals = 1, scale_values = FALSE) |>
    cols_label(Percent_Val = "% validated") |>
    
    
    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
    cols_align(align = "center", columns = vars("Top 10 Specialties")) |>
    ## color the 1st Col
    data_color(
      columns = vars("Top 10 Specialties"),
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
      rows = nrow(Total_12_plus_wks_main_df)-1)
  ) |>
    
    tab_style(
      style = cell_text(
        color="white",
        weight = "bold"),
      locations = cells_body(
        columns = 1,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    
    #### make bottom row of each col bold#####
  # col2
  tab_style(
    style = cell_text(
      color="black",
      weight = "bold"),
    locations = cells_body(
      columns = 2,
      rows = nrow(Total_12_plus_wks_main_df))
  ) |>
    # col3
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 3,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    # col 4
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 4,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    # col 5
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 5,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    # col 6
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 6,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 7,
        rows = nrow(Total_12_plus_wks_main_df))
    ) |>
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 8,
        rows = nrow(Total_12_plus_wks_main_df))
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
    locations = cells_body(rows=nrow(Total_12_plus_wks_main_df)-1)
  ) |>
    tab_style(
      style = list(
        cell_borders(
          sides = "bottom", 
          weight = px(2),  # 3px for a thicker border
          #color = "black"
          color = parameter_NHS_Blue
        )
      ),
      locations = cells_body(rows=nrow(Total_12_plus_wks_main_df)-2)
    ) |>
    ###############################
  
  tab_footnote(
    footnote = md(paste("English commissioned pathways only
                  \nData Source: WLMDS for w/e ", week_ending))
  ) |>
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold') #%>% #add NHS blue coloring   
}
```

```{r echo=FALSE, message=FALSE, warning = FALSE}

create_notes <- function(df_provider) {
  
  total_pathways <- as.integer(df_provider[nrow(df_provider),2])
  top_specialty <- as.character(df_provider[1,1])
  top_specialty_pw <- as.integer(df_provider[2,2])
  top_specialty_oos <- as.integer(df_provider[2,3])
  df_not_val <- as.integer(df_provider[1,6])
  df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
  df_in_scope_val <- total_pathways - df_out_of_scope
  top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
  df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
  
  return(df_provider)
}