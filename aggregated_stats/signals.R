# Signals.R
#
# This file displays the economic "Signals" that brands send based on their 
# location and the income of that area. It creates a dot density plot of chains
# and identifies several common chains.

# Author: Ryan Boyer
# Last Update: 12/30/2016

# Packages
library(ggplot2)
library(gridExtra)
library(grid)
library(dplyr)

#################################################
# GGPLOT BUG:
# With the dot density plot, the legend can only be created by ??? 
#   but this makes the color dots show up on the bottom of the dot density plot,
#   not in their repsective positions.
# To fix, create plot with legend and wihtout legend. steal legedng grob and bind
# with plot.
#################################################

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


# PARAMETERS
# Data
buf_vals <- c("0.25 Miles", "0.75 Miles", "1.5 Miles", "3 Miles", "5 Miles")
current_buffer <- 3
more_than_x_stores <- 5 #filter out chains with < more_than_x_stores locations
# Plot
fname <- "signal_plot.png"  #end in .png
widthpx <- 1100
heightpx <- 500
dot_size = 0.9
q_label_size = 10 #font size
lt_size = 15  #font size
tit_size = 18 #font size
key_width = 0.5
plot_prop = 3/4  #proportion of final plot that is the plot (left side)
leg_prop = 1/4  #proportion of final plot that is the legend (right side)
p_title <- paste0(
  c(
    "Dot Density of Per Capita Income in Service Area for Food-Centric Establishments",
    paste0(
      "One Dot per Chain, Only Chains with ",
      more_than_x_stores,
      "+ Units in ATL Region"
    ),
    paste0("Buffer Range: ", buf_vals[current_buffer])
  ),
  collapse = "\n"
)
p_caption <-
  paste0(
    c(
      "Establishment data from ESRI Business Analyst Online, November 2016",
      "Economic and population data from the 2010-2014 ACS 5 Year Summary",
      "Census tract boundaries from the US Census Bureau, November 2016",
      "All establishments are within the 10 counties in the Atlanta Regional Commission",
      "Processed in Python using ArcPy, Generated in R using ggplot2",
      paste0("Created by Ryan Boyer on ", format.Date(Sys.Date(), "%m/%d/%Y"))
    ),
    collapse = "\n"
  )

# Gathering & filter data using more_than_x_stores: throw out small chains
filter_by_sto_count <- 
  dplyr::filter(stores_w_sum, buffer == buf_vals[current_buffer]) %>%
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
    ) %>%
  dplyr::arrange(a_per_cap_inc_w)

# Calculate SD & quartiles from Mean for annotating graph
sd_val <- sd(filter_by_sto_count$a_per_cap_inc_w, na.rm = TRUE)
mean_val <- mean(filter_by_sto_count$a_per_cap_inc_w, na.rm = TRUE)
quartile_vals <- c(mean_val - 2*sd_val,
                   mean_val - 1*sd_val,
                   mean_val,
                   mean_val + 1*sd_val,
                   mean_val + 2*sd_val)

# Assign Colors to dots and manually to common chains
dot_colors <- rep("black", length(filter_by_sto_count$chain_id))
# manually assign common chains
dot_colors[which(filter_by_sto_count$chain_id == "subway")] <-
  "green"
dot_colors[which(filter_by_sto_count$chain_id == "mcdonalds")] <-
  "yellow"
dot_colors[which(filter_by_sto_count$chain_id == "burgerking")] <-
  "brown"
dot_colors[which(filter_by_sto_count$chain_id == "tacobell")] <-
  "orange"
dot_colors[which(filter_by_sto_count$chain_id == "wholefoodsmarket")] <-
  "blue"
dot_colors[which(filter_by_sto_count$chain_id == "churchschicken")] <-
  "darkorange4"
dot_colors[which(filter_by_sto_count$chain_id == "rallyshamburgers")] <-
  "azure4"
dot_colors[which(filter_by_sto_count$chain_id == "chipotlemexicangrill")] <-
  "hotpink1"
dot_colors[which(filter_by_sto_count$chain_id == "freshmarket")] <-
  "steelblue2"

filter_by_sto_count$dot_colors <- dot_colors

# Generate plot FOR LEGEND
#   Keeps almost all of the same functionality to make sure GROBS are the same 
#   for combining.
signal_plot_for_legend <-
  ggplot(filter_by_sto_count,
         aes(x = a_per_cap_inc_w,
             fill = dot_colors)) +   #NOTE: dot_colors is aesthetic for legend
                                     # in actual ggplot call
  geom_dotplot(dotsize = dot_size) + #NOTE: fill is not passed as AED in dotplot
  ggtitle(p_title) +
  # axis labels unecessary for legend
  # quartile lines + labels unnecessary for lengend
  labs(caption = p_caption) +
  # LEGEND AND FILL COLORS
  # BUG/FIX/ISSUE? : What of these is really necessary...?
  scale_fill_manual(
    # set legend colors
    values = c(
      "green" = "green",
      "yellow" = "yellow",
      "brown" = "brown",
      "orange" = "orange",
      "blue" = "blue",
      "darkorange4" = "darkorange4",
      "azure4" = "azure4",
      "hotpink1" = "hotpink1",
      "steelblue2" = "steelblue2",
      "black" = "black"
    ),
    # Change legend names
    labels = c(
      "green" = "Subway",
      "yellow" = "McDonald's",
      "brown" = "Burger King",
      "orange" = "Taco Bell",
      "blue" = "Whole Foods Market",
      "darkorange4" = "Church's Chicken",
      "azure4" = "Rally's Hamburgers",
      "hotpink1" = "Chipotle Mexican Grill",
      "steelblue2" = "Fresh Market",
      "black" = "Other"
    ),
    # Order Legend
    breaks = c(
      "darkorange4",
      "azure4",
      "brown",
      "orange",
      "yellow",
      "green",
      "hotpink1",
      "steelblue2",
      "blue",
      "black"
    ),
    name = "Chain"
  ) +
  theme(
    plot.caption = element_text(size = rel(0.8), hjust = 0.5),
    plot.title = element_text(size = rel(1.5), hjust = 0.5),
    axis.title = element_text(size = rel(1.2)),
    legend.text = element_text(size = lt_size),
    legend.title = element_text(size = tit_size),
    legend.key = element_blank()
  ) +
  guides(
    fill = guide_legend(
      keywidth = key_width,
      keyheight = key_width,
      default.unit = "inch",
      title.hjust = 0.5
    )
  )

# Generate plot FOR ACTUAL PLOT
signal_plot_for_plot <-
  ggplot(filter_by_sto_count,
         aes(x = a_per_cap_inc_w)) +  #NOTE: dot colors is not fill AES
  geom_dotplot(dotsize = dot_size, 
               fill= dot_colors) +    #NOTE: dot colors IS fill AES for dotplot
                                      #If fail on test change to filter_by_sto_count$dot_colors
  ggtitle(p_title) +
  labs(x = "Est. Per Capita Income ($)", 
       y = "Density")+
  geom_vline(
    xintercept = quartile_vals,
    colour = c("red", "yellow", "green", "yellow", "red"),
    linetype = "longdash"
  ) +
  geom_label(show.legend = FALSE,
             aes(quartile_vals[1], .99, label = "-2 SD", size = q_label_size)) +
  geom_label(show.legend = FALSE,
             aes(quartile_vals[2], .99, label = "-1 SD", size = q_label_size)) +
  geom_label(show.legend = FALSE,
             aes(quartile_vals[3], .99, label = "Mean", size = q_label_size)) +
  geom_label(show.legend = FALSE,
             aes(quartile_vals[4], .99, label = "+1 SD", size = q_label_size)) +
  geom_label(show.legend = FALSE,
             aes(quartile_vals[5], .99, label = "+2 SD", size = q_label_size)) +
  labs(caption = p_caption) +
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        axis.title = element_text(size = rel(1.2)))

# COMBINE PLOTS
legend <- g_legend(signal_plot_for_legend)

combined <- arrangeGrob(signal_plot_for_plot + theme(legend.position = 'none'),
                        legend,  
                        ncol=2, nrow=1, widths=c(plot_prop, leg_prop))

#Save Plot
png(filename = file.path("../plots", fname), 
    width = widthpx, 
    height = heightpx)
grid.draw(combined)
dev.off()

# Save some common chains to vector, in case you want to edit legend/colrs:
commons <-
  c(
    "bojangles",
    "burgerking",
    "daptaindsseafood",
    "chickfila",
    "chipotlemexicangrill",
    "freshmarket",
    "goldencorralbuffetgrill",
    "kfc",
    "kroger",
    "longjohnsilvers",
    "mcdonalds",
    "panerabread",
    "popeyeslouisianakitchen",
    "publix",
    "sonicdrivein",
    "subway",
    "tacobell",
    "traderjoes",
    "wafflehouse",
    "wendys",
    "wholefoodsmarket",
    "zaxbys"
  )
