
source("src/R/get_data.R")
source("src/R/prepare_data.R")
source("src/R/plot_theme.R")

# Create the map

p <- ggplot() +
  
  # # # map the raster
  geom_raster(data = forest, aes(x = x,
                                 y = y,
                                 fill = factor(forest_only),
                                 alpha = factor(forest_only)),
              show.legend = FALSE) +
  scale_alpha_discrete(name = "", range = c(0, 1), guide = F) +
  scale_fill_manual(values = c("transparent", "green3")) +

  # map the neon domains
  geom_polygon(data=nd_df, aes(x = long, y = lat, group = group), 
               color='black', fill = "transparent", size = .10)+
  
  # map the forested sites that are not in the study
  geom_point(data = nsf_df, aes(x = long, y = lat, colour = group), size = 0.75, 
             colour = "black", fill = 'yellow', shape = 21) +
  geom_point(data = nj_df, aes(x = long, y = lat, colour = group), size = 0.75, 
             colour = "black", fill = 'yellow', shape = 21) +
  
  # map the forested sites that are in the study
  geom_point(data = nks_df,  aes(x = long, y = lat), size = 1,
             colour='#000000', fill = NA, shape = 18) +
  theme(legend.position = "none") +
  theme_map()

ggsave(file = "results/site_map.eps", p, width = 4, height = 3, 
       dpi = 300, units = "cm") #saves p
