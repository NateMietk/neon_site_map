
################## Read in and process all spatial layers

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

# Import the forest groups and project to albers equal area
forests <- raster(file.path(forest_prefix, "conus_forestgroup.img")) %>%
  projectRaster(crs = "+init=epsg:2163", res = 500) %>%
  crop(as(states, "Spatial")) %>%
  mask(as(states, "Spatial"))

forest <- as.data.frame(as(forests, "SpatialPixelsDataFrame")) %>%
  mutate(forest_only = ifelse(conus_forestgroup == 0, 0, 1))

# Import the NEON domains and project to albers equal area
neon_domains <- st_read(dsn = domain_prefix,
                        layer = "NEON_Domains", quiet= TRUE) %>%
  st_transform("+init=epsg:2163") %>%  # e.g. US National Atlas Equal Area
  filter(!(DomainName %in% c("Taiga", "Tundra", "Pacific Tropical"))) %>%
  st_intersection(., st_union(states)) %>%
  mutate(id = row_number())

# Import the NEON sites, clean to terrestial only, and project to albers equal area
neon_sites <- st_read(dsn = site_prefix,
                      layer = "NEON_Field_Sites", quiet= TRUE) %>%
  st_transform("+init=epsg:2163") %>%  # e.g. US National Atlas Equal Area
  filter(!(State %in% c("AK", "HI", "PR"))) %>%
  filter(SiteType == "Core Terrestrial") %>%
  mutate(group = 1)

neon_forest_sites <- extract(forests, as(neon_sites, "Spatial"), df=TRUE, sp = TRUE) %>%
  st_as_sf() %>%
  filter(., conus_forestgroup != 0) %>%
  filter(SiteName != "LBJ National Grassland" &
           !(PMC %in% c("D16CT1", "D13CT1", "D12CT1", "D17CT1"))) %>%
  mutate(group = 'Forested')

neon_key_sites <- neon_sites %>%
  filter(PMC %in% c("D16CT1", "D13CT1", "D12CT1", "D17CT1")) %>%
  mutate(group = 'Key',
         id = row_number())

# Create data frames for map creation
neon_domains <- as(neon_domains, "Spatial")
nd_df <- fortify(neon_domains, region = 'id')

neon_forest_sites <- as(neon_forest_sites, "Spatial")
nsf_df <- data.frame(neon_forest_sites) 
nsf_df <-  nsf_df %>% 
  mutate(long = coords.x1,
         lat = coords.x2) 

neon_key_sites <- as(neon_key_sites, "Spatial")
nks_df <- data.frame(neon_key_sites) 
nks_df <-  nks_df %>% 
  mutate(long = coords.x1,
         lat = coords.x2)





