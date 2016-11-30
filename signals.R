#find signaling brands
library(gridExtra)
library(grid)
library(dplyr)

buf_vals <- c("0.25 Miles", "0.75 Miles", "1.5 Miles", "3 Miles", "5 Miles")
#stores_grouped0 <- stores_grouped
#stores_grouped3 <- stores_grouped
#stores_grouped5 <- stores_grouped
#stores_grouped10 <- stores_grouped
#stores_grouped4 <- stores_grouped

##################this is terrible coding############
stores_grouped0 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 0) %>%
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

stores_grouped2 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
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

stores_grouped3 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 3) %>%
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

stores_grouped4 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 4) %>%
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

stores_grouped5 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
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

stores_grouped8 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 8) %>%
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

stores_grouped10 <- dplyr::group_by(stores_w_sum, chain_id, buffer) %>% # chain_id, add=TRUE
  dplyr::mutate(count=length(chain_id)) %>%
  dplyr::filter(count >= 10) %>%
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

df_list <- list("0"=stores_grouped0, 
                "2"=stores_grouped2, 
                "3"=stores_grouped3, 
                "4"=stores_grouped4,
                "5"=stores_grouped5, 
                "8"=stores_grouped8, 
                "10"=stores_grouped10)

df_list <- lapply(df_list,
                  FUN = function(x) x[which(x$buffer == "1.5 Miles"), ] )

df_list <- lapply(df_list,
                  FUN= function(x) arrange(x, a_per_cap_inc_w))

###############this is ok coding at best #############

sd_list <- lapply(1:length(df_list), 
                  FUN=function(x) sd(df_list[[x]]$a_per_cap_inc_w, na.rm = TRUE))
mean_list <- lapply(1:length(df_list), 
                  FUN=function(x) mean(df_list[[x]]$a_per_cap_inc_w, na.rm = TRUE))
sds_lists <- lapply(1:length(sd_list),
                    FUN=function(x) c(mean_list[[x]]-2*sd_list[[x]],
                                      mean_list[[x]]-sd_list[[x]], 
                                      mean_list[[x]], 
                                      mean_list[[x]]+sd_list[[x]], 
                                      mean_list[[x]]+2*sd_list[[x]]))

dot_colors <- rep("black", length(df_list[[5]]$chain_id))
dot_colors[which(df_list[[5]]$chain_id=="subway")] <- "green"
dot_colors[which(df_list[[5]]$chain_id=="mcdonalds")] <- "yellow"
dot_colors[which(df_list[[5]]$chain_id=="burgerking")] <- "brown"
dot_colors[which(df_list[[5]]$chain_id=="tacobell")] <- "orange"
dot_colors[which(df_list[[5]]$chain_id=="wholefoodsmarket")] <- "blue"
dot_colors[which(df_list[[5]]$chain_id=="churchschicken")] <- "darkorange4"
dot_colors[which(df_list[[5]]$chain_id=="rallyshamburgers")] <- "azure4"
dot_colors[which(df_list[[5]]$chain_id=="chipotlemexicangrill")] <- "hotpink1"
dot_colors[which(df_list[[5]]$chain_id=="freshmarket")] <- "steelblue2"

df_list[[5]]$dot_colors <- dot_colors
df_list[[5]]$fakey <- "black"

#generate Legend
signal_plot <- ggplot(df_list[[5]],
                      aes(x = a_per_cap_inc_w,
                          fill=dot_colors)) +
  geom_dotplot(dotsize = 0.9) +
  ggtitle(paste0(c(
    "Dot Density of Per Capita Income in Service Area for Food-Centric Establishments",
    "One Dot per Chain, Only Chains with 5+ Units in ATL Region",
    "Buffer Range: 1.5 Miles "), collapse ="\n"))+
  labs(x = "Est. Per Capita Income ($)", y="Density")+
  geom_vline(xintercept = sds_lists[[5]], 
             colour=c("red","yellow", "green", "yellow", "red"),
             linetype = "longdash")+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][1],.99,label = "-2 SD", size=10))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][2],.99,label = "-1 SD", size=10))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][3],.99,label = "Mean", size=10))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][4],.99,label = "+1 SD", size=10))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][5],.99,label = "+2 SD", size=10))+
  labs(caption = paste0(c(
    "Establishment data from ESRI Business Analyst Online, November 2016",
    "Economic and population data from the 2010-2014 ACS 5 Year Summary",
    "Census tract boundaries from the US Census Bureau, November 2016",
    "All establishments are within the 10 counties in the Atlanta Regional Commission",
    "Processed in Python using ArcPy, Generated in R using ggplot2",
    "Created by Ryan Boyer on 11/29/16"
  ), collapse ="\n")) +
  scale_fill_manual(values = c("green" = "green",
                                "yellow" = "yellow",
                                "brown" = "brown",
                                "orange" = "orange",
                                "blue" = "blue",
                                "darkorange4" = "darkorange4",
                                "azure4" = "azure4",
                                "hotpink1" = "hotpink1",
                                "steelblue2" ="steelblue2",
                                "black" = "black"),
                    labels = c("green" ="Subway",
                               "yellow" ="McDonald's",
                               "brown" = "Burger King",
                               "orange" ="Taco Bell",
                               "blue" = "Whole Foods Market",
                               "darkorange4" = "Church's Chicken",
                               "azure4" = "Rally's Hamburgers",
                               "hotpink1" = "Chipotle Mexican Grill",
                               "steelblue2"= "Fresh Market",
                               "black" = "Other"),
                    breaks=c("darkorange4",
                             "azure4",
                             "brown",
                             "orange",
                             "yellow",
                             "green",
                             "hotpink1",
                             "steelblue2",
                             "blue",
                             "black"),
                    name= "Chain")+
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        axis.title = element_text(size = rel(1.2)),
        # legend.key.size = unit(55, units = "native"),
        legend.text = element_text(size = 15),
        # legend.spacing = unit(30, units = "native"),
        legend.title = element_text(size = 18),
        legend.key=element_blank())+
  guides(fill=guide_legend(
                 keywidth=0.5,
                 keyheight=0.5,
                 default.unit="inch",
                 title.hjust = 0.5
                 )
      )

#generate actual plot
signal_plot2 <- ggplot(df_list[[5]],
                      aes(x = a_per_cap_inc_w)) +
  geom_dotplot(dotsize = 0.9, fill=df_list[[5]]$dot_colors) +
  ggtitle(paste0(c(
    "Dot Density of Per Capita Income in Service Area for Food-Centric Establishments",
    "One Dot per Chain, Only Chains with 5+ Units in ATL Region",
    "Buffer Range: 1.5 Miles "), collapse ="\n"))+
  labs(x = "Est. Per Capita Income ($)", y="Density")+
  geom_vline(xintercept = sds_lists[[5]], 
             colour=c("red","yellow", "green", "yellow", "red"),
             linetype = "longdash")+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][1],.99,label = "-2 SD", size=10, fill="white"))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][2],.99,label = "-1 SD", size=10, fill="white"))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][3],.99,label = "Mean", size=10, fill="white"))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][4],.99,label = "+1 SD", size=10, fill="white"))+
  geom_label(show.legend = FALSE, 
             aes(sds_lists[[5]][5],.99,label = "+2 SD", size=10, fill="white"))+
  labs(caption = paste0(c(
    "Establishment data from ESRI Business Analyst Online, November 2016",
    "Economic and population data from the 2010-2014 ACS 5 Year Summary",
    "Census tract boundaries from the US Census Bureau, November 2016",
    "All establishments are within the 10 counties in the Atlanta Regional Commission",
    "Processed in Python using ArcPy, Generated in R using ggplot2",
    "Created by Ryan Boyer on 11/29/16"
  ), collapse ="\n")) +
  theme(plot.caption = element_text(size = rel(0.8), hjust=0.5),
        plot.title = element_text(size = rel(1.5), hjust=0.5),
        axis.title = element_text(size = rel(1.2))) +
  scale_fill_manual(values = c("green" = "green",
                                "yellow" = "yellow",
                                "brown" = "brown",
                                "orange" = "orange",
                                "blue" = "blue",
                                "darkorange4" = "darkorange4",
                                "azure4" = "azure4",
                                "hotpink1" = "hotpink1",
                                "steelblue2" ="steelblue2",
                                "black" = "black",
                                "white" = "white"))

g_legend<-function(a.gplot){
    tmp <- ggplot_gtable(ggplot_build(a.gplot))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    legend <- tmp$grobs[[leg]]
    legend
}

legend <- g_legend(signal_plot)

combined <- grid.arrange(signal_plot2 + theme(legend.position = 'none'),
                         legend,  
                          ncol=2, nrow=1, widths=c(15/20,5/20))













#Merge plot and legend
g <- ggplotGrob(signal_plot)
plot_legend <- which(g$layout$name =="guide-box")
#lheight <- sum(plot_legend$height)
#lwidth <- sum(plot_legend$width)

combined <- gridExtra::combine(test1,test2, along = 1)

combined <- rbind(ggplotGrob(signal_plot2+theme(legend.position="none")), 
             g)
    




combined <- arrangeGrob(grobs=c(signal_plot, legend),
                        ncol = 2,
                        widths = unit.c(unit(1, "npc") - lwidth, lwidth))
grid.newpage()
grid.draw(combined)
  



#sgl <- list(stores_grouped0, stores_grouped3, stores_grouped4, stores_grouped5, stores_grouped10)
i <- 3
sgldf <- as.data.frame(sgl[i])
dfp <- sgldf[which(sgldf$buffer == buf_vals[2]), ]

quantiles_nums <- quantile(dfp$a_per_cap_inc_w, probs = c(0.05,0.33,0.5,0.66,0.95))
mean_val <- mean(dfp$a_per_cap_inc_w)
sd_val <- sd(dfp$a_per_cap_inc_w)
sds <- c(mean_val-2*sd_val, mean_val-sd_val, mean_val, mean_val+sd_val, mean_val+2*sd_val)

signal_plot <- ggplot(dfp, aes(x = a_per_cap_inc_w)) + geom_dotplot(dotsize=1)
signal_plot 

cnames_low <- lapply(sds, FUN = function(x) dfp$chain_id[which(dfp$a_per_cap_inc_w <= x)])
cnames_high <- lapply(sds, FUN = function(x) dfp$chain_id[which(dfp$a_per_cap_inc_w >= x)])

#lable commons:
commons <- c(bojangles,
burgerking,
daptaindsseafood,
chickfila,
chipotlemexicangrill,
freshmarket,
goldencorralbuffetgrill,
kfc,
kroger,
longjohnsilvers,
mcdonalds,
panerabread,
popeyeslouisianakitchen,
publix,
sonicdrivein,
subway,
tacobell,
traderjoes,
wafflehouse,
wendys,
wholefoodsmarket,
zaxbys)
