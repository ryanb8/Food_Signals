#Plot SD's from Chain Mean and Number of Stores
library(dplyr)
library(ggplot2)
library(stats)

#parameters
plot_buffer_value <- "1.5 Miles"

#Gathering data
more_than_5 <- 
  dplyr::filter(stores_w_sum, buffer == plot_buffer_value) %>%
  dplyr::group_by(chain_id) %>% 
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 5) %>%
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
mt5_sd <- sd(more_than_5$a_per_cap_inc_w)
mt5_mean <- mean(more_than_5$a_per_cap_inc_w)
more_than_5$sd_from_mean <-(more_than_5$a_per_cap_inc_w - mt5_mean)/mt5_sd

#Make Plot
sd_v_count_plot <- 
  ggplot(more_than_5) +
  geom_point(aes(x=count, y=sd_from_mean)) +
  scale_x_continuous(limits=c(5,375))+
  scale_y_continuous(limits=c(-2,3))+
  labs(x = "Count of Establishments in Chain",
       y = "Standard Deviations From Mean \n Per Capita Income",
       title = paste0("Standard Deviations in Per Capita Income ",
                      "and Frequency of Chain"),
       subtitle = "1.5 Mile Radius Service Area",
       caption = paste0(c(
         "Establishment data from ESRI Business Analyst Online, November 2016",
         "Economic and population data from the 2010-2014 ACS 5 Year Summary",
         "Census tract boundaries from the US Census Bureau, November 2016",
         "All establishments are within the 10 counties in the Atlanta Regional Commission",
         "Processed in Python using ArcPy, Generated in R using ggplot2",
         "Created by Ryan Boyer on 12/07/16"
       ), collapse ="\n")) +
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        plot.subtitle = element_text(size = rel(1), hjust=0.5),
        axis.title = element_text(size = rel(1.2)))
  
#Save Plot
png(filename="../SD_v_ChainFreq.png",
    width = 555, height = 450)
sd_v_count_plot
dev.off()
  