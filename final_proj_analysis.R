# PLAN5120 FINAL PROJECT ANALYSIS
# This script performs the analysis for my final project for PLAN5120
# It imports the data created by ARCGIS, reshapes it, performs weighted
# averages on the calculations, and generates graphs.

#Import data
# full_data <- read.csv("../data/Analysis_Output/real_output.csv")
# gs_data <- read.csv("../data/BAO/cleaned/bao_grocery.csv")
# rr_data <- read.csv("../data/BAO/cleaned/bao_restaurant.csv")
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

#Reshape and Organize Data
gs_data2 <- clean_gsr(gs_data, c("x"), "name")
rr_data2 <- clean_gsr(rr_data, c("x"), "name")

#Filter Data

#Statistics

#Graphs
