    ####################################################################################
  ####### table formatting for Validation of pathways currently waiting 12+ weeks ####
  ####################################################################################
  fun_fmt_Cohort_65Weeks <- function(Total_65plus_cohort) {
    
    Total_65plus_cohort
    Total_65plus_cohort |>
      gt()  |>                 # put into a gt table
      tab_header(title = "Number of pathways who will be waiting 65 weeks at the end of Jun-25 for treatment",
                 subtitle = md(paste("WLMDS for w/e",week_ending))) |> 
      
      fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
      sub_missing() |> # present NA values as a -
      opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
      fmt_percent(columns = 12, decimals = 1, scale_values = FALSE) |>
      cols_label(First_OP_EoMar_Perc = "% 1st_OP dated by end_of_Jun-25") |>
      fmt_percent(columns = 13, decimals = 1, scale_values = FALSE) |>
      cols_label(cohort_sched_Perc = "% cohort seen or scheduled") |>
      
      
      tab_style(
        style = cell_borders(sides="all",color="gray",weight = 1),
        locations = cells_body()
      ) |>
      
      cols_align(align = "center", columns = vars("Specialty")) |>
      ## color the 1st Col
      data_color(
        columns = vars("Specialty"),
        colors = "#005eb8"
        #colors = parameter_NHS_Blue  
      ) |>
      ## highlight the medium and high percentages of not validated  
      # data_color(
      #   columns = vars("Percent_not_val"),
      #  colors = scales::col_bin(
      #    palette = c("orange","red"),
      #     bins = c(10,15,100)
      #   ),
      # apply_to = "text"
      # ) |>
      
      #   tab_style(
      #  style = cell_text(
      #   color="white",
      #     weight = "bold"),
      #   locations = cells_body(
      #     columns = 1,
      #    rows = nrow(Total_65plus_cohort)-1)
      # ) |>
      
      tab_style(
        style = cell_text(
          color="white",
          weight = "bold"),
        locations = cells_body(
          columns = 1,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      #### make bottom row of each col bold#####
    
    # col2
    tab_style(
      style = cell_text(
        color="black",
        weight = "bold"),
      locations = cells_body(
        columns = 2,
        rows = nrow(Total_65plus_cohort))
    ) |>
      # col3
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 3,
          rows = nrow(Total_65plus_cohort))
      ) |>
      # col 4
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 4,
          rows = nrow(Total_65plus_cohort))
      ) |>
      # col 5
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 5,
          rows = nrow(Total_65plus_cohort))
      ) |>
      # col 6
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 6,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 7
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 7,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 8
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 8,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 9
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 9,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 10
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 10,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 11
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 11,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 12
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 12,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 13
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 13,
          rows = nrow(Total_65plus_cohort))
      ) |>
      
      # col 14
      tab_style(
        style = cell_text(
          color="black",
          weight = "bold"),
        locations = cells_body(
          columns = 14,
          rows = nrow(Total_65plus_cohort))
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
      locations = cells_body(rows=nrow(Total_65plus_cohort)-1)
    ) |>
      
      ###############################
    
    tab_footnote(
      footnote = md(paste("English commissioned pathways only
                  \nData Source: WLMDS for w/e:", week_ending))
    ) |>
      tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                  column_labels.border.bottom.color = parameter_NHS_Blue,
                  table_body.border.bottom.color = parameter_NHS_Blue,
                  column_labels.background.color = parameter_NHS_Blue,
                  column_labels.font.weight = 'bold') #%>% #add NHS blue coloring |>
    
    
  }