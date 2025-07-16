
library(ggplot2)

options(warn=-1)

df = read.csv("fn_fp.csv", sep=",", header = TRUE)
plot1 = ggplot(data=df, aes(x=Mode, y=Score, group=Type)) +
  geom_line(aes(color=Type), size = 2) +
  scale_color_manual(values=c("FP" = "#000000", "FN" = "#990000")) +
  theme_classic(base_size = 30) +
  
  # Remove the legend by switching the uncommented line below
  theme(legend.key.size = unit(1.5, "cm")) +
  #theme(legend.position = "none") + # no legend when this line is uncommented
  
  scale_y_continuous("Proteins", trans = 'log10', breaks=c(1,10,100,1000,10000,100000,100000,1000000),
                     labels = function(x) format(x, scientific = FALSE)) + # TRUE formats numbers to scientific notation e.g. 1e+00, 1e+01
  scale_x_continuous("Relaxation mode", breaks = 1:8, limits=c(1, 8))

pdf(NULL)
ggsave("optimal_grouping.png", plot= plot1, height = 10, width = 15)
cat("\noptimal_grouping.png\n\n")