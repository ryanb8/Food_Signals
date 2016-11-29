# PLAN5120 FINAL PROJECT ANALYSIS
# This script performs the analysis for my final project for PLAN5120
# It imports the data created by ARCGIS, reshapes it, performs weighted
# averages on the calculations, and generates graphs.

#source:
source("reshape_data.R")

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
full_data_test <- full_data[c(1:1000,
                              100000:102000,
                              305000:304000,
                              870000:878000,
                              1050000:1053556), ]
full_data_zaxbys <- full_data[which(full_data$point_name == "Zaxby's"),]
full_data_zaxbys <- full_data[c(
  which(full_data$point_name == "Burger King"),
  which(full_data$point_name == "Zaxby's")), ]

#fix and group full_data
#fd_grouped<-fd_to_list(full_data)
fd_grouped <- fd_to_list(full_data_test)
fd_grouped_z <- fd_to_list(full_data_zaxbys)

#Calc proportion population
fd_grouped$prop_pop <- 
  (fd_grouped$pop_real * fd_grouped$new_area)/fd_grouped$ct_area_yd

fd_grouped_z$prop_pop <- 
  (fd_grouped_z$pop_real * fd_grouped_z$new_area)/fd_grouped_z$ct_area_yd

#Summarized Grouped DF
fd_summarized <- summarise(fd_grouped,
  med_house_inc_w = weighted.mean(med_house_inc, prop_pop, na.rm = TRUE),
  avg_house_inc_w = weighted.mean(avg_house_inc, prop_pop, na.rm = TRUE),
  med_fam_inc_w = weighted.mean(med_fam_inc, prop_pop, na.rm = TRUE),
  avg_fam_inc_w = weighted.mean(avg_fam_inc, prop_pop, na.rm = TRUE),
  per_cap_inc_w = weighted.mean(per_cap_inc, prop_pop, na.rm = TRUE),
  point_desc = first(point_desc),
  #desc_n = n_distinct(point_desc),
  buffer = first(buffer_val),
  #buffer_n = n_distinct(buffer_val),
  name = first(point_name)
  #name_n = n_distinct(point_name)
  )

fd_summarized_z <- summarise(fd_grouped_z,
  med_house_inc_w = weighted.mean(med_house_inc, prop_pop, na.rm = TRUE),
  avg_house_inc_w = weighted.mean(avg_house_inc, prop_pop, na.rm = TRUE),
  med_fam_inc_w = weighted.mean(med_fam_inc, prop_pop, na.rm = TRUE),
  avg_fam_inc_w = weighted.mean(avg_fam_inc, prop_pop, na.rm = TRUE),
  per_cap_inc_w = weighted.mean(per_cap_inc, prop_pop, na.rm = TRUE),
  point_desc = first(point_desc),
  #desc_n = n_distinct(point_desc),
  buffer = first(buffer_val),
  #buffer_n = n_distinct(buffer_val),
  name = first(point_name)
  #name_n = n_distinct(point_name)
  )

#Reshape and Organize Data
gs_data2 <- clean_gsr(gs_data, c("X", "Object_ID"), "Name", "G")
rr_data2 <- clean_gsr(rr_data, c("X", "Object_ID"), "Name", "R")

#Join gs_data2 and rr_data2
stores <- rbind(gs_data2, rr_data2)

#Join stores and Summarys
stores_t <- inner_join(stores, fd_summarized, by=c("Description"="point_desc"))
stores_z <- inner_join(stores, fd_summarized_z, by=c("Description"="point_desc"))

#filter stores
#stores$chain_id <- as.factor(stores$chain_id)
# stores_grouped <- group_by(stores, chain_id, buffer) %>% # chain_id, add=TRUE
#   mutate(count=length(chain_id)) %>%
#   filter(count >= 5) %>%
#   summarise(
#     a_med_house_inc_w = mean(med_house_inc_w, na.rm = TRUE),
#     a_avg_house_inc_w = mean(avg_house_inc_w, na.rm = TRUE),
#     a_med_fam_inc_w = mean(med_fam_inc_w, na.rm = TRUE),
#     a_avg_fam_inc_w = mean(avg_fam_inc_w, na.rm = TRUE),
#     a_per_cap_inc_w = mean(per_cap_inc_w, na.rm = TRUE)
#     )

stores_t$chain_id_t <- as.factor(stores_t$chain_id)
stores_grouped_t <- group_by(stores_t, chain_id, buffer) %>% # chain_id, add=TRUE
  mutate(count=length(chain_id)) %>%
  filter(count >= 5) %>%
  summarise(
    a_med_house_inc_w = mean(med_house_inc_w, na.rm = TRUE),
    a_avg_house_inc_w = mean(avg_house_inc_w, na.rm = TRUE),
    a_med_fam_inc_w = mean(med_fam_inc_w, na.rm = TRUE),
    a_avg_fam_inc_w = mean(avg_fam_inc_w, na.rm = TRUE),
    a_per_cap_inc_w = mean(per_cap_inc_w, na.rm = TRUE),
    count = first(count)
    )

stores_z$chain_id_z <- as.factor(stores_z$chain_id)
stores_grouped_z <- group_by(stores_z, chain_id, buffer) %>% # chain_id, add=TRUE
  mutate(count=length(chain_id)) %>%
  filter(count >= 5) %>%
  summarise(
    a_med_house_inc_w = mean(med_house_inc_w, na.rm = TRUE),
    a_avg_house_inc_w = mean(avg_house_inc_w, na.rm = TRUE),
    a_med_fam_inc_w = mean(med_fam_inc_w, na.rm = TRUE),
    a_avg_fam_inc_w = mean(avg_fam_inc_w, na.rm = TRUE),
    a_per_cap_inc_w = mean(per_cap_inc_w, na.rm = TRUE),
    count = first(count)
    )

#Graphs
