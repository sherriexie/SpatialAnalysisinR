library(tidyverse)
library(sf)
library(tmap)

setwd("/Users/sxs/Dropbox/R:Medicine/")

# Load NY Lyme data
# Source: https://health.data.ny.gov/Health/Community-Health-Lyme-Disease-Incidence-Rate-per-1/6sxr-cqij
# Variable Percent.Rate gives the incidence rate per 100,000 by county in 2014-2016
lyme <- read.csv("LymeData.csv")
dim(lyme)

# Load NY county shapefile 
# Source: https://gis.ny.gov/gisdata/inventories/details.cfm?DSID=927
nycounties <- st_read("NYS_Counties.shp/Counties.shp")
plot(st_geometry(nycounties))
head(nycounties)
dim(nycounties)

# Merge Lyme data with county shapefiles
nycounties$County.Name <- nycounties$NAME
ny_lyme <- left_join(nycounties, lyme) %>%
  mutate(Lyme.Incidence.Rate = Percent.Rate) %>%
  select(NAME, FIPS_CODE, Health.Topic, Indicator, Measure.Unit, 
         Lyme.Incidence.Rate, Data.Years, Data.Source) 
head(ny_lyme)
plot(st_geometry(ny_lyme))

# static map
tm_shape(ny_lyme) +
  tm_polygons("Lyme.Incidence.Rate")

# interactive map
tmap_mode("view")
tm_shape(ny_lyme) +
  tm_polygons("Lyme.Incidence.Rate")

# Save data
saveRDS(ny_lyme, "nys_lyme_data.rds")
