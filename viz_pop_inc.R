#Vizualize population vs income
library(ggplot2)
library(gganimate)

#COUNT FILTER IS ON PRIOR PAGE

#group stores by buffer
#not actually using dplyr group, as making graphs of groups is difficult
stores_buf_order <- arrange(stores2, buffer, desc(type)) 

buf_vals <- c("0.25 Miles", "0.75 Miles", "1.5 Miles", "3 Miles", "5 Miles")

#make plot
dfp <- stores_buf_order[which(stores_buf_order$buffer == buf_vals[2]), ]
#G vs R
pop_inc_plot <- ggplot(dfp,aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(colour = type), size = 1.25) +
  ggtitle(paste0("Population and Per Capita Income 
for Restaurants and Grocery Stores
in Buffer Range of ", dfp[1, "buffer"],
                 "Only showing points in chains 5+ locations in chain ")) + 
  labs(x = "Est. Population in Service Area", y = "Weighted Per Capita Income ($)")
pop_inc_plot

pop_inc_plot <- ggplot(stores_buf_order, aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(colour = type, frame=buffer), size = 1.25) +
  ggtitle("Population and Per Capita Income for Food Service Establishments \nBuffer Range:\n\t ") +
  labs(x = "Log Est. Population in Service Area", 
       y = "Weighted Per Capita Income ($)") +
  scale_x_log10()

#Count
dfp <- stores_buf_order[which(stores_buf_order$buffer == buf_vals[4]), ]
pop_inc_plot <- ggplot(dfp, aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(color = count), size = 1) +
  scale_colour_gradient(low = "blue", high = "red") +
  ggtitle(paste0("Population and Per Capita Income 
for Restaurants and Grocery Stores 
in Buffer Range of ", dfp[1, "buffer"])) + 
  labs(x = "Est. Population in Service Area", y = "Weighted Per Capita Income ($)")
pop_inc_plot

geom_point(aes(colour = cyl)) + scale_colour_gradient(low = "blue")

