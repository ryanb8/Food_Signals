# PLAN5120 FINAL PROJECT ANALYSIS
# This script performs the analysis for my final project for PLAN5120
# It imports the data created by ARCGIS, reshapes it, performs weighted
# averages on the calculations, and generates graphs.

# This script imports, cleans, orders, and summarizes data.
# Graphs are called from other scripts on data prepared in this script.

# Author: Ryan Boyer
# Last Update: 12/30/2016

# source:
source("reshape_data.R")

# load pkgs
library(dplyr)

#############################################################################
# Import data
# NOTE - Next time, turn strings as factors off.
#############################################################################
full_data <- read.csv("../data/real_output.csv") #from ArcPy 
# Full data is effectivelly nested tables, though in database form. 
#   For each buffer establishment pair, there is a list of tracts and their
#   population, census, and ACS data 
#   data keys: buffer_val, point_id, point_layer, Tract CE
#     buffer_val: buffer distance as string (e.g. "0.25 Miles")
#     point_id: unique id of an establishment (integer)
#     point_layer: factor with values either:
#       "layer0": grocery store
#       "layer1": restaurant
#       ensures that restaurants and grocery stores with same name aren't merged
#     Tract CE: Factor, 6 digit string identifying unique census tract
#   BUG: Area in Yds not included in data
gs_data <- read.csv("../data/bao_grocery.csv") #Grocery Stores (BAO)
rr_data <- read.csv("../data/bao_restaurant.csv") #Restaurants (BAO)
ct_area_data <- read.table("../data/ct_area_yds.txt",
                           header = TRUE,
                           sep = ",") #Census Tract data

#############################################################################
# Clean Data
#############################################################################
#Clean Grocery Store & Restauratn
  gs_data2 <- clean_gsr(df = gs_data, 
                        drops = c("X", "Object_ID"), 
                        chain_name = "Name", 
                        g_or_r = "G")
  rr_data2 <- clean_gsr(df = rr_data, 
                        drops = c("X", "Object_ID"), 
                        chain_name = "Name", 
                        g_or_r = "R")
  
  #Join gs_data2 and rr_data2
  stores <- rbind(gs_data2, rr_data2)
  stores <- distinct_(stores)

# Clean Census Tract Data
  # Remove factor in Tract name
  ct_area_data$ACAData_csv_Qualifying_Name <- 
    as.character(ct_area_data$ACAData_csv_Qualifying_Name)
  
  # Replace buffer (OBJECTID=1) with 0 for all values
  # The buffer tract represents a 5 mile boundary band around the entire region.
  # In the analysis, it's assumed that it has a population of 0 and thus does not
  #   factor into the weights and calculations. 
  # Assigning it's name to 0 gives it a non-empty name for join matching.
  ct_area_data$CT_Num[which(ct_area_data$OBJECTID == 1)] <- 0
  ct_area_data$TractCE[which(ct_area_data$OBJECTID == 1)] <- 0
  ct_area_data$ACAData_csv_Qualifying_Name[which(
    ct_area_data$OBJECTID == 1)] <- "0"

# Clean Full data (From ArcPy)
  # Remove factor in tract name
  full_data$ACAData_csv_Qualifying_Name <- 
    as.character(full_data$ACAData_csv_Qualifying_Name)
  
  # Give the "None" (buffer) a real name of "0" which matches Census Data
  full_data$ACAData_csv_Qualifying_Name[which(full_data$CT_Num == "None")] <-
    "0"
  
  # Pull ct_area_yd (tract area in square yards) from CT data to Full data
  #   This is the only tract data required from ct_area_data
  #   BUG/IDEA: Really, this should be pulled in with all the other data from
  #     ArcPy script.
  full_data$ct_area_yd <- 0.0
  full_data$ct_area_yd <-
    unlist(lapply(
      as.character(full_data$ACAData_csv_Qualifying_Name),
      FUN = function(x)
        ct_area_data$CT_area_Yds[which(
          as.character(ct_area_data$ACAData_csv_Qualifying_Name) == x
          )]
    ))

#############################################################################
# Group, Organize, & Summarize Data
#############################################################################
# group by buffer val/establishment pair via reshape_data.R
# only keep desired columns and convert to appropriate (numeric, char, etc.)
fd_grouped <- fd_to_list(full_data)

# Calc proportional population for each tract in buffer val/establishment pair 
#    (population in area within buffer, assuming even distribution of people
#    within census tract)
fd_grouped$prop_pop <- 
  (fd_grouped$pop_real * fd_grouped$new_area)/fd_grouped$ct_area_yd

# Summarized Grouped DF
#   For each establishment/buffer-val pair calculate statistics
fd_summarized <- dplyr::summarise(fd_grouped,
  med_house_inc_w = weighted.mean(med_house_inc, prop_pop, na.rm = TRUE),
  avg_house_inc_w = weighted.mean(avg_house_inc, prop_pop, na.rm = TRUE),
  med_fam_inc_w = weighted.mean(med_fam_inc, prop_pop, na.rm = TRUE),
  avg_fam_inc_w = weighted.mean(avg_fam_inc, prop_pop, na.rm = TRUE),
  per_cap_inc_w = weighted.mean(per_cap_inc, prop_pop, na.rm = TRUE),
  point_desc = first(point_desc),
  # #desc_n = n_distinct(point_desc),
  buffer = first(buffer_val),
  # #buffer_n = n_distinct(buffer_val),
  name = first(point_name),
  # #name_n = n_distinct(point_name)
  prop_pop = sum(prop_pop, na.rm = TRUE)
  )

#Join stores and Summarys
stores_w_sum <- inner_join(stores, fd_summarized, by=c("Description"="point_desc"))

#Get Chain Level statistics for each buffer value
stores_w_sum$chain_id <- as.factor(stores_w_sum$chain_id)
stores_grouped <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>%
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 2) %>%
  dplyr::summarise(
    a_med_house_inc_w = mean(med_house_inc_w, na.rm = TRUE),
    a_avg_house_inc_w = mean(avg_house_inc_w, na.rm = TRUE),
    a_med_fam_inc_w = mean(med_fam_inc_w, na.rm = TRUE),
    a_avg_fam_inc_w = mean(avg_fam_inc_w, na.rm = TRUE),
    a_per_cap_inc_w = mean(per_cap_inc_w, na.rm = TRUE),
    count = first(count),
    a_prop_pop = mean(prop_pop, na.rm = TRUE),
    type = first(type)
    )

#pass "count" back to stores data for vizualization
stores2 <- 
  dplyr::inner_join(stores_w_sum, 
                    stores_grouped[ ,c("chain_id", "count")],
                    by="chain_id") %>%
  distinct_() %>%
  arrange(chain_id)