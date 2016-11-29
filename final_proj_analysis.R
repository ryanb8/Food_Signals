# PLAN5120 FINAL PROJECT ANALYSIS
# This script performs the analysis for my final project for PLAN5120
# It imports the data created by ARCGIS, reshapes it, performs weighted
# averages on the calculations, and generates graphs.

#source:
source("reshape_data.R")

#load pkgs
library(dplyr)

#Import data
#############################################################################
#############################################################################
#######NOTE - Next time, turn strings as factors off. Idiot.#################
#############################################################################
#############################################################################

full_data <- read.csv("../data/Analysis_Output/real_output.csv")
gs_data <- read.csv("../data/BAO/cleaned/bao_grocery.csv")
rr_data <- read.csv("../data/BAO/cleaned/bao_restaurant.csv")
ct_area_data <- read.table("../data/Analysis_Output/ct_area_yds.txt",
                           header = TRUE,
                           sep = ",")

#fix ct_area_data
# Remove factor in ct_area_data$ACAData_csv_Qualifying_Name
ct_area_data$ACAData_csv_Qualifying_Name <- 
  as.character(ct_area_data$ACAData_csv_Qualifying_Name)

#replace buffer (OBJECTID=1) with 0 for all values
ct_area_data$CT_Num[which(ct_area_data$OBJECTID == 1)] <- 0
ct_area_data$TractCE[which(ct_area_data$OBJECTID == 1)] <- 0
ct_area_data$ACAData_csv_Qualifying_Name[which(
  ct_area_data$OBJECTID == 1)] <- "0"

#fix full data
# Remove factor in full_data$ACAData_csv_Qualifying_Name
full_data$ACAData_csv_Qualifying_Name <- 
  as.character(full_data$ACAData_csv_Qualifying_Name)

# give the "None" (buffer) a real name
full_data$ACAData_csv_Qualifying_Name[which(full_data$CT_Num == "None")] <-
  "0"

#add ct_area_yd
full_data$ct_area_yd <- 0.0
full_data$ct_area_yd <- unlist(
  lapply(as.character(full_data$ACAData_csv_Qualifying_Name), 
         FUN=function(x) 
             ct_area_data$CT_area_Yds[
               which(
                 as.character(ct_area_data$ACAData_csv_Qualifying_Name) == x)]))

#############################################################################
#############################################################################
#generate test data
#############################################################################
#############################################################################

#fix and group full_data
#fd_grouped<-fd_to_list(full_data)
fd_grouped <- fd_to_list(full_data)

#Calc proportion population
fd_grouped$prop_pop <- 
  (fd_grouped$pop_real * fd_grouped$new_area)/fd_grouped$ct_area_yd

#Summarized Grouped DF
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

#Reshape and Organize Data
gs_data2 <- clean_gsr(gs_data, c("X", "Object_ID"), "Name", "G")
rr_data2 <- clean_gsr(rr_data, c("X", "Object_ID"), "Name", "R")

#Join gs_data2 and rr_data2
stores <- rbind(gs_data2, rr_data2)
stores <- distinct_(stores)

#Join stores and Summarys
stores_w_sum <- inner_join(stores, fd_summarized, by=c("Description"="point_desc"))

#filter stores
stores_w_sum$chain_id <- as.factor(stores_w_sum$chain_id)
stores_grouped <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
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

#pass "count" back to stores for vizualization
stores2 <- dplyr::inner_join(stores_w_sum, 
                            stores_grouped[ ,c("chain_id", "count")],
                            by="chain_id") %>%
  distinct_() %>%
  arrange(chain_id)
  
  
#   stores_grouped$count[match(stores$chain_id, stores_grouped$chain_id)]

#Graphs - scripting in sublime
#ggplot(stores_grouped[which(stores_grouped$buffer == "0.75 Miles"), ], aes(x = a_med_house_inc_w)) +geom_dotplot()
