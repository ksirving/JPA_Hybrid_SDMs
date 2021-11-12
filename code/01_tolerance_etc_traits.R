### csci meta data

# library(devtools)
# 
# install_github("SCCWRP/CSCI", force=T)
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

## remove  occurrence < 50

species_traits_red <- species_traits %>%
  filter(!count < 50) %>%
  select(-Species) %>%
  distinct()

head(species_traits_red)  
unique(species_traits_red$FinalID) ## 145

## split into difference tolerance categories

lowTol <- species_traits_red %>%
  filter(ToleranceValue %in% c(0,1,2,3))

sort(unique(lowTol$FinalID)) ## 26


medTol <- species_traits_red %>%
  filter(ToleranceValue %in% c(4,5,6))

sort(unique(medTol$FinalID)) ## 81


highTol <- species_traits_red %>%
  filter(ToleranceValue %in% c(7,8,9,10))

sort(unique(highTol$FinalID)) ## 38



  
