library(tidyverse)
library(sf)
library(raster)
library(rasterVis)
source("src/R/get_data.R")

################## Read in all spatial layers

# Import the US States and project to albers equal area
states <- st_read(dsn = us_prefix,
                  layer = "cb_2016_us_state_20m", quiet= TRUE) %>%
  st_transform("+init=epsg:2163") %>%  # e.g. US National Atlas Equal Area
  filter(!(NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))) %>%
  mutate(group = 1) %>%
  st_simplify(., preserveTopology = TRUE)

# Dissolve to the USA Boundary
conus <- states %>%
  group_by(group) %>%
  summarize()

# Import the NEON sites, clean to terrestial only, and project to albers equal area
neon_sites <- st_read(dsn = site_prefix,
                      layer = "NEON_Field_Sites", quiet= TRUE) %>%
  st_transform("+init=epsg:2163") %>%  # e.g. US National Atlas Equal Area
  filter(!(State %in% c("AK", "HI", "PR"))) %>%
  filter(SiteType == "Core Terrestrial")

# Import the NEON domains and project to albers equal area
neon_domains <- st_read(dsn = domain_prefix,
                        layer = "NEON_Domains", quiet= TRUE) %>%
  st_transform("+init=epsg:2163") %>%  # e.g. US National Atlas Equal Area
  filter(!(DomainName %in% c("Taiga", "Tundra", "Pacific Tropical"))) %>%
  st_intersection(., st_union(states))

# Import the forest groups and project to albers equal area
forests <- raster(file.path(forest_prefix, "conus_forestgroup.img")) %>%
  projectRaster(crs = "+init=epsg:2163", res = 2000) %>%
  crop(as(states, "Spatial")) %>%
  mask(as(states, "Spatial"))


miat = c(1, 0)
levelplot(forests, contour = TRUE, margin = FALSE, at = miat, par.settings = GrTheme)





