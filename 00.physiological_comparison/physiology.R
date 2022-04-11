setwd("E:\\Projects\\ms_Sphagneticola_chiiling\\ecolophysiology")
rm(list=ls())
install.packages("ggplot2")
install.packages("devtools")
install.packages("stringi")
install.packages("reshape2")
install.packages("Rmisc")
install.packages("BiocManager")
BiocManager::install("lang")
BiocManager::install("devtools")
library(ggplot2)
library(devtools)
library(reshape2)
library(Rmisc)
library("BiocManager")

sph <- read.table("cold_stress.txt",header=T)
species <- sph$Sp
mda <- sph$MDA

sod <- sph$SOD
tm <- sph$Tm
mdaf <- data.frame(mda,species,tm)
mdafc <- summarySE(mdaf, measurevar="mda",groupvars=c("species","tm"))
sodf <- data.frame(sod,species,tm)
sodfc <- summarySE(sodf,measurevar="sod",groupvars=c("species","tm"))


p1 <- ggplot(mdafc, aes(x=tm, y=mda,colour=species,fill=species),showLegend=FALSE) + 
  geom_errorbar(aes(ymin=mda-ci, ymax=mda+ci),width=.1) +
  geom_line() +
  geom_point() + 
  ylab("MDA (nmol/g)") +
  scale_x_reverse(name = expression("Temperature " ( degree*C)))+  
  theme(legend.position = c(0.2,0.8),
        panel.grid.major=element_line(colour=NA),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.text=element_text(size=10,family = 'Times New Roman'),
        axis.title=element_text(size=12,family = 'Times New Roman'),
        axis.text = element_text(size=10,family = 'Times New Roman'),
   ) 

p2 <- ggplot(sodfc, aes(x=tm, y=sod, colour=species,fill=species)) + 
  geom_errorbar(aes(ymin=sod-ci, ymax=sod+ci), width=.1) +
  geom_line() +
  geom_point() + 
  ylab("SOD (U/g)") +
  scale_x_reverse(name = expression("Temperature " ( degree*C)))+ 
  theme(legend.position = c(0.2,0.8),
        panel.grid.major=element_line(colour=NA),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.text=element_text(size=10,family = 'Times New Roman'),
        axis.title=element_text(size=12,family = 'Times New Roman'),
        axis.text = element_text(size=10,family = 'Times New Roman'),
   ) 
 

multiplot(p1,p2,cols=2)+theme(legend.position = "none", 
                                    legend.direction = "none",
                                    legend.title = element_blank(),
                                    
)  







#?https://stackoverflow.com/questions/13649473/add-a-common-legend-for-combined-ggplots
