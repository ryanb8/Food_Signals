# Reshape Data
# This script reshapes all data into appropriate shape and format for analysis.

# Packages
library(dplyr)

# FULL_DATA
string_default <- c(
  "ct_num_to_name_csv_CT_Num",
  "ct_num_to_name_csv_County_Name23",
  "point_layer",
  "point_id",
  "point_name",
  "point_desc",
  "buffer_val"
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
  "new_area",
  "ct_area_yd"
)
factor_default <- c(
  "CT_Num",
  "TractCE",
  "ACAData_csv_Qualifying_Name",
  "ACAData_csv_Logical_Record_Number",
  "ACAData_csv_Census_Tract"
)
fd_to_list <- function(df, 
                       string=string_default,
                       double=double_default,
                       factor=factor_default,
                       chain_name="point_name",
                       groups=c("point_id", "buffer_val", "point_layer")){
  # keep only desired columns
  df <- df %>% 
    select_(.dots=c(factor, double, string))
  
  # type Conversions
  # convert all stings and doubles from factor to strings
  #df[ , string] <- apply(df[, string], 2, function(x) as.character(x))
  df[ , string] <- lapply(df[ , string], function(x) as.character(x))
  
  # covert doubles to numerics
  #df[ , double] <- apply(df[, double], 2, function(f) as.numeric(levels(f))[f])
  df[ , double] <- lapply(df[ , double], function(f){
    if (is.factor(f)){
      as.numeric(levels(f))[f]
    } else{
      f
    }
  })
  

  # Keep factors - Unescessary
  #df[ ,factor] <- as.factor(df[ ,factor])
  
  #Create Chain id
  df$chain_id <- tolower(gsub("[[:punct:]\ ]",
                              "",
                              df[ , chain_name]))
  
  #Create Analysis Identifier (for grouping)
  # data is initially a frickton of dfs ontop of each other
  # grouping by buffer_val, point_layer, and point_id returns only the df for
  # the corresponding point. These are the census tracts and their data within
  # a buffer value of that given point. (see restarant and grocery data)
  # note that point data is not unique! needs other two vars to get grouping
  df$group_id <- do.call(paste, c(df[groups], sep = "_"))

  #Group by id
  df_grouped <- dplyr::group_by(df, group_id)
  
  # return grouped data
  return(df_grouped)
}

# Grocery and restaurant Data
clean_gsr <- function(df, drops, chain_name, g_or_r){
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
  
  #change Description to character
  df$Description <- as.character(df$Description)
  
  #Reorder (chain Id is first column,
  #rows sorted alphabetically by chain_ID)
  df <- df %>%
    select(chain_id, everything()) %>%
    arrange(chain_id)
  
  #add Grocery or Restaurant
  df$type <- g_or_r
                      
  return(df)
}
