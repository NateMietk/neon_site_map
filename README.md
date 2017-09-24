# Main figure for the 2017 NSF Macrosystems proposal

This script downloads all necessary data, processing them, and creates a reproducible map.

To create the image simply run the src/R/map_data.R script.  This will call the src/R/get_data.R, src/R/prepare_data.R, and the src/R/plot_theme.R scripts necessary to create the map.  The get_data.R script will create data folders, download the data from web links, and unzip the files.  The prepare_data.R script will process all neccesary spatial files to be fed into the ggplot map routine.  The map_data.R script will create the map and save it as an *.eps file in the results folder.  