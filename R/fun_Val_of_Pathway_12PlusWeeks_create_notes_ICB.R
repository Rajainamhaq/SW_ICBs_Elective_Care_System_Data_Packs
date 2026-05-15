####################################################################
#### function to create Notes (narrative) for each ICB ############
###  Validation of pathways currently waiting 12+ weeks ###########
###################################################################

fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB <- function(icb_name) {
    
  df_provider <- fun_Val_of_Pathway_12PlusWeeks_ICB(icb_name)
    
    total_pathways <- as.integer(df_provider[nrow(df_provider),2])
    top_specialty <- as.character(df_provider[1,1])
    top_specialty_pw <- as.integer(df_provider[2,2])
    top_specialty_oos <- as.integer(df_provider[2,3])
    pas_val_DQ <- ifelse(is.na(df_provider[nrow(df_provider),4]),0,as.integer(df_provider[nrow(df_provider),4]))
    df_not_val <- as.integer(df_provider[1,6])
    df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
    df_in_scope_val <- total_pathways - df_out_of_scope - pas_val_DQ
    top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
    df_val_percentage <- as.integer(df_provider[nrow(df_provider),8])
    
    return(list(
      total_pathways,
      top_specialty,
      top_specialty_pw,
      top_specialty_oos,
      df_not_val,
      df_out_of_scope,
      df_in_scope_val,
      top_spec_in_scope_val,
      df_val_percentage
    ))
}
  
  