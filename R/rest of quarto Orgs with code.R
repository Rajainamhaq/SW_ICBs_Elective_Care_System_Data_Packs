## Dorset Co

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RBD
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RBD")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## RUH Bath

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RD1
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RD1")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## R Cornwall

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for REF
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("REF")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## Somerset

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RH5
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RH5")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.



## UH Plymouth

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RK9
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RK9")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## Gt Western

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RN3
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RN3")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## Salisbury

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RNZ
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RNZ")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## Gloucestershire

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RTE
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RTE")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)
```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.

## N Bristol

```{r echo=FALSE, message=FALSE, warning = FALSE}
##use function to create table for RVJ
df_provider <- fun_Val_of_Pathway_12PlusWeeks_ORG("RVJ")
fun_fmt_Val_of_Pathway_12PlusWeeks(df_provider)

total_pathways <- as.integer(df_provider[nrow(df_provider),2])
top_specialty <- as.character(df_provider[1,1])
top_specialty_pw <- as.integer(df_provider[2,2])
top_specialty_oos <- as.integer(df_provider[2,3])
df_not_val <- as.integer(df_provider[1,6])
df_out_of_scope <- as.integer(df_provider[nrow(df_provider),3])
df_in_scope_val <- total_pathways - df_out_of_scope
top_spec_in_scope_val <- top_specialty_pw - top_specialty_oos
df_val_percentage <- round( ((total_pathways-df_out_of_scope)/total_pathways*100),1)

```

-   Of the `r total_pathways` pathways currently waiting over 12 weeks, `r df_in_scope_val` are in scope of validation.
-   `r df_val_percentage`% of pathways in scope of validation have been validated in the last 12 weeks against a target of 90%.
-   `r top_specialty` is the largest specialty with `r df_not_val` un validated pathways out of `r top_spec_in_scope_val` pathways in scope for validation for the specialty.