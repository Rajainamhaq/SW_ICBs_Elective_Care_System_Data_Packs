################################################################################
### Functions for making the financial year dynamic within other functions  ####
################################################################################

#   Call_all_functions_auto_fy_change.R

source(here("R","get_current_fy_digits.R"))
source(here("R","get_fy_end_march_start.R"))
source(here("R","get_current_fy_plans_label.R"))
source(here("R","get_fy_start.R"))
source(here("R","get_last_two_fy_labels_wlmds.R"))
source(here("R","get_last_two_fy_labels_monthly.R"))
source(here("R","get_last_two_fy_start.R"))
source(here("R","get_mar_target_label.R"))

source(here("R","get_current_fy_target.R"))
source(here("R","get_current_fy_baseline.R"))

source(here("R","fy_colour_scale_wlmds_only.R"))
source(here("R","fy_linetype_scale_wlmds_only.R"))

source(here("R","fy_colour_scale_mthly_spec_adv.R"))
source(here("R","fy_linetype_scale_mthly_spec_adv.R"))

#Below 2 functions are used in both PIFU and missed apointment line graphs not only missed appt as name indicates.
source(here("R","fy_colour_scale_missed_appt.R"))
source(here("R","fy_linetype_scale_missed_appt.R"))

# functions for Cancer metrics
source(here("R","fy_colour_scale_cancer.R"))
source(here("R","fy_linetype_scale_cancer.R"))

# functions for diagnostics
source(here("R","fy_colour_scale_diagperf.R"))
source(here("R","fy_linetype_scale_diagperf.R"))

