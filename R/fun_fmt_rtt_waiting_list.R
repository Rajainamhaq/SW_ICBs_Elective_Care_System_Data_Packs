####################################################################################
####### table formatting WL and Clocks ####
####################################################################################
fun_fmt_rtt_waiting_list <- function(wl_and_clocks) {
  
  ## set dates form table column names
   latest_mth_chr <- as.character(format(max_date_RTT_Monthly,"%b-%y"))
  latest_mth_prev_yr_chr <- as.character(format((max_date_RTT_Monthly %m-% years(1)),"%b-%y"))
    # get two year back date for clock starts/stop

  wl_and_clocks |>
    gt()  |>                 # put into a gt table
   
    # tab_header(title = "Spec Advice diversion - pre referral by specialty") |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
  
    fmt_percent(columns = c(4,7,10), decimals = 1, scale_values = FALSE) |>
    
    cols_label(June24_rtt = latest_mth_prev_yr_chr) |>
    cols_label(June24_starts = latest_mth_prev_yr_chr) |>
    cols_label(June24_stops = latest_mth_prev_yr_chr) |>
    cols_label(Growth_rtt = "Growth") |>
    
    cols_label(June25_rtt = latest_mth_chr) |>
    cols_label(June25_starts = latest_mth_chr) |>
    cols_label(June25_stops = latest_mth_chr) |>
    cols_label(Growth_starts = "Growth") |>
    cols_label(Growth_stops = "Growth") |>
    
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
      rows = nrow(wl_and_clocks))
  ) |>
    
    #### make bottom row of each col bold#####
  # col2
  tab_style(
    style = cell_text(
      color="black",
      weight = "bold"),
    locations = cells_body(
      columns = c(2,3,4,5,6,7,8,9,10),
      rows = nrow(wl_and_clocks))
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
    locations = cells_body(rows=nrow(wl_and_clocks)-1)
  ) |>
    
   # tab_footnote(
    #  footnote = md(paste0("Data source: RTT monthly to ",format(max_date_RTT_Monthly,"%b-%y"),
     #                      "\n,Clock starts and stops are shown as 12 month activity to ",latest_mth_prev_yr_chr,
      #                     " and ",format(max_date_RTT_Monthly,"%b-%y")))
  #  ) |>
    
    tab_footnote(
      footnote = md(
        paste0(
          "Data source: RTT monthly published statistics to ", format(max_date_RTT_Monthly, "%b-%y"),
          "<br>",
          "Clock starts and stops are shown as 12 month activity to ",
          latest_mth_prev_yr_chr,
          " and ",
          format(max_date_RTT_Monthly, "%b-%y")
        )
      )
    ) |>
    
    
    data_color(
      columns = Growth_rtt,
      rows = Specialty != "All specialties",    # or whatever your last row is
      colors = scales::col_bin(
        palette = c("#E2EFDA","#FFD749",  "#ffc7ce"),
        bins = c(-Inf, 0, Inf)
      )
    )    |>
    
    # for thicker lines separating cols
    tab_style(
      style = list(
        cell_borders(
          sides = "right", 
          weight = px(2),  # 3px for a thicker border
          #color = "black"
          color = parameter_NHS_Blue
        )
      ),
      locations = cells_body(columns=c(4,7,10))) |>
    
    
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold') |> #%>% #add NHS blue coloring   
    
    
    tab_spanner(
      #label = gt::html("<span style='white-space:nowrap;'>Total waiting list</span>"),
      label = "Total waiting list",
      columns = c(colnames(wl_and_clocks)[2],
                  colnames(wl_and_clocks)[3],
                  colnames(wl_and_clocks)[4])) |>
    tab_spanner(
      label = gt::html("<span style='white-space:nowrap;'>Clock starts (12 months)</span>"),
     # label = "Clock starts (12 months)",
      columns = c(colnames(wl_and_clocks)[5],
                  colnames(wl_and_clocks)[6],
                  colnames(wl_and_clocks)[7])) |>
    tab_spanner(
      label = gt::html("<span style='white-space:nowrap;'>Clock stops (12 months)</span>"),
      #label = "Clock stops (12 months)",
      columns = c(colnames(wl_and_clocks)[8],
                  colnames(wl_and_clocks)[9],
                  colnames(wl_and_clocks)[10]))   |>
    
    tab_style(
      style = cell_text(size = px(12)),   # or "14px"
      locations = cells_body() 
        ) |>
    tab_style(
      style = cell_text(size = px(14)),
      locations = cells_column_labels()
    ) |>
    
    fmt_number(
      columns = c(5,6,8,9),
      decimals = 0,
      use_seps = TRUE
    )               
    
}
