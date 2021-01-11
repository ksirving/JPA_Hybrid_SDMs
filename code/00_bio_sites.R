### bioassessment sites

library(tidyverse)
library(tidyr)

getwd()

## upload data from SOC

csci <- read.csv("input_data/CSCI_socal_bio_sites.csv")
head(csci)

csci <- csci %>%
  select(stationcode, latitude, longitude) %>%
  distinct()

write.csv(csci, "output_data/00_bio_sites.csv")
