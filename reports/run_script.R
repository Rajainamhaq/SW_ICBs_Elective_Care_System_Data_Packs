if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',writexl, 
               reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2,openxlsx,quarto)
library(quarto)
library(here)

#setwd("C:/Users/raja.haq1/Documents/GitHub/Elective_Care_System_Data_Packs/reports")
#here()

################################################################################
## below script does include the date at then end of the output html file by 
## preserving all the css formatting and tab settings.
################################################################################
files <- c(
  "reports/Elective_Care_System_Data_Pack_BNSSG.qmd",
  "reports/Elective_Care_System_Data_Pack_BSW.qmd",
  "reports/Elective_Care_System_Data_Pack_Cornwall.qmd",
  "reports/Elective_Care_System_Data_Pack_Devon.qmd",
  "reports/Elective_Care_System_Data_Pack_Dorset.qmd",
  "reports/Elective_Care_System_Data_Pack_Glos.qmd",
  "reports/Elective_Care_System_Data_Pack_Somerset.qmd"
)
################################################################################
for (f in files) {
  
  base_name <- tools::file_path_sans_ext(basename(f))
  
  output_name <- sprintf(
    "%s_%s.html",
    base_name,
    Sys.Date()
  )
  
  quarto::quarto_render(
    input = normalizePath(f),
    output_file = output_name
  )
}
