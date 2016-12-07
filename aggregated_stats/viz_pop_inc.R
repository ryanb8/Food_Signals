#Vizualize population vs income
library(grid)
library(ggplot2)
library(gganimate)
library(gridExtra)

#COUNT FILTER IS ON PRIOR PAGE

#group stores by buffer
#not actually using dplyr group, as making graphs of groups is difficult
stores_buf_order <- arrange(stores2, buffer, desc(type)) 
stores_buf_order$type[which(stores_buf_order$type == "G")] <- "Grocery Store"
stores_buf_order$type[which(stores_buf_order$type == "R")] <- "Restaurant"

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
  ggtitle(paste0(c(
    "Population and Per Capita Income",
    "for Food Service Establishments",
    "Buffer Range: "), collapse ="\n"))+
  labs(x = "Log of Population in Service Area", 
       y = "Per Capita Income ($)") +
  scale_x_log10() +
  guides(colour = guide_legend(
    title="Store Type",
    size = 15,
    face = "bold"
  )) + 
  labs(caption = paste0(c(
    "Establishment data from ESRI Business Analyst Online, November 2016",
    "Economic and population data from the 2010-2014 ACS 5 Year Summary",
    "Census tract boundaries from the US Census Bureau, November 2016",
    "All establishments are within the 10 counties in the Atlanta Regional Commission",
    "Processed in Python using ArcPy, Generated in R using ggplot2 and gganimiate",
    "Created by Ryan Boyer on 11/29/16"
  ), collapse ="\n")) +
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        axis.title = element_text(size = rel(1.2)))
gganimate::gg_animate(pop_inc_plot)
gganimate::gg_animate(pop_inc_plot,
                      filename = "/Users/Ryan/Desktop/pop_inc_fs.gif",
                      saver = "gif")

#match frames in 2x3 grid
plot_holder <- list()
for (i in 1:length(buf_vals)){
  p <- op_inc_plot <- ggplot(
    stores_buf_order[which(stores_buf_order$buffer == buf_vals[i]), ],
    aes(prop_pop, per_cap_inc_w)) +
  geom_point(aes(colour = type), size = 0.25) +
  ggtitle(paste0("Buffer Range: ", buf_vals[i]))+
  labs(x = "Log of Population in Service Area", 
       y = "Per Capita Income ($)") +
  scale_x_log10(limits = c(1,10^6+(10^5/2))) +
  scale_y_continuous(limits = c(0,120000))+ 
  # guides(colour = guide_legend(
  #   title="Store Type",
  #   size = 15,
  #   face = "bold"
  # )) + 
  # labs(caption = paste0(c(
  #   "Establishment data from ESRI Business Analyst Online, November 2016",
  #   "Economic and population data from the 2010-2014 ACS 5 Year Summary",
  #   "Census tract boundaries from the US Census Bureau, November 2016",
  #   "All establishments are within the 10 counties in the Atlanta Regional Commission",
  #   "Processed in Python using ArcPy, Generated in R using ggplot2 and gganimiate",
  #   "Created by Ryan Boyer on 11/29/16"
  # ), collapse ="\n")) +
  theme(plot.title = element_text(size = rel(1), hjust=0.5),
        axis.title = element_text(size = rel(0.8)),
        legend.position="none")
  
  #save to list
  plot_holder[[i]] <- p
  
}

#get lengend from oringal gif plot
p_legend <- g_legend(pop_inc_plot) 

png(filename="../5frameGrid_PopInc.png",
    width = 555, height = 450)
grid.arrange(plot_holder[[1]], 
             plot_holder[[2]],
             plot_holder[[3]],
             plot_holder[[4]],
             plot_holder[[5]],
             p_legend,
             ncol=3,
             top = textGrob(paste0(
               "Population and Per Capita Income ", 
               "for Food Service Establishments")),
             bottom = textGrob(
               paste0(c(
                 "Establishment data from ESRI Business Analyst Online, November 2016",
                 "Economic and population data from the 2010-2014 ACS 5 Year Summary",
                 "Census tract boundaries from the US Census Bureau, November 2016",
                 "All establishments are within the 10 counties in the Atlanta Regional Commission",
                 "Processed in Python using ArcPy, Generated in R using ggplot2 and gganimiate",
                 "Created by Ryan Boyer on 11/29/16"
               ), collapse ="\n"),
             gp =gpar(fontsize=8))
             )
dev.off()


#What is this???
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

