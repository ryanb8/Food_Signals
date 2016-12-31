# Vizualize Population vs Income Varied Over Buffer Areas
#
# This creates a gif and a 5 panel png plotting the population vs the per capita
# income varied over the 5 buffer length values for CHAIN establishments 
# (>2 locs).

# Author: Ryan Boyer
# Last Update: 12/31/2016

########################
# FUNCTION: takes a ggplot and returns only the legend (as grob)
# adopted from: http://stackoverflow.com/questions/13649473/add-a-common-legend-for-combined-ggplots
# 
#
# INPUT:
# a.gplot: a ggplot2 plot object
#
# OUTPUT: 
# legned: just the legend grob from a ggplot
########################
g_legend<-function(a.gplot){
  # Build all grobs for plot & store in gtable
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  # identify and save legend grob
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  
  return(legend)
}

# Packages
library(grid)
library(ggplot2)
library(gganimate)
library(gridExtra)

# Parameters
buf_vals <- c("0.25 Miles", "0.75 Miles", "1.5 Miles", "3 Miles", "5 Miles")
# Both Images
p_caption <- 
  paste0(
    c(
    "Establishment data from ESRI Business Analyst Online, November 2016",
    "Economic and population data from the 2010-2014 ACS 5 Year Summary",
    "Census tract boundaries from the US Census Bureau, November 2016",
    "All establishments are within the 10 counties in the Atlanta Regional Commission",
    "Processed in Python using ArcPy, Generated in R using ggplot2 and gganimiate",
    paste0("Created by Ryan Boyer on ", format.Date(Sys.Date(), "%m/%d/%Y"))
    ),
  collapse = "\n")
# Gif
g_fname <- "pop_inc_fs.gif" #end in .gif
# 5 Frame PNG
x_lims <-  c(1, 10 ^ 6 + (10 ^ 5 / 2))  #log scale
y_lims <-  c(0, 120000)  #reg scale
p_fname <- "5frameGrid_PopInc.png"  #end in .png
pxwidth <- 555
pxheight <- 450


# Organize data by buffer
# Not using dplyr group, as making graphs of groups is difficult
chains_buf_order <- dplyr::arrange(chains, buffer, desc(type)) 

# Change "G" or "R" to "Grocery Store" or "Restaurant" for graph legend
chains_buf_order$type[which(chains_buf_order$type == "G")] <- "Grocery Store"
chains_buf_order$type[which(chains_buf_order$type == "R")] <- "Restaurant"

# Make animated Gif
# GGanimate: set frame aes to the variable that defines each frame
# Here: frame = buffer
pop_inc_plot <-
  ggplot(chains_buf_order,
         aes(prop_pop,
             per_cap_inc_w)) +
  geom_point(aes(colour = type,
                 frame = buffer),
             size = 1.25) +
  ggtitle(paste0(
    c(
      "Population and Per Capita Income",
      "for Food Service Establishments",
      "Chains with 2+ Establishments in Atlanta Area",
      "Buffer Range: "
    ),
    collapse = "\n"
  )) +
  labs(x = "Log of Population in Service Area",
       y = "Per Capita Income ($)") +
  scale_x_log10() +
  guides(colour = guide_legend(title = "Store Type",
                               face = "bold")) +
  labs(caption = p_caption) +
  theme(
    plot.caption = element_text(size = rel(0.8), hjust = 0.5),
    plot.title = element_text(size = rel(1.5), hjust = 0.5),
    axis.title = element_text(size = rel(1.2))
  )

## View Gif
# gganimate::gg_animate(pop_inc_plot)

# Save Gif
gganimate::gg_animate(pop_inc_plot,
                      filename = file.path("../plots", g_fname),
                      saver = "gif")

# Create 5 Pane PNG
# Match frames in 2x3 grid, with legend in 1 grid
plot_holder <- list()

# Iteratively create all 5 Plots
for (i in 1:length(buf_vals)){
  p <-
    ggplot(
      chains_buf_order[which(chains_buf_order$buffer == buf_vals[i]), ],
      aes(prop_pop, 
          per_cap_inc_w)) +
    geom_point(
      aes(colour = type), 
      size = 0.25
      ) +
    ggtitle(paste0("Buffer Range: ", buf_vals[i])) +
    labs(x = "Log of Population in Service Area",
         y = "Per Capita Income ($)") +
    scale_x_log10(limits = x_lims) +
    scale_y_continuous(limits = y_lims) + 
  theme(
    plot.title = element_text(size = rel(1), hjust=0.5),
    axis.title = element_text(size = rel(0.8)),
    legend.position="none")
  
  #save to list
  plot_holder[[i]] <- p
  
}

#get lengend from oringal gif plot
p_legend <- g_legend(pop_inc_plot) 


#Save PNG
png(filename = file.path("../plots", p_fname),
    width = pxwidth,
    height = pxheight)
grid.arrange(
  plot_holder[[1]],
  plot_holder[[2]],
  plot_holder[[3]],
  plot_holder[[4]],
  plot_holder[[5]],
  p_legend,
  ncol = 3,
  top = textGrob(
    paste0(
      "Population and Per Capita Income ",
      "for Food Service Establishments",
      "\nChains with 2+ Establishments in Atlanta"
    )
  ),
  bottom = textGrob(p_caption,
                    gp = gpar(fontsize = 8))
)
dev.off()
