library(tidyverse)
library(assertthat)
library(rvest)
library(httr)
library(purrr)
library(sf)
library(raster)

prefix <- file.path("data")
us_prefix <- file.path(prefix, "cb_2016_us_state_20m")
domain_prefix <- file.path(prefix, "NEONDomains_0")
site_prefix <- file.path(prefix, "neon_site")
forest_prefix <- file.path(prefix, "conus_forestgroup")

# Check if directory exists for all variable aggregate outputs, if not then create
var_dir <- list(prefix,
                us_prefix,
                domain_prefix,
                site_prefix,
                forest_prefix)

lapply(var_dir, function(x) if(!dir.exists(x)) dir.create(x, showWarnings = FALSE))

#Download the USA States layer

us_shp <- file.path(us_prefix, "cb_2016_us_state_20m.shp")
if (!file.exists(us_shp)) {
  loc <- "https://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_state_20m.zip"
  dest <- paste0(us_prefix, ".zip")
  download.file(loc, dest)
  unzip(dest, exdir = us_prefix)
  unlink(dest)
  assert_that(file.exists(us_shp))
}

#Download the NEON sites

site_shp <- file.path(site_prefix, "NEON_Field_Sites.shp")
if (!file.exists(site_shp)) {
  loc <- "http://www.neonscience.org/sites/default/files/NEONFieldSites-v15web.zip"
  dest <- paste0(site_prefix, ".zip")
  download.file(loc, dest)
  unzip(dest, exdir = site_prefix)
  unlink(dest)
  assert_that(file.exists(site_shp))
}


#Download the NEON domains

domain_shp <- file.path(domain_prefix, "NEON_Domains.shp")
if (!file.exists(domain_shp)) {
  loc <- "http://www.neonscience.org/sites/default/files/NEONDomains_0.zip"
  dest <- paste0(prefix, ".zip")
  download.file(loc, dest)
  unzip(dest, exdir = domain_prefix)
  unlink(dest)
  assert_that(file.exists(domain_shp))
}

#Download US forest groups

forest_img <- file.path(forest_prefix, "conus_forestgroup.img")
if (!file.exists(forest_img)) {
  loc <- "https://data.fs.usda.gov/geodata/rastergateway/forest_type/conus_forestgroup.zip"
  dest <- paste0(prefix, ".zip")
  download.file(loc, dest)
  unzip(dest, exdir = forest_prefix)
  unlink(dest)
  assert_that(file.exists(forest_img))
}
