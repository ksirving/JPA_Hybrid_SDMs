### csci meta data

library(devtools)

install_github("SCCWRP/CSCI", force=T)
library(CSCI)     
library(tidyverse)
library(tidyr)

## uplaod traits from csci package
mydf<-loadMetaData()          
head(mydf)

traits <- mydf %>%
  select(FinalID:Subphylum, Invasive, Source)

## upload species ranking 
species <- read.csv("input_data/BMI_Rank_Study_area.csv")
head(species)

species <- species %>%
  rename(FinalID = species)

sum(species$species %in% mydf$Genus) ## 383

## join dfs

species_traits <- full_join(species, traits, by="FinalID")

head(species_traits)


write.csv(species_traits, "output_data/01_species_tolerance_FFG_df.csv")


