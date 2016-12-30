# Reshape Data
# This file contains functions to reshape and clean the data
# into appropriate shapes and formats for analysis.
# It discards undesired fields, converts to correct data types, and sorts.
# Many of the fields were created in ArcMap, and thus the functions will not 
#   always generate to new datasets.

# Author: Ryan Boyer
# Last Update: 12/30/2016

# Packages
library(dplyr)

# Field name lists, by type
# Fields in data frame that are not passed to one of these lists are dropped
# Many of these fields were created in ArcMap; may not genearlize immediately to
# other datasets
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

########################
# FUNCTION: create_chain_id
# takes a vector of chain names and creates chain_id by converting to lowercase
# and stripping out punctuation and spaces
# 
# INPUT:
# chains: vector of chains as strings
#
# OUTPUT: 
# chain_id: vector of chain_ids
########################
create_chain_id <- function(chains){
  return(tolower(gsub("[[:punct:]\ ]",
                              "",
                              chains)))
}


########################
# FUNCTION: fd_to_list
# Converts and cleans full data frame (from ArcPy) to R ready format.
# Groups data by buffer value/establishment pair.
# 
# INPUT:
# df: full data frame from ArcPy/ArcMap
#     For each buffer establishment pair, there is a list of tracts and their
#     population, census, and ACS data 
#     data keys: buffer_val, point_id, Tract CE
#     BUG: Area in Yds not included in data
# string: list of field names to be converted/kept as strings
# double: list of field names to be converted/kept as numerics
# factor: list of field names to be converted/kept as factors
# chain_name: field name that contains the restaurant/grocery store's chain
#             e.g. "mcdonalds" or "trader joes"
# groups: Fields to group data for analysis on with DPLYR. Should reduce to 
#         establishment/ buffer_val pair. ("point layer" is factor for grocery
#         or restaurant; further ensures no crossover.)
#
# OUTPUT: 
# df: cleaned and orgainzed data frame
########################
fd_to_list <- 
  function(df, 
           string = string_default,
           double = double_default,
           factor = factor_default,
           chain_name = "point_name",
           groups = c("point_desc", "buffer_val", "point_layer")) {
    
  # Keep only desired columns
  df <- df %>% 
    select_(.dots=c(factor, double, string))
  
  # Type Conversions
  # convert all stings and doubles from factor to strings
  df[ , string] <- lapply(df[ , string], function(x) as.character(x))
  
  # covert doubles to numerics
  df[ , double] <- lapply(df[ , double], function(f){
    if (is.factor(f)){
      as.numeric(levels(f))[f]
    } else{
      f
    }
  })

  # Create Chain id - a string that will be unique for each chain e.g. mcdonalds
  df$chain_id <- create_chain_id(df[ , chain_name])
  # df$chain_id <- tolower(gsub("[[:punct:]\ ]",
  #                             "",
  #                             df[ , chain_name]))
  
  # Group Data
  #   Grouping by buffer_val, point_layer, and point_desc allows for quick 
  #   statistics for each buffer val/establishment pair.
  # Create Group_ID 
  df$group_id <- do.call(paste, c(df[groups], sep = "_"))
  
  # Group by id
  df_grouped <- dplyr::group_by(df, group_id)
  
  # return grouped data
  return(df_grouped)
}

########################
# FUNCTION: clean_gsr
# Cleans grocery store or restaurant data into R ready format.
# Drops unecessary columns, handles type conversions, creates chain_id
# 
# INPUT:
# df: data frame of grocery store or restaurant dta
# drops: vector of column names to be dropped from returned data fame
# chain_name: column name of the column providing the store name
# g_or_r: string to add identfier for store type
#   "G" for grocery store or "R" for restaurant are suggested
#
# OUTPUT: 
# df: cleaned data frame with chain_id
########################
clean_gsr <- function(df, drops, chain_name, g_or_r){
  #Drop
  df <- df[ , !(names(df) %in% drops)]
  
  # Create unique_name
  # Removes punc&spaces, all lowercases
  df$chain_id <- create_chain_id(df[ , chain_name])
  # df$chain_id <- tolower(gsub("[[:punct:]\ ]",
  #                             "",
  #                             df[ , chain_name]))
  
  #change Description to character
  df$Description <- as.character(df$Description)
  
  #Reorder (chain Id is first column,
  #rows sorted alphabetically by chain_ID)
  df <- df %>%
    select(chain_id, everything()) %>%
    arrange(chain_id)
  
  #add Grocery or Restaurant tag
  df$type <- g_or_r
                      
  return(df)
}
