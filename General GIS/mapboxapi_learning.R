library(tidyverse)
library(sf)
library(osmdata)
library(leaflet)
library(ggthemes)

centre_county <- getbb("Centre County, Pennsylvania")

query_bus_lines <- opq(bbox = centre_county, timeout = 120) %>% 
  add_osm_feature(key = 'route', value = 'bus')

query_bus_lines_sf <- query_bus_lines %>% 
  osmdata_sf()

sc_bus_lines <- query_bus_lines_sf$osm_lines

query_bus_stops <- opq(bbox = centre_county, timeout = 120) %>% 
  add_osm_feature(key = 'public_transport', value = 'platform')

query_bus_stops_sf <- query_bus_stops %>% 
  osmdata_sf()

sc_bus_stops <- query_bus_stops_sf$osm_points %>%
  filter(!is.na(name)) %>%
  filter(!grepl("East Pine Grove Road", name) &
           !grepl("West Pine Grove Road", name) &
           !grepl("Tadpole Road", name) &
           !grepl("Fairbrook Drive", name) &
           !grepl("Ramblewood Road", name) &
           !grepl("West Blade", name) &
           !grepl("4805 Whitehall Road", name) &
           !grepl("4802 Whitehall Road", name) &
           !grepl("Gardener Lane", name) &
           !grepl("1060 Pine Grove Road", name) &
           !grepl("Opposite 4300 Whitehall Road", name) &
           !grepl("Pine Grove Road at Plainfield Drive", name))

walk_5 <- mb_isochrone(sc_bus_stops, profile = "walking", time = 5) %>%
  st_union()
walk_10 <- mb_isochrone(sc_bus_stops, profile = "walking", time = 10) %>%
  st_union()
walk_20 <- mb_isochrone(sc_bus_stops, profile = "walking", time = 20) %>%
  st_union()

walk_10_crop <- st_difference(walk_10, walk_5)
walk_20_crop <- st_difference(walk_20, walk_10)

ggplot() +
  geom_sf(data = walk_5, fill = "#ece7f2") +
  geom_sf(data = walk_10_crop, fill = "#a6bddb") +
  geom_sf(data = walk_20_crop, fill = "#2b8cbe") +
  geom_sf(data = sc_bus_lines, color = "#000000") +
  geom_sf(data = sc_bus_stops, size = 1) +
  coord_sf(xlim = c(-78,-77.7), ylim = c(40.7, 40.95)) +
  theme_map()

leaflet() %>%
  addPolylines(data = sc_bus_lines, color = "black", weight = 1) %>%
  addPolygons(data = walk_10_crop, color = "#a6bddb", weight = 2) %>%
  addPolygons(data = walk_20_crop, color = "#2b8cbe", weight = 2) %>%
  addPolygons(data = walk_5, color = "#ece7f2", weight = 2) %>%
  addTiles()
