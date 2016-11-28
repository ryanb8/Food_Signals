# Reshape Data
# This script reshapes all data into appropriate shape and format for analysis.

# Packages
library(dplyr)


# FULL_DATA


# Type conversions

# Nested List formation

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

# Remove 


#????