#find signaling brands
buf_vals <- c("0.25 Miles", "0.75 Miles", "1.5 Miles", "3 Miles", "5 Miles")
#stores_grouped0 <- stores_grouped
#stores_grouped3 <- stores_grouped
#stores_grouped5 <- stores_grouped
#stores_grouped10 <- stores_grouped
#stores_grouped4 <- stores_grouped

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
