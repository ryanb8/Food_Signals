# Plot SD's from Chain Mean and Number of Stores
# This file creates a plot comparing the number of establishments in a chain 
# versus the standard deviations of the chain above or below the mean per capita
# income in its service area.

# Author: Ryan Boyer
# Last Update: 12/30/2016

##############################
# EXISTENTIAL QUESTION:
# Should this really be wrapped in a function, even though its a one-time use 
# thing?
##############################

library(dplyr)
library(ggplot2)
library(stats)

#parameters
plot_buffer_value <- "1.5 Miles" #options from table(stores_w_sum$buffer)
more_than_x_stores <- 5
x_lims <- c(5,375)
y_lims <- c(-2,3)
widthpx <- 555
heightpx <- 450
fname <- "SD_v_ChainFreq.png"  #end in .png

#Gathering & filter data using buffer value and more_than_x_stores
filtered_by_est_count <- 
  dplyr::filter(stores_w_sum, buffer == plot_buffer_value) %>%
  dplyr::group_by(chain_id) %>% 
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= more_than_x_stores) %>%
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

#Calculate St Devs From Mean for each Chain
mtxs_sd <- sd(filtered_by_est_count$a_per_cap_inc_w)
mtxs_mean <- mean(filtered_by_est_count$a_per_cap_inc_w)
filtered_by_est_count$sd_from_mean <-
  (filtered_by_est_count$a_per_cap_inc_w - mtxs_mean)/mtxs_sd

#Make Plot
sd_v_count_plot <- 
  ggplot(filtered_by_est_count) +
  geom_point(aes(x=count, y=sd_from_mean)) +
  scale_x_continuous(limits=x_lims)+
  scale_y_continuous(limits=y_lims)+
  labs(x = "Count of Establishments in Chain",
       y = "Standard Deviations From Mean \n Per Capita Income",
       title = paste0("Standard Deviations in Per Capita Income ",
                      "and Frequency of Chain"),
       subtitle = paste0(
         substr(plot_buffer_value,
                1, 
                nchar(plot_buffer_value) -1),
         " Radius Service Area"),
       caption = paste0(c(
         "Establishment data from ESRI Business Analyst Online, November 2016",
         "Economic and population data from the 2010-2014 ACS 5 Year Summary",
         "Census tract boundaries from the US Census Bureau, November 2016",
         "All establishments are within the 10 counties in the Atlanta Regional Commission",
         "Processed in Python using ArcPy, Generated in R using ggplot2",
         paste0("Created by Ryan Boyer on ", format.Date(Sys.Date(), "%m/%d/%Y"))
       ), collapse ="\n")) +
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        plot.subtitle = element_text(size = rel(1), hjust=0.5),
        axis.title = element_text(size = rel(1.2)))
  
#Save Plot
png(filename = file.path("../plots", fname), 
    width = widthpx, 
    height = heightpx)
sd_v_count_plot
dev.off()
  