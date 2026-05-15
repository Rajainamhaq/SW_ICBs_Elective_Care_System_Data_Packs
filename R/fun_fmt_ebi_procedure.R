####################################################################################
####### table formatting for Spec Adv for Pre referral Utilisation ####
####################################################################################
fun_fmt_ebi_procedure <- function(data_proc_tab) {
  
  ## 1st get the max date for foot note
  max_date_proc_ext <- data_mhst |>
    filter(Measure == "EBI Procedures")
    date_pro <- max(max_date_proc_ext$Reporting_Period,na.rm =TRUE)
  
# change National median value to numeric for formatting
    data_proc_tab$`National median` <- as.numeric(data_proc_tab$`National median`)
    
  
    data_proc_tab |>
    dplyr::mutate(across(2:3, ~ na_if(.x, 0))) |>  
    gt()  |>                 # put into a gt table
    tab_header(title = NULL) |> 
    
    fmt_auto() |>   #auto format the columns - changes to comma sep values for large numbers
    sub_missing() |> # present NA values as a -
    opt_row_striping() |>    # stripe the rows grey / white to make it easier to read
    # format col 6&7 e.g. rename and add %
    fmt_number(columns = c(2,3), decimals = 0) |>
     

    tab_style(
      style = cell_borders(sides="all",color="gray",weight = 1),
      locations = cells_body()
    ) |>
      
    cols_label(Organisational_value = "Organisation value") |>  
      
   
     tab_footnote(
        footnote = md(paste0("Table cell is highlighted green if value is less than National median
            \nData source: SUS APCS for ",
            format(date_pro, "%b-%y"))
        )
      ) |>
    
  #  cols_label(
   #   Organisational_value = "Organisation value") |>
    
    
    tab_options(column_labels.border.top.color = parameter_NHS_Blue,
                column_labels.border.bottom.color = parameter_NHS_Blue,
                table_body.border.bottom.color = parameter_NHS_Blue,
                column_labels.background.color = parameter_NHS_Blue,
                column_labels.font.weight = 'bold') |> #%>% #add NHS blue coloring   
     
     # highlight Org's value if less than median 
      tab_style(
        style = cell_fill(color = "#E2EFDA"),
        locations = cells_body(
          columns = 2,
          rows = Organisational_value < `National median`
        ) ) |>
      
     # dplyr::mutate(across(2:3, ~ na_if(.x, 0))) |>
      fmt_number(columns = 2:3, decimals = 0) |>
      sub_missing(columns = 2:3, missing_text = "-")
      
      #fmt(
      #  columns = where(is.numeric),
      #  fns = function(x) ifelse(x == 0, "-", x)
      #) 
    
}
