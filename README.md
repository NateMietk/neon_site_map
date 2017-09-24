Main figure for the 2017 NSF Macrosystems proposal
================

Goals
------------

This script downloads all necessary data, processing them, and creates a reproducible map.

Requirements
------------

Downloading and processing the data requires that you have [R](https://www.r-project.org/) installed, and the following R packages:

-   tidyverse
-   raster
-   sf
-   assetthat
-   rvest
-   purrr

If you do not have these packages, you can try to install them with `install.packages()`, e.g.,

``` r
install.packages('tidyr')
```
Running the script
------------------

To run the R script, you can use `Rscript` from the terminal:

``` bash
Rscript map_data.R
```
This will call all R scripts and run all processess.

Tasks
------------

The script `get_data.R` pulls data from the internet, so you'll need an internet connection.  It will automatically verify that the data are currently not downloaded to your machine, created appropriate folder for storage, and unzip files.

The script `prepare_data.R` will process all neccesary spatial files to be fed into the ggplot map routine

The `map_data.R` script will create the map and save it as an *.eps* file in the results folder.  
