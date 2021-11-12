## data formatting

## packages
library(tidyverse)
library(tidyr)
library(CSCI)     

## regional sites - add more from SOC
bio_sites <- read.csv("output_data/00_bio_sites.csv")
head(bio_sites)


## occurrences - statewide

occs <- read.csv("input_data/all_tax_data.csv")
head(occs)

## get only sites
state_sites <- occs %>%
  select(stationcode) %>%
  distinct()

dim(state_sites) ## 6186

## number of sites with bio data
sum(state_sites$stationcode %in% bio_sites$stationcode) ## 396

## subset state data to reg bio sites

occsSub <- occs %>%
  select(stationcode, sampledate, replicate, finalid) %>%
  distinct()

head(occsSub)

occsSub <- occsSub %>%
  filter(stationcode %in% bio_sites$stationcode)
  
## count how many species per site
length(occsSub$finalid)

str(occsSub)
sppcount <- occsSub %>%
  group_by(stationcode) %>%
  summarise(sppcount = length(finalid))

head(sppcount)

#### how many species?

species_known <- unique(occsSub$finalid) # 718

## uplaod traits from csci package
mydf<-loadMetaData()          
head(mydf)

unique(mydf$FunctionalFeedingGroup)

traits <- mydf %>%
  select(FinalID:Subphylum, Invasive, Source)

species_traits <- read.csv("output_data/01_species_tolerance_FFG_df.csv")

## remove  occurrence < 50

species_traits_red <- species_traits %>%
  filter(!count < 50) %>%
  select(-Species) %>%
  distinct()

head(species_traits_red)  
species_have_traits <- unique(species_traits_red$FinalID) ## 145

## how many species with trait data and found in bio sites

sum(species_have_traits %in% species_known) ## 145

## subset occurrence data to species that have traits
names(occsSub)
species_to_use <- occsSub %>%
  filter(finalid %in% species_have_traits) %>%
  rename(FinalID = finalid)

dim(species_to_use)

unique(species_to_use$FinalID) ## 145 yay!

## combine traits data with occurrence data 

all_data <- full_join(species_to_use, species_traits_red, by = "FinalID")
dim(all_data)
## add lat lon from bio sites

all_data <- full_join(all_data, bio_sites, by="stationcode")

write.csv(all_data, "output_data/02_species_occs_traits.csv")


# env data ----------------------------------------------------------------

dh_data <- read.csv("/Volumes/Biology/San Juan WQIP_KTQ/Data/Working/Regional_Curves_CSCI_ASCI_Annie/Data/Flow/subset_woutLARsitematches/DeltaH_FINAL/deltaH_summary_badyrs_nonzero.csv")
head(dh_data)

spp_sites <- unique(all_data$stationcode )
spp_sites ## 397

dh_median <- dh_data %>%
  filter(summary.statistic =="median") %>%
  rename(stationcode = site) %>%
  filter(stationcode %in% spp_sites) %>%
  select(stationcode, flow_metric, water_year_type, deltaH) %>%
  pivot_wider(names_from = "flow_metric", values_from = "deltaH")

head(dh_median)
## use median of current ffm value?

write.csv(dh_median, "output_data/02_delta_h_spp_sites.csv") 
## loads of NAs, what do do? remove site if 70% od data missing? remove metric if 70% data missing?


