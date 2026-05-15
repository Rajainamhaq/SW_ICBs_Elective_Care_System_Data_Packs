##############################################################################
#### Key Summary Table with dynamic dates on same line as column name ########
#############################################################################

library(reactable)

## there are 9 tables combined to produce key summary table, create 1 by 1.

            ###############################
            ## 1st table is RTT Performance
            ## has 4 columns #########
            ###############################

  ## column 1: is RTT_Monthly Performance in %
rtt_monthly_perf <- data_RTT_datamarta |>
  filter(grepl("monthly$",FY)) |>
  filter(Measure == "RTT Performance" &
           Data_Source == "RTT monthly") 

#get max date after filtering 
rtt_monthly_max_date <- max(rtt_monthly_perf$Reporting_Period)

rtt_monthly_perf <- rtt_monthly_perf |>
  filter(Reporting_Period == rtt_monthly_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(RTT_monthly = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,RTT_monthly ) |>
  arrange(ICB,`Org Short Name`)
    
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
  
   ## column 3: WLMDS performance in % 
rtt_wlmds_perf <- data_RTTt |>
  filter(Measure == "RTT Performance" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
rtt_wlmds_max_date <- max(rtt_wlmds_perf$Reporting_Period)

rtt_wlmds_perf <- rtt_wlmds_perf |>
  filter(Reporting_Period == rtt_wlmds_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS ) |>
  arrange(ICB,`Org Short Name`) |>
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
  
## Bind all 4 columns to create 1st RTT Performance part of the table.

  rtt_performance <- bind_cols(rtt_monthly_perf, rtt_monthly_plan_perf, 
                               rtt_wlmds_perf, rtt_wlmds_plan_perf )

############ End of 1st table (RTT Performance) Creation ########################


                ########################################
                ## 2nd table Wait to 1st app performance
                ## has 2 columns ######################
                ######################################

## column 1: is Wait to First performance % of wlmds
wait_to_1st_wlmds_perf <- data_RTTt |>
  filter(Measure == "Wait to first" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
wait_to_1st_wlmds_max_date <- max(wait_to_1st_wlmds_perf$Reporting_Period)

wait_to_1st_wlmds_perf <- wait_to_1st_wlmds_perf |>
  filter(Reporting_Period == wait_to_1st_wlmds_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS ) |>
  arrange(ICB,`Org Short Name`)

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

## ## Bind all 2 columns to create 2nd 'Wait to first' part of the table.
wait_to_first <- bind_cols(wait_to_1st_wlmds_perf, wait_to_1st_wlmds_plan_perf)
wait_to_first <- wait_to_first |>
  select(WLMDS,Plans_wait_to_1st)


############ End of 2nd table cols (Wait to 1st) Creation ########################

          ###############################
          ## 3rd table is 52+ week % ####
          ## has 4 columns #############
          ###############################

## column 1: is RTT_Monthly Performance in %
monthly_52plus_week_perf <- data_RTT_datamarta |>
  filter(grepl("monthly$",FY)) |>
  filter(Measure == "52+ week %" &
           Data_Source == "RTT monthly") 

#get max date after filtering 
monthly_52plus_max_date <- max(monthly_52plus_week_perf$Reporting_Period)

monthly_52plus_week_perf <- monthly_52plus_week_perf |>
  filter(Reporting_Period == monthly_52plus_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(monthly_52plus = Numerator/Denominator) |>
  select(ICB,`Org Short Name`,monthly_52plus ) |>
  arrange(ICB,`Org Short Name`)

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


## column 3: WLMDS 52 plus week in % 
rtt_wlmds_52plus_week_perf <- data_RTTt |>
  filter(Measure == "52+ week %" &
           Data_Source == "WLMDS RTT") 

#get max date after filtering 
wlmds_52plus_max_date <- max(rtt_wlmds_52plus_week_perf$Reporting_Period)

rtt_wlmds_52plus_week_perf <- rtt_wlmds_52plus_week_perf |>
  filter(Reporting_Period == wlmds_52plus_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`, Metric_Type) |>
  summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  mutate(WLMDS_52plus = Numerator/Denominator) |>
  select(ICB,`Org Short Name`, WLMDS_52plus ) |>
  arrange(ICB,`Org Short Name`) |>
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

## Bind all 4 columns to create 3rd '52+ week %' part of the table.

fiftytwoplusweeks <- bind_cols(monthly_52plus_week_perf, rtt_monthly_52plus_week_plan_perf,
                               rtt_wlmds_52plus_week_perf,wlmds_52plus_week_plan_perf  )
fiftytwoplusweeks <- fiftytwoplusweeks |>
  select(-ICB, -`Org Short Name`)

############ End of 3rd table (52 week % table) Creation ########################


          ##################################
          ## 4th table is Diag Activity ####
          ## has 3 columns ################
          #################################

## column 1: is DM01 activites
dm01_diag <- data_RTT_datamarta |>
   filter(Measure == "Diagnostic activity" &
           Data_Source == "DM01") 

#get max date after filtering 
dm01_diag_max_date <- max(dm01_diag$Reporting_Period)

dm01_diag <- dm01_diag |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`,Metric_Type) |>
  summarise(DM01 = sum(Metric_Value),.groups = "drop") |>
  select(ICB,`Org Short Name`,DM01 ) |>
  arrange(ICB,`Org Short Name`)

## column 2: is DM01 Plans
dm01_plans <- data_RTT_datamarta |>
  filter(Measure == "Diagnostic activity" &
           Data_Source == "Plans") 

dm01_plans <- dm01_plans |>
  filter(Reporting_Period == dm01_diag_max_date) |>
  select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
  group_by(ICB, `Org Short Name`,Metric_Type) |>
  summarise(DM01_plans = sum(Metric_Value),.groups = "drop") |>
  select(ICB,`Org Short Name`,DM01_plans ) |>
  arrange(ICB,`Org Short Name`) |>
  select(DM01_plans)

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

## Bind all 3 columns to create 4th table 'Diagnostic activity' part of the table, calculate % and remove extra col.

 diagnostic_activity <- bind_cols(dm01_diag,dm01_plans,wl_planned_perc) 
 diagnostic_activity <- diagnostic_activity |>
   mutate(wl_or_planned_perc = wl_or_plan/DM01) |>
   select(-wl_or_plan) |>
   select(-ICB, - `Org Short Name`)
   
 ############ End of 4th table (Diagnostic activity table) Creation ########################   
   
 
           #####################################
           ## 5th table is A&G: Pre referral ###
           ## has 3 columns ####################
           #####################################
 ## column 1: is utilization 
 ag_utilisation <- data_RTT_datamarta |>
     filter(Measure == "Spec Advice utilisation - pre referral")
 
 #get max date after filtering 
 ag_utilisation_max_date <- max(ag_utilisation$Reporting_Period)
 
 ag_utilisation <- ag_utilisation |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Utilisation = (Numerator/Denominator)) |>
   select(ICB,`Org Short Name`, Utilisation ) |>
   arrange(ICB,`Org Short Name`) 

  ## column 2: is diversion %
 ag_diversion <- data_RTT_datamarta |>
   filter(Measure == "Spec Advice diversion - pre referral")
 
 #get max date after filtering 
 ag_diversion_max_date <- max(ag_diversion$Reporting_Period)
 
 ag_diversion <- ag_diversion |>
   filter(Reporting_Period == ag_utilisation_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(Diversion = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, Diversion) |>
   arrange(ICB,`Org Short Name`) |>
   select(Diversion)
 
 ## Bind all 2 columns to create 5th table 'A & G: Pre referral' part of the table
 AG_pre_referral <- bind_cols(ag_utilisation,ag_diversion)
 AG_pre_referral <- AG_pre_referral |>
   select(-ICB, -`Org Short Name`)
 
 ############ End of 5th table (A & G: Pre referral table) Creation ########################  
 
 
             #######################################
             ## 6th table is 12+ week validation ###
             ## has 1 columns ######################
             #######################################
 twelve_plus_week_val <- data_RTTt |>
   filter(Measure == "12+ week validation" &
            Data_Source == "WLMDS RTT") 
 
 #get max date after filtering 
 twelve_plus_week_val_max_date <- max(twelve_plus_week_val$Reporting_Period)
 
 twelve_plus_week_val <- twelve_plus_week_val |>
   filter(Reporting_Period == twelve_plus_week_val_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(WLMDS_12plus_week_val = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, WLMDS_12plus_week_val) |>
   arrange(ICB,`Org Short Name`) |>
   select(-ICB, -`Org Short Name` )
 
 ############ End of 6th table (12 + week validation WLMDS) Creation ########################   
 
 
 
             #######################################
             ## 7th table is Missed appointments ###
             ## has 1 columns ######################
             #######################################
 
 ## column 1: SUS_OPA
 missed_appt <- data_RTT_datamarta |>
   filter(Measure == "Missed appointments")
 
 #get max date after filtering 
 missed_appt_max_date <- max(missed_appt$Reporting_Period)
 
 missed_appt <- missed_appt |>
   filter(Reporting_Period == missed_appt_max_date) |>
   select(ICB,`Org Short Name`, Metric_Type, Metric_Value) |>
   group_by(ICB, `Org Short Name`, Metric_Type) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
   mutate(SUS_OPA = Numerator/Denominator) |>
   select(ICB,`Org Short Name`, SUS_OPA ) |>
   arrange(ICB,`Org Short Name`) |>
   select(-ICB, - `Org Short Name`)
 
 ############ End of 7th table (Missed appointments table) Creation ########################   
 
 #######################################
 ## 8th table is PIFU utilisation ###
 ## has 2 columns ######################
 #######################################
 
 ## column 1: EROC/SUS_OPA (numerator and denomirator coming from different data sources!)
 # get numerator for col 1
 pifu_eroc_sus_opa_num <- data_RTT_datamarta |>
   filter(Measure == "PIFU utilisation" &
            Data_Source == "Provider EROC" &
            Metric_Type == "Numerator")
  #get max date after filtering 
 pifu_eroc_sus_opa_num_max_date <- max(pifu_eroc_sus_opa_num$Reporting_Period)
 
 pifu_eroc_sus_opa_num <- pifu_eroc_sus_opa_num |>
   filter(Reporting_Period == pifu_eroc_sus_opa_num_max_date) |>
   select(ICB,`Org Short Name`,  Metric_Value) |>
   group_by(ICB, `Org Short Name`) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Numerator = Metric_Value) |>
   select(ICB,`Org Short Name`, Numerator) |>
   arrange(ICB,`Org Short Name`) 
 
 # get denominator for col 1
 pifu_eroc_sus_opa_denom <- data_RTT_datamarta |>
   filter(Measure == "PIFU utilisation" &
            Data_Source == "SUS OPA" &
            Metric_Type == "Denominator")
 #get max date after filtering 
 pifu_eroc_sus_opa_denom_max_date <- max(pifu_eroc_sus_opa_denom$Reporting_Period)
 
 pifu_eroc_sus_opa_denom <- pifu_eroc_sus_opa_denom |>
   filter(Reporting_Period == pifu_eroc_sus_opa_denom_max_date) |>
   select(ICB,`Org Short Name`,  Metric_Value) |>
   group_by(ICB, `Org Short Name`) |>
   summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
   rename(Denominator = Metric_Value) |>
   select(ICB,`Org Short Name`, Denominator) |>
   arrange(ICB,`Org Short Name`) |>
   select(`Org Short Name`, Denominator)
  
 ## get the numerator and denominator together to calculate the % 
 #pifu_eroc_sus_opa <- bind_cols( pifu_eroc_sus_opa_num, pifu_eroc_sus_opa_denom)
 
 ## got error in bind_cols and both tables have diff num of rows, so try join instead
 pifu_eroc_sus_opa <- left_join(pifu_eroc_sus_opa_num,pifu_eroc_sus_opa_denom, by = "Org Short Name")
    
 pifu_eroc_sus_opa <- pifu_eroc_sus_opa |>
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

 ## Bind all 2 columns to create 5th table 'A & G: Pre referral' part of the table 
 #pifu_utilisation <- bind_cols(pifu_eroc_sus_opa, pifu_utilisation_plan)
 pifu_utilisation <- full_join(pifu_eroc_sus_opa, pifu_utilisation_plan, by = "Org Short Name")
 
 ## again bec of diff no of rows (somerset data missing for nume above) use join instead of bind
 
 pifu_utilisation  <- pifu_utilisation  |>
   select(-ICB, - `Org Short Name`)
 
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
  
key_summary_main <- bind_cols(rtt_performance, wait_to_first, fiftytwoplusweeks, 
                               diagnostic_activity, AG_pre_referral, twelve_plus_week_val, 
                               missed_appt, pifu_utilisation)#,theatre_utilisation ) 
 
 ## rename column names as in excel table
 key_summary_main <- key_summary_main |>
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
 
 
 col_dates <- c(ICB = "ICB", 
                Organisation = "Organisation",
   RTT_monthly = format(rtt_monthly_max_date,"%b-%y"),
   Plans_RTT_mthly = format(rtt_monthly_max_date,"%b-%y"),
   WLMDS_RTT_weekly = format(rtt_wlmds_max_date,"%d-%b-%y"),
   Plan_RTT_weekly = format(rtt_wlmds_max_date,"%b-%y"),
   
   WLMDS_wait_to_1st = format(wait_to_1st_wlmds_max_date,"%d-%b-%y"),
   Plan_wait_to_1st = format(wait_to_1st_wlmds_max_date,"%b-%y"),
   
   RTT_monthly_52plus = format(monthly_52plus_max_date,"%b-%y"),
   Plans_52plus_mthly	= format(monthly_52plus_max_date,"%b-%y"),
   WLMDS_52plus = format(wlmds_52plus_max_date,"%d-%b-%y"),
   Plans_52plus_weekly = format(wlmds_52plus_max_date,"%b-%y"),
   
   DM01 = format(dm01_diag_max_date,"%b-%y"),
   Plans_diag = format(dm01_diag_max_date,"%b-%y"),
   WL_or_Planned_perc_diag = format(dm01_diag_max_date,"%b-%y"),
   
   Utilisation = format(ag_utilisation_max_date,"%b-%y"),
   Diversion =   format(ag_diversion_max_date,"%b-%y"),
   
   WLMDS_12plus_week_val = format(twelve_plus_week_val_max_date,"%d-%b-%y"),
   
   SUS_OPA = format(missed_appt_max_date,"%b-%y"),
   
   EROC_SUS_OPA = format(pifu_eroc_sus_opa_denom_max_date, "%b-%y"),
   Plan_pifu_utilisation = format(pifu_eroc_sus_opa_denom_max_date, "%b-%y"),
   
   NTDC = format(theatre_data_date_max,"%d-%b-%y")
 )
 

 
 # Create new columns names with dates
 new_col_labels <- sapply(names(col_dates), function(col) {
   paste0(col, "/", col_dates[[col]])
 })
 
 colnames(key_summary_main) <- new_col_labels
 #rename 1st two column names
 key_summary_main <- key_summary_main |>
    rename(ICB = `ICB/ICB`,
    Organisation = `Organisation/Organisation`)
 
 ## save the sum of columns before taking mean of all columns
 diag_actvity_total <- sum(key_summary_main[,13])
 diag_plan_total <- sum(key_summary_main[,14])
 
 ## create Avg of all the the columns in Key_summary_main data table.
 mean_row <- colMeans(key_summary_main[sapply(key_summary_main, is.numeric)])
 
 ## convert vector to data frame row
 South_West <- as.data.frame(t(mean_row))
 South_West <- South_West |>
   mutate(ICB = "",
          Organisation = "South West") |>
   select(ICB,Organisation,everything())
 
 ## combine the means row with the main table
 key_summary_main <- bind_rows(key_summary_main,South_West)
 
 key_summary_main[14,13] <- diag_actvity_total
 key_summary_main[14,14] <- diag_plan_total
 
 
 #########################################################
 ##### Prepare table for html MAIN file ######################
 #########################################################
 
 names(key_summary_main) <- gsub("RTT_monthly","RTT monthly",names(key_summary_main))
 names(key_summary_main) <- gsub("Plans_RTT_mthly","Plans",names(key_summary_main))
 names(key_summary_main) <- gsub("WLMDS_RTT_weekly","WLMDS1",names(key_summary_main))
 names(key_summary_main) <- gsub("Plan_RTT_weekly","Plans1",names(key_summary_main))
 names(key_summary_main) <- gsub("WLMDS_wait_to_1st","WLMDS2",names(key_summary_main))
 names(key_summary_main) <- gsub("Plan_wait_to_1st","Plans2",names(key_summary_main))
 names(key_summary_main) <- gsub("RTT monthly_52plus","RTT monthly1",names(key_summary_main))
 names(key_summary_main) <- gsub("Plans_52plus_mthly","Plans3",names(key_summary_main))
 names(key_summary_main) <- gsub("WLMDS_52plus","WLMDS3",names(key_summary_main))
 names(key_summary_main) <- gsub("Plans_52plus_weekly","Plans4",names(key_summary_main))
 names(key_summary_main) <- gsub("Plans_diag","Plan",names(key_summary_main))
 names(key_summary_main) <- gsub("WL_or_Planned_perc_diag","% WL or Planned",names(key_summary_main))
 names(key_summary_main) <- gsub("WLMDS_12plus_week_val","WLMDS4",names(key_summary_main))
 names(key_summary_main) <- gsub("SUS_OPA","SUS-OPA",names(key_summary_main))
 names(key_summary_main) <- gsub("EROC_SUS_OPA","EROC_SUS_OPA",names(key_summary_main))
 names(key_summary_main) <- gsub("Plan_pifu_utilisation","Plans5",names(key_summary_main))

 ## set up new labels that take off numbers from Plan and WLMDs to put in gt
 labels <- names(key_summary_main) |>
   str_replace_all("^(Plans|WLMDS|RTT monthly)\\d+\\s*", "\\1 ") |>
  # str_squish() |>
   setNames(names(key_summary_main))  

 ## Now create a gt table to render in html file with all the formatings
    key_summary_gt <- key_summary_main |>  
  
   gt() |>
   
   cols_label(!!!labels) |>
   
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
   
   
 #  cols_width(
  #   4 ~ px(220),
   #  5 ~ px(250),
    # 6 ~ px(180),
    # 7 ~ px(220),
    # 8 ~ px(180),
    # 10 ~ px(180),
    # 11 ~ px(220),
    # 12 ~ px(180),
    # 18 ~ px(220),
    # 19 ~ px(220),
    # 21 ~ px(220)
   #) |>
   
   tab_style(
     style = cell_text(whitespace = "nowrap"),
     locations = cells_column_labels(everything())
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
         "**NOTE:** green cells represents value is better than plans.
         \nDiagnostic activity section has Planning modalities only.
         \nCapped theatre utilisation % is 12 week to w/e",
         format(theatre_data_date_max,"%d-%b-%y")
       )
     )
  )   |>
 
 
 tab_options(
   table.font.size = px(11),
   data_row.padding = px(2),
   column_labels.padding = px(2)
 ) |>
   
  tab_options(
    table.font.names = "Arial"
  ) |>
    
    tab_style(
      style = cell_text(align = "center"),
      locations = cells_body(columns = where(is.numeric))
    ) 
      
     # opt_table_id("key_summary_gt")
   
   
 
   #opt_sticky_columns(
    # columns = c(ICB, Organisation)
   #)
   
   

   
 
 
   #cols_label(RTT_monthly = "RTT monthly") 
   
 key_summary_gt
 
 
 
 
 