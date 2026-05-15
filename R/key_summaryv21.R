#####################################################################
#### Key Summary Table 2 with dates in column names on new line ####
####################################################################

library(reactable)

## there are 9 tables combined to produce key summary table, create 1 by 1.

            ###############################
            ## 1st table is RTT Performance
            ## has 4 columns #########
            ###############################

  ## column 1: is RTT_Monthly Performance in %
rtt_monthly_perfa <- data_RTT_datamarta |>
  filter(grepl("monthly$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "RTT monthly") 

#get max date after filtering 
rtt_monthly_max_date <- max(rtt_monthly_perfa$Reporting_Period)

rtt_monthly_perf <- rtt_monthly_perfa |>
  filter(Reporting_Period == rtt_monthly_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(RTT_monthly = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,RTT_monthly ) |>
  arrange(ICB,`Org Short Name`)

# for sw bottome row
rtt_monthly_perf_sw <- rtt_monthly_perfa |>
  filter(Reporting_Period == rtt_monthly_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(RTT_monthly = Numerator/Denominator) |>
  select(RTT_monthly ) 
    
    ## column 2: is RTT monthly Plan value in % for that month
rtt_monthly_plan_perf <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == rtt_monthly_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_monthly = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,Plans_monthly ) |>
  arrange(ICB,`Org Short Name`) |>
  select(Plans_monthly)
  # for sw bottom row
rtt_monthly_plan_perf_sw <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == rtt_monthly_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by( Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_monthly = Numerator/Denominator) |>
  select(Plans_monthly)

  
   ## column 3: WLMDS performance in % 
rtt_wlmds_perfa <- data_RTTt |>
  filter(Measure == "RTT Performance" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
rtt_wlmds_max_date <- max(rtt_wlmds_perfa$Reporting_Period)

rtt_wlmds_perf <- rtt_wlmds_perfa |>
  filter(Reporting_Period == rtt_wlmds_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS ) |>
  arrange(ICB,`Org Short Name`) |>
  select(WLMDS)
  # for sw bottom row
rtt_wlmds_perf_sw <- rtt_wlmds_perfa |>
  filter(Reporting_Period == rtt_wlmds_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
  select(WLMDS)


## column 4: is RTT wlmds Plan value in % for that month
rtt_wlmds_plan_perf <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(rtt_wlmds_max_date, unit = "month")) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_wlmds = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,Plans_wlmds ) |>
  arrange(ICB,`Org Short Name`) |>
  select(Plans_wlmds)
  #for sw (bottom row)
rtt_wlmds_plan_perf_sw <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(rtt_wlmds_max_date, unit = "month")) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_wlmds = Numerator/Denominator) |>
  select(Plans_wlmds)
  
## Bind all 4 columns to create 1st RTT Performance part of the table.

  rtt_performance <- bind_cols(rtt_monthly_perf, rtt_monthly_plan_perf, 
                               rtt_wlmds_perf, rtt_wlmds_plan_perf )
  # for sw
  rtt_performance_sw <- bind_cols(rtt_monthly_perf_sw, rtt_monthly_plan_perf_sw, 
                                  rtt_wlmds_perf_sw, rtt_wlmds_plan_perf_sw )

############ End of 1st table (RTT Performance) Creation ########################


                ########################################
                ## 2nd table Wait to 1st app performance
                ## has 2 columns ######################
                ######################################

## column 1: is Wait to First performance % of wlmds
wait_to_1st_wlmds_perfa <- data_RTTt |>
  filter(Measure == "Wait to first" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
wait_to_1st_wlmds_max_date <- max(wait_to_1st_wlmds_perfa$Reporting_Period)

wait_to_1st_wlmds_perf <- wait_to_1st_wlmds_perfa |>
  filter(Reporting_Period == wait_to_1st_wlmds_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS ) |>
  arrange(ICB,`Org Short Name`)
# for sw bottom row
wait_to_1st_wlmds_perf_sw <- wait_to_1st_wlmds_perfa |>
  filter(Reporting_Period == wait_to_1st_wlmds_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
 select(WLMDS)

## column 2: wait to first Plan %
wait_to_1st_wlmds_plan_perf <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "Wait to first" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(wait_to_1st_wlmds_max_date, unit = "month")) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_wait_to_1st = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,Plans_wait_to_1st ) |>
  arrange(ICB,`Org Short Name`) |>
  select(Plans_wait_to_1st)
  # for sw
wait_to_1st_wlmds_plan_perf_sw <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "Wait to first" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(wait_to_1st_wlmds_max_date, unit = "month")) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_wait_to_1st = Numerator/Denominator) |>
  select(Plans_wait_to_1st)

## ## Bind all 2 columns to create 2nd 'Wait to first' part of the table.
wait_to_first <- bind_cols(wait_to_1st_wlmds_perf, wait_to_1st_wlmds_plan_perf)
wait_to_first <- wait_to_first |>
  select(WLMDS,Plans_wait_to_1st)
#for sw
wait_to_first_sw <- bind_cols(wait_to_1st_wlmds_perf_sw, wait_to_1st_wlmds_plan_perf_sw)


############ End of 2nd table cols (Wait to 1st) Creation ########################

          ###############################
          ## 3rd table is 52+ week % ####
          ## has 4 columns #############
          ###############################

## column 1: is RTT_Monthly Performance in %
monthly_52plus_week_perfa <- data_RTT_datamarta |>
  filter(grepl("monthly$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "RTT monthly") 

#get max date after filtering 
monthly_52plus_max_date <- max(monthly_52plus_week_perfa$Reporting_Period)

monthly_52plus_week_perf <- monthly_52plus_week_perfa |>
  filter(Reporting_Period == monthly_52plus_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(monthly_52plus = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,monthly_52plus ) |>
  arrange(ICB,`Org Short Name`)
 # for sw bottom row
monthly_52plus_week_perf_sw <- monthly_52plus_week_perfa |>
  filter(Reporting_Period == monthly_52plus_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(monthly_52plus = Numerator/Denominator) |>
  select(monthly_52plus ) 

## column 2: is 52 plus week %, monthly Plan value in % for that month
rtt_monthly_52plus_week_plan_perf <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == monthly_52plus_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_monthly = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,Plans_monthly ) |>
  arrange(ICB,`Org Short Name`) |>
  select(Plans_monthly)
 # for sw bottom row
rtt_monthly_52plus_week_plan_perf_sw <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == monthly_52plus_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_monthly = Numerator/Denominator) |>
  select(Plans_monthly)


## column 3: WLMDS 52 plus week in % 
rtt_wlmds_52plus_week_perfa <- data_RTTt |>
  filter(Measure == "52+ week %" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
wlmds_52plus_max_date <- max(rtt_wlmds_52plus_week_perfa$Reporting_Period)

rtt_wlmds_52plus_week_perf <- rtt_wlmds_52plus_week_perfa |>
  filter(Reporting_Period == wlmds_52plus_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS_52plus = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS_52plus ) |>
  arrange(ICB,`Org Short Name`) |>
  select(WLMDS_52plus)
 # sw for bottom row
rtt_wlmds_52plus_week_perf_sw <- rtt_wlmds_52plus_week_perfa |>
  filter(Reporting_Period == wlmds_52plus_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS_52plus = Numerator/Denominator) |>
  select(WLMDS_52plus)


## column 4: is 52 plus week % Plan value in % for that month
wlmds_52plus_week_plan_perf <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(wlmds_52plus_max_date, unit = "month")) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_52plus = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,Plans_52plus ) |>
  arrange(ICB,`Org Short Name`) |>
  select(Plans_52plus)
 #sw for bottom row
wlmds_52plus_week_plan_perf_sw <- data_RTT_datamarta |>
  filter(grepl("plans$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "Plans") |>
  filter(Reporting_Period == floor_date(wlmds_52plus_max_date, unit = "month")) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(Plans_52plus = Numerator/Denominator) |>
 select(Plans_52plus)


## Bind all 4 columns to create 3rd '52+ week %' part of the table.

fiftytwoplusweeks <- bind_cols(monthly_52plus_week_perf, rtt_monthly_52plus_week_plan_perf,
                               rtt_wlmds_52plus_week_perf,wlmds_52plus_week_plan_perf  )
fiftytwoplusweeks <- fiftytwoplusweeks |>
  select(-ICB, -`Org Short Name`)
 # for sw
fiftytwoplusweeks_sw <- bind_cols(monthly_52plus_week_perf_sw, rtt_monthly_52plus_week_plan_perf_sw,
                               rtt_wlmds_52plus_week_perf_sw,wlmds_52plus_week_plan_perf_sw  )

############ End of 3rd table (52 week % table) Creation ########################


          ##################################
          ## 4th table is Diag Activity ####
          ## has 3 columns ################
          #################################

## column 1: is DM01 activites
dm01_diaga <- data_RTT_datamarta |>
   filter(Measure == "Diagnostic activity" &
           Data_Source == "DM01") 

#get max date after filtering 
dm01_diag_max_date <- max(dm01_diaga$Reporting_Period)

dm01_diag <- dm01_diaga |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`,Metric_Type) |>
  summarise(DM01 = sum(Metric_Value),.groups = "drop") |>
  select(ICB,`Org Short Name`,DM01 ) |>
  arrange(ICB,`Org Short Name`)
 # sw for bottom row
dm01_diag_sw <- dm01_diaga |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(DM01 = sum(Metric_Value),.groups = "drop") |>
  select(DM01) 

## column 2: is DM01 Plans
dm01_plansa <- data_RTT_datamarta |>
  filter(Measure == "Diagnostic activity" &
           Data_Source == "Plans") 

dm01_plans <- dm01_plansa |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`,Metric_Type) |>
  summarise(DM01_plans = sum(Metric_Value),.groups = "drop") |>
  select(ICB,`Org Short Name`,DM01_plans ) |>
  arrange(ICB,`Org Short Name`) |>
  select(DM01_plans)
 # for sw bottom row
dm01_plans_sw <- dm01_plansa |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(DM01_plans = sum(Metric_Value),.groups = "drop") |>
  select(DM01_plans ) 

## column 3: to calculate the '% WL or Planned'
wl_planned_perc <- data_RTT_datamarta |>
  filter(Measure == "Diagnostic activity" &
           Data_Source == "DM01") |>
  filter(Measure_Type != "Unscheduled") |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`,Metric_Type) |>
  summarise(wl_or_plan = sum(Metric_Value),.groups = "drop") |>
  select(ICB,`Org Short Name`, wl_or_plan ) |>
  arrange(ICB,`Org Short Name`) |>
  select(wl_or_plan)
  # for sw bottom row
wl_planned_perc_sw <- data_RTT_datamarta |>
  filter(Measure == "Diagnostic activity" &
           Data_Source == "DM01") |>
  filter(Measure_Type != "Unscheduled") |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(Metric_Type, Metric_Value) |>
  group_by(Metric_Type) |>
  summarise(wl_or_plan = sum(Metric_Value),.groups = "drop") |>
  select(wl_or_plan ) 


## Bind all 3 columns to create 4th table 'Diagnostic activity' part of the table, calculate % and remove extra col.

 diagnostic_activity <- bind_cols(dm01_diag,dm01_plans,wl_planned_perc) 
 diagnostic_activity <- diagnostic_activity |>
   mutate(wl_or_planned_perc = wl_or_plan/DM01) |>
   select(-wl_or_plan) |>
   select(-ICB, - `Org Short Name`)
 # for sw (all the 3 cols under diagnostic activtiy for final row)
 diagnostic_activity_sw <- bind_cols(dm01_diag_sw,dm01_plans_sw,wl_planned_perc_sw) 
 diagnostic_activity_sw <- diagnostic_activity_sw |>
   mutate(wl_or_planned_perc = (wl_or_plan/dm01_diag_sw$DM01)) |>
   select(-wl_or_plan) 
  
   
 ############ End of 4th table (Diagnostic activity table) Creation ########################   
   
 
           #####################################
           ## 5th table is A&G: Pre referral ###
           ## has 3 columns ####################
           #####################################
 ## column 1: is utilization 
 ag_utilisationa <- data_RTT_datamarta |>
     filter(Measure == "Spec Advice utilisation - pre referral")
 
 #get max date after filtering 
 ag_utilisation_max_date <- max(ag_utilisationa$Reporting_Period)
 
 ag_utilisation <- ag_utilisationa |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Utilisation = (Numerator/Denominator)) |>
   select(ICB,`Org Short Name`, Utilisation ) |>
   arrange(ICB,`Org Short Name`) 
   # for sw bottom row
 ag_utilisation_sw <- ag_utilisationa |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(Metric_Type, Metric_Value) |>
   group_by(Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Utilisation = (Numerator/Denominator)) |>
   select(Utilisation ) 
  
 

  ## column 2: is diversion %
 ag_diversiona <- data_RTT_datamarta |>
   filter(Measure == "Spec Advice diversion - pre referral")
 
 #get max date after filtering 
 ag_diversion_max_date <- max(ag_diversiona$Reporting_Period)
 
 ag_diversion <- ag_diversiona |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Diversion = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, Diversion) |>
   arrange(ICB,`Org Short Name`) |>
   select(Diversion)
   # for sw
 ag_diversion_sw <- ag_diversiona |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(Metric_Type, Metric_Value) |>
   group_by(Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Diversion = Numerator/Denominator) |>
   select(Diversion) 
 
 ## Bind all 2 columns to create 5th table 'A & G: Pre referral' part of the table
 AG_pre_referral <- bind_cols(ag_utilisation,ag_diversion)
 AG_pre_referral <- AG_pre_referral |>
   select(-ICB, -`Org Short Name`)
 # for sw
 AG_pre_referral_sw <- bind_cols(ag_utilisation_sw,ag_diversion_sw)
 
 ############ End of 5th table (A & G: Pre referral table) Creation ########################  
 
 
             #######################################
             ## 6th table is 12+ week validation ###
             ## has 1 columns ######################
             #######################################
 twelve_plus_week_vala <- data_RTTt |>
   filter(Measure == "12+ week validation" &
            Data_Source == "WLMDS RTT") 
 
 #get max date after filtering 
 twelve_plus_week_val_max_date <- max(twelve_plus_week_vala$Reporting_Period)
 
 twelve_plus_week_val <- twelve_plus_week_vala |>
   filter(Reporting_Period == twelve_plus_week_val_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(WLMDS_12plus_week_val = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, WLMDS_12plus_week_val) |>
   arrange(ICB,`Org Short Name`) |>
   select(-ICB, -`Org Short Name` )
  # for sw
 twelve_plus_week_val_sw <- twelve_plus_week_vala |>
   filter(Reporting_Period == twelve_plus_week_val_max_date) |>
   select(Metric_Type, Metric_Value) |>
   group_by(Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(WLMDS_12plus_week_val = Numerator/Denominator) |>
   select(WLMDS_12plus_week_val)
 
 ############ End of 6th table (12 + week validation WLMDS) Creation ########################   
 
 
 
             #######################################
             ## 7th table is Missed appointments ###
             ## has 1 columns ######################
             #######################################
 
 ## column 1: SUS_OPA
 missed_appta <- data_RTT_datamarta |>
   filter(Measure == "Missed appointments")
 
 #get max date after filtering 
 missed_appt_max_date <- max(missed_appta$Reporting_Period)
 
 missed_appt <- missed_appta |>
   filter(Reporting_Period == missed_appt_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(SUS_OPA = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, SUS_OPA ) |>
   arrange(ICB,`Org Short Name`) |>
   select(-ICB, - `Org Short Name`)
   # for sw bottom row
 missed_appt_sw <- missed_appta |>
   filter(Reporting_Period == missed_appt_max_date) |>
   select(Metric_Type, Metric_Value) |>
   group_by(Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(SUS_OPA = Numerator/Denominator) |>
   select(SUS_OPA)
 
 ############ End of 7th table (Missed appointments table) Creation ########################   
 
 #######################################
 ## 8th table is PIFU utilisation ###
 ## has 2 columns ######################
 #######################################
 
 ## column 1: EROC/SUS_OPA (numerator and denomirator coming from different data sources!)
 
 # get numerator for col 1
 pifu_eroc_sus_opa_numa <- data_RTT_datamarta |>
   filter(Measure == "PIFU utilisation" &
            Data_Source == "Provider EROC" &
            Metric_Type == "Numerator")
  #get max date after filtering 
 pifu_eroc_sus_opa_num_max_date <- max(pifu_eroc_sus_opa_numa$Reporting_Period)
 
 pifu_eroc_sus_opa_num <- pifu_eroc_sus_opa_numa |>
   filter(Reporting_Period == pifu_eroc_sus_opa_num_max_date) |>
   select(ICB,`Org Short Name`,  Metric_Value) |>
   group_by(ICB, `Org Short Name`) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Numerator = Metric_Value) |>
   select(ICB,`Org Short Name`, Numerator) |>
   arrange(ICB,`Org Short Name`) 
   # for sw bottom row
 pifu_eroc_sus_opa_num_sw <- pifu_eroc_sus_opa_numa |>
   filter(Reporting_Period == pifu_eroc_sus_opa_num_max_date) |>
   select(Metric_Value) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Numerator = Metric_Value) |>
   select( Numerator) 
  
 
 # get denominator for col 1
 pifu_eroc_sus_opa_denoma <- data_RTT_datamarta |>
   filter(Measure == "PIFU utilisation" &
            Data_Source == "SUS OPA" &
            Metric_Type == "Denominator")
 #get max date after filtering 
 pifu_eroc_sus_opa_denom_max_date <- max(pifu_eroc_sus_opa_denoma$Reporting_Period)
 
 pifu_eroc_sus_opa_denom <- pifu_eroc_sus_opa_denoma |>
   filter(Reporting_Period == pifu_eroc_sus_opa_denom_max_date) |>
   select(ICB,`Org Short Name`,  Metric_Value) |>
   group_by(ICB, `Org Short Name`) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Denominator = Metric_Value) |>
   select(ICB,`Org Short Name`, Denominator) |>
   arrange(ICB,`Org Short Name`) |>
   select(`Org Short Name`, Denominator)
   # for sw
 pifu_eroc_sus_opa_denom_sw <- pifu_eroc_sus_opa_denoma |>
   filter(Reporting_Period == pifu_eroc_sus_opa_denom_max_date) |>
   select(ICB,`Org Short Name`,  Metric_Value) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Denominator = Metric_Value) |>
   select(Denominator) 
  
 ## get the numerator and denominator together to calculate the % 
 #pifu_eroc_sus_opa <- bind_cols( pifu_eroc_sus_opa_num, pifu_eroc_sus_opa_denom)
 
 ## got error in bind_cols and both tables have diff num of rows, so try join instead
 pifu_eroc_sus_opa <- left_join(pifu_eroc_sus_opa_num,pifu_eroc_sus_opa_denom, by = "Org Short Name")
 pifu_eroc_sus_opa <- pifu_eroc_sus_opa |>
   mutate(EROC_SUS_OPA = Numerator/Denominator) |>
   select(-Numerator, - Denominator)
   # for sw
 pifu_eroc_sus_opa_sw <- cbind(pifu_eroc_sus_opa_num_sw,pifu_eroc_sus_opa_denom_sw)
 pifu_eroc_sus_opa_sw <- pifu_eroc_sus_opa_sw |>
   mutate(EROC_SUS_OPA = Numerator/Denominator) |>
   select(-Numerator, - Denominator)

 
 ## column 2: PIFU utilization Plans
 pifu_utilisation_plan <- data_RTT_datamarta |>
    filter(Measure == "PIFU utilisation" &
            Data_Source == "Plans") |>
   filter(Reporting_Period == pifu_eroc_sus_opa_denom_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(plan_pifu_utilisation = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, plan_pifu_utilisation ) |>
   arrange(ICB,`Org Short Name`) |>
   select(`Org Short Name`, plan_pifu_utilisation)
  # for sw bottom row
 pifu_utilisation_plan_sw <- data_RTT_datamarta |>
   filter(Measure == "PIFU utilisation" &
            Data_Source == "Plans") |>
   filter(Reporting_Period == pifu_eroc_sus_opa_denom_max_date) |>
   select(Metric_Type, Metric_Value) |>
   group_by(Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(plan_pifu_utilisation = Numerator/Denominator) |>
   select(plan_pifu_utilisation) 
  

 ## Bind all 2 columns to create 5th table 'A & G: Pre referral' part of the table 
 #pifu_utilisation <- bind_cols(pifu_eroc_sus_opa, pifu_utilisation_plan)
 pifu_utilisation <- full_join(pifu_eroc_sus_opa, pifu_utilisation_plan, by = "Org Short Name")
  ## again bec of diff no of rows (somerset data missing for nume above) use join instead of bind
  pifu_utilisation  <- pifu_utilisation  |>
   select(-ICB, - `Org Short Name`)
  # for sw bottom row
  pifu_utilisation_sw <- cbind(pifu_eroc_sus_opa_sw, pifu_utilisation_plan_sw)
 
 
 ############ End of 8th table (PIFU Utilisation) Creation ######################## 
 
 
 ################################################
 ## 9th table is Capped theater utilization % ###
 ## has 1 columns ##############################
 ###############################################
 
 #theatre_utilisation <- data_mhst |>
  # filter(Measure == "Capped theatre utilisation %" &
   #         Metric_Type != "Calculated %")
 
 #theatre_max_date <- max(theatre_utilisation$Reporting_Period)
 
 
 #theatre_utilisation <- theatre_utilisation |>
#   filter(Reporting_Period >= (theatre_max_date - weeks(11))) |>     ## to filter the data for 12 weeks to max date.
#   select(ICB,`Org name`, Metric_Type, Metric_Value) |>
#   group_by(ICB, `Org name`, Metric_Type) |>
#   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
#   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
#   mutate(NTDC = Numerator/Denominator) |>
 #  select(ICB,`Org name`, NTDC ) |>
  # arrange(ICB,`Org name`) |>
   #select(-ICB, - `Org name`)
   
############ End of 9th table (theater utilization) Creation ###########################
 
## the names of all 9 tables created above: rtt_performance, wait_to_first, fiftytwoplusweeks, 
## diagnostic_activity, AG_pre_referral, twelve_plus_week_val, missed_appt, pifu_utilisation, 
## theatre_utilisation 

 
           ###############################
           ## bind all 9 tables above ###
           ##############################
  
key_summary_maint <- bind_cols(rtt_performance, wait_to_first, fiftytwoplusweeks, 
                               diagnostic_activity, AG_pre_referral, twelve_plus_week_val, 
                               missed_appt, pifu_utilisation)#,theatre_utilisation ) 
  # for sw bottom row
  key_summary_maint_sw <- bind_cols(rtt_performance_sw, wait_to_first_sw, fiftytwoplusweeks_sw, 
                                 diagnostic_activity_sw, AG_pre_referral_sw, twelve_plus_week_val_sw, 
                                 missed_appt_sw, pifu_utilisation_sw)
  # add 1st 2 cols before row binding with main table.
  key_summary_maint_sw <- key_summary_maint_sw |>
    mutate(ICB = "",
           `Org Short Name` = "South West") |>
    select(ICB,`Org Short Name`, everything()) |>
    rename(Plans_monthly...4 = Plans_monthly...2,
           WLMDS...5 = WLMDS...3,
           WLMDS...7 = WLMDS...5,
           Plans_monthly...10 = Plans_monthly...8
           )
  
 key_summary_main_full <- rbind(key_summary_maint,key_summary_maint_sw)
  
 ## rename column names as in excel table
 key_summary_main <- key_summary_main_full |>
   rename(ICB = ICB,
          Organisation = `Org Short Name`,
          # RTT Performance table
          RTT_monthly = RTT_monthly,
          #`RTT monthly` = RTT_monthly,
          Plans_RTT_mthly = Plans_monthly...4,
        #  Plans = Plans_monthly...4,
          WLMDS_RTT_weekly = WLMDS...5,
          Plan_RTT_weekly = Plans_wlmds,
          # Wait to first table
          WLMDS_wait_to_1st = WLMDS...7,
          Plan_wait_to_1st = Plans_wait_to_1st,
          # 52+ week table
          RTT_monthly_52plus = monthly_52plus,
          Plans_52plus_mthly = Plans_monthly...10,
          WLMDS_52plus = WLMDS_52plus,
          Plans_52plus_weekly = Plans_52plus,
          # Diagnostic activity
          DM01 = DM01,
          Plans_diag = DM01_plans,
          WL_or_Planned_perc_diag = wl_or_planned_perc,
          # A&G: Pre referral
          Utilisation = Utilisation,
          Diversion = Diversion,
          # 12+ week validation
          WLMDS_12plus_week_val = WLMDS_12plus_week_val,
          # Missed appointments
          SUS_OPA = SUS_OPA,
          # PIFU Utilisation
          EROC_SUS_OPA = EROC_SUS_OPA,
          Plan_pifu_utilisation = plan_pifu_utilisation)
          # Capped theatre utilisation %
          #NTDC = NTDC
        #  )

 
 #########################################################
 ##### Prepare table for html MAIN file ######################
 #########################################################
 
 

  ## Now create a gt table to render in html file with all the formatings
    key_summary_gt <- key_summary_main |>  
  
   gt() |>
   
   #cols_label(!!!labels) |>
      
 # tab_options(html_escape = FALSE) |>    
   
   #tab_header(title = "Key Summary Table") |>
   fmt_auto() |>
   sub_missing() |>
   opt_row_striping() |>
   fmt_percent(columns = 3, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 4, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 5, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 6, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 7, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 8, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 9, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 10, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 11, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 12, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 15, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 16, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 17, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 18, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 19, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 20, decimals = 1, scale_values = TRUE) |>
   fmt_percent(columns = 21, decimals = 1, scale_values = TRUE) |>
   #fmt_percent(columns = 22, decimals = 1, scale_values = TRUE) |>
   tab_style(
     style = cell_borders(sides="all",color="gray",weight = 1),
     locations = cells_body()
   ) |>
   cols_align(align = "left", columns = c("Organisation")) |>
   ## color the 1st Col
   data_color(
     columns = c("Organisation"),
     colors = "#005eb8"
     #colors = parameter_NHS_Blue  
   ) |>
   data_color(
     columns = c("ICB"),
     colors = "#005eb8"
     #colors = parameter_NHS_Blue  
   ) |>
   
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(rows = nrow(key_summary_main))
  ) |>
   
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
     locations = cells_body(rows=nrow(key_summary_main)-1)
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
     locations = cells_body(rows=nrow(key_summary_main))
   ) |>
   
   tab_style(
     style = list(
       cell_borders(
         sides = "right", 
         weight = px(2),  # 3px for a thicker border
         #color = "black"
         color = parameter_NHS_Blue
       )
     ),
     locations = cells_body(columns=c(6,8,12,15,17:19,21))) |>#,22))) |>
   
   tab_options(column_labels.border.top.color = parameter_NHS_Blue,
               column_labels.border.bottom.color = parameter_NHS_Blue,
               table_body.border.bottom.color = parameter_NHS_Blue,
               column_labels.background.color = parameter_NHS_Blue,
               column_labels.font.weight = 'bold') |> #%>% #add NHS blue coloring   
   
  # cols_label(RTT_monthly = "RTT monthly") |>
   
   ## fill the particular cells green if their %age is more than Plan (which is another col)
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 3,
       rows = key_summary_main[[3]] > key_summary_main[[4]]
     )
   )  |>
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 5,
       rows = key_summary_main[[5]] > key_summary_main[[6]]
     )
   )  |>
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 7,
       rows = key_summary_main[[7]] > key_summary_main[[8]]
     )
   )  |>
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 9,
       rows = key_summary_main[[9]] <= key_summary_main[[10]]
     )
   )  |>
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 11,
       rows = key_summary_main[[11]] <= key_summary_main[[12]]
     )
   )  |>
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 13,
       rows = key_summary_main[[13]] <= key_summary_main[[14]]
     )
   )  |>
   
   tab_style(
     style = cell_fill(color = "#E2EFDA"),
     locations = cells_body(
       columns = 20,
       rows = key_summary_main[[20]] > key_summary_main[[21]]
     )
   )  |>
   
   # give same names to the multiple cols according to requirements
   
   cols_label(
     RTT_monthly = "RTT",
     Plans_RTT_mthly = "Plans",
     WLMDS_RTT_weekly = "WLMDS",
     Plan_RTT_weekly = "Plans",
     WLMDS_wait_to_1st = "WLMDS",
     Plan_wait_to_1st = "Plans",
     RTT_monthly_52plus = "RTT",
     Plans_52plus_mthly = "Plans",
     WLMDS_52plus = "WLMDS",
     Plans_52plus_weekly = "Plans",
     Plans_diag = "Plans",
     WL_or_Planned_perc_diag = "% WL or Planned",
     WLMDS_12plus_week_val = "WLMDS",
     SUS_OPA = "SUS OPA",
     EROC_SUS_OPA = "EROC SUS OPA",
     Plan_pifu_utilisation = "Plans"
     
   ) |>

  ## add the main headings for each secion in the table. 
   tab_spanner(
     label = "RTT Performance",
     columns = c(colnames(key_summary_main)[3], colnames(key_summary_main)[4],
                    colnames(key_summary_main)[5],colnames(key_summary_main)[6])) |>
   tab_spanner(
     label = "Wait to first",
     columns = c(colnames(key_summary_main)[7], colnames(key_summary_main)[8])) |>
   tab_spanner(
     label = "52+ week %",
     columns = c(colnames(key_summary_main)[9], colnames(key_summary_main)[10],
                    colnames(key_summary_main)[11], colnames(key_summary_main)[12]))|>
   tab_spanner(
     label = "Diagnostic activity",
     columns = c(colnames(key_summary_main)[13], colnames(key_summary_main)[14],
                    colnames(key_summary_main)[15])) |>
    tab_spanner(
     label = "A&G: Pre referral",
     columns = c(colnames(key_summary_main)[16], colnames(key_summary_main)[17]))|>
   tab_spanner(
     label = "12+ week validation",
     columns = c(colnames(key_summary_main)[18]))|>
   tab_spanner(
     label = "Missed appt",
     columns = c(colnames(key_summary_main)[19]))|>
   tab_spanner(
     label = "PIFU utilisation",
     columns = c(colnames(key_summary_main)[20], colnames(key_summary_main)[21]))|>
 #  tab_spanner(
  #   label = "Capped theatre utilisation %",
   #  columns = c(colnames(key_summary_main)[22])) |>
   
   tab_source_note(
     source_note = md(
       paste0(
         "**Note:** Green cells represent values better than plans.<br>",
         "Diagnostic activity section has planning modalities only.<br>",
         "Capped theatre utilisation % is 12 week to w/e ",
         format(theatre_data_date_max, "%d-%b-%y"), "<br>",
         "**Key Dates:**<br>",
         "RTT: RTT monthly published statistics for ", format(rtt_monthly_max_date, "%b-%y"), "<br>",
         "WLMDS: WLMDS weekly management information for w/e ", format(rtt_wlmds_max_date, "%d-%b-%y"), "<br>",
         "DM01: Monthly diagnostics waiting times and activtiy for ", format(dm01_diag_max_date, "%b-%y"), "<br>",
         "Specialist advice utilisation and diversion for ", format(ag_utilisation_max_date, "%b-%y"), "<br>",
         "Missed appointments for ", format(missed_appt_max_date, "%b-%y"), "<br>",
         "PIFU: Patient Initiated follow-up utilisation for ", format(missed_appt_max_date, "%b-%y")
       )
     )
   ) |>
 
   tab_options(
     table.font.size = px(11),
     source_notes.font.size = px(12),
     column_labels.padding = px(2),
     table.font.names = "Arial"
   ) |>
   tab_style(
     style = cell_text(align = "center"),
     locations = cells_body(columns = where(is.numeric))
   )
 
      
  #display table 
   
 key_summary_gt
 
 
 
 
 