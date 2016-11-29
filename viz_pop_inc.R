#Vizualize population vs income
library(ggplot2)

#group stores by buffer
#not actually using dplyr group, as making graphs of groups is difficult
stores_buf_order <- arrange(stores, buffer, desc(type)) 

#make plot
dfp <- stores_buf_order[which(stores_buf_order$buffer == "1.5 Miles"), ]
#G vs R
pop_inc_plot <- ggplot(dfp,aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(colour = type), size = 1) +
  ggtitle(paste0("Population and Per Capita Income 
for Restaurants and Grocery Stores 
in Buffer Range of ", dfp[1, "buffer"])) + 
  labs(x = "Est. Population in Service Area", y = "Weighted Per Capita Income ($)")
pop_inc_plot

#Count
pop_inc_plot <- ggplot(dfp,aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(colour = type), size = 1) +
  ggtitle(paste0("Population and Per Capita Income 
for Restaurants and Grocery Stores 
in Buffer Range of ", dfp[1, "buffer"])) + 
  labs(x = "Est. Population in Service Area", y = "Weighted Per Capita Income ($)")
pop_inc_plot


