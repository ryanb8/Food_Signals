# Reshape Data
# This script reshapes all data into appropriate shape and format for analysis.

# Packages
library(dplyr)

# FULL_DATA
drops_default <- c(
  "OBJECTID",
  "ALAND",
  "AWATER",
  "Shape_Length2",
  "Shape_Area2",
  "FIPS",
  "ACAData_csv_Geographic_Identifier",
  "ACAData_csv_Name_of_Area",
  "ACAData_csv_Area__Land_",
  "ACAData_csv_Area_Total_",
  "ACAData_csv_Area_Total__Area__Land_",
  "ACAData_csv_Area_Total__Area__Water_",
  "ACAData_csv_Households__Less_than__10_000",
  "ACAData_csv_Households___10_000_to__14_999",
  "ACAData_csv_Households___15_000_to__19_999",
  "ACAData_csv_Households___20_000_to__24_999",
  "ACAData_csv_Households___25_000_to__29_999",
  "ACAData_csv_Households___30_000_to__34_999",
  "ACAData_csv_Households___35_000_to__39_999",
  "ACAData_csv_Households___40_000_to__44_999",
  "ACAData_csv_Households___45_000_to__49_999",
  "ACAData_csv_Households___50_000_to__59_999",
  "ACAData_csv_Households___60_000_to__74_999",
  "ACAData_csv_Households___75_000_to__99_999",
  "ACAData_csv_Households___100_000_to__124_999",
  "ACAData_csv_Households___125_000_to__149_999",
  "ACAData_csv_Households___150_000_to__199_999",
  "ACAData_csv_Households___200_000_or_More",
  "ACAData_csv_Households__More_than__10_000",
  "ACAData_csv_Households__More_than__15_000",
  "ACAData_csv_Households__More_than__20_000",
  "ACAData_csv_Households__More_than__25_000",
  "ACAData_csv_Households__More_than__30_000",
  "ACAData_csv_Households__More_than__35_000",
  "ACAData_csv_Households__More_than__40_000",
  "ACAData_csv_Households__More_than__45_000",
  "ACAData_csv_Households__More_than__50_000",
  "ACAData_csv_Households__More_than__60_000",
  "ACAData_csv_Households__More_than__75_000",
  "ACAData_csv_Households__More_than__100_000",
  "ACAData_csv_Households__More_than__125_000",
  "ACAData_csv_Households__More_than__150_000",
  "ACAData_csv_Households__More_than__200_000",
  "ACAData_csv_Median_household_income__In_2014_Inflation_Adjusted",
  "ACAData_csv_Average_household_income__In_2014_Inflation_Adjusted",
  "ACAData_csv_Median_Family_Income__In_2014_Inflation_Adjusted_Dol",
  "ACAData_csv_Average_Family_Income__In_2014_Inflation_Adjusted_Do",
  "ACAData_csv_Median_Nonfamily_Household_Income__In_2014_Inflation",
  "ACAData_csv_Average_Nonfamily_Income__In_2014_Inflation_Adjusted",
  "ACAData_csv_Per_capita_income__In_2014_Inflation_Adjusted_Dollar",
  "ACAData_csv_Lowest_Quintile",
  "ACAData_csv_Second_Quintile",
  "ACAData_csv_Third_Quintile",
  "ACAData_csv_Fourth_Quintile",
  "ACAData_csv_Lower_Limit_of_Top_5_Percent",
  "ACAData_csv_Highest_Quintile",
  "ACAData_csv_Top_5_Percent",
  "ACAData_csv_Gini_Index"
)
string_default <- c(
  "ct_num_to_name_csv_CT_Num",
  "ct_num_to_name_csv_County_Name23",
  "point_layer",
  "point_id",
  "point_name",
  "point_desc"
)
double_default <- c(
  "pop_real",
  "med_house_inc",
  "pop_density",
  "avg_house_inc",
  "med_fam_inc",
  "avg_fam_inc",
  "per_cap_inc",
  "gini_v2",
  "pc_q1",
  "pc_q2",
  "pc_q3",
  "pc_q4",
  "pc_q5",
  "shp_man2",
  "new_area"
)
factor_default <- c(
  "CT_Num",
  "TractCE",
  "ACAData_csv_Qualifying_Name",
  "ACAData_csv_Logical_Record_Number",
  "ACAData_csv_Census_Tract"
)
fd_to_list <- function(df, 
                       drops=drops_default,
                       string=string_default,
                       double=double_default,
                       factor=factor_default){
  # remove bad columns
  df <- df[ , !(names(df) %in% drops)]
  
  # type Conversions
  
  
  #Create Analysis Identifier (for grouping)
  # data is initially a frickton of dfs ontop of each other
  # grouping by buffer_val, point_layer, and point_id returns only the df for
  # the corresponding point. These are the census tracts and their data within
  # a buffer value of that given point. (see restarant and grocery data)
  # note that point data is not unique! needs other two vars to get grouping
  df$group <- 
  
  
  # Type conversions

  # Nested List formation
}

# Grocery and restaurant Data
clean_gsr <- function(df, drops, chain_name){
  #df is data frame
  #drops is vector of column names to be dropped
  #chain_name is the column name of the column providing the store name
  
  #Drop
  df <- df[ , !(names(df) %in% drops)]
  
  #Create unique_name
  # Removes punc&spaces, all lowercases
  df$chain_id <- tolower(gsub("[[:punct:]\ ]",
                              "",
                              df[ , chain_name]))
  
  #Reorder (chain Id is first column,
  #rows sorted alphabetically by chain_ID)
  df <- df %>%
    select(chain_id, everything()) %>%
    arrange(chain_id)
                      
  return(df)
}
