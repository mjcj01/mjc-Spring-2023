library(tidyverse)
library(sf)
library(stringr)
library(mgsub)

### Loading in files

colnames <- c("school_name", "state", "nces_school_id", "agency_name", "nces_agency_id", "school_level", "lowest_grade", "highest_grade")

es_2000_nces <- read_csv("UROC/bcps_nces_codes/elementary_school/es_2000.csv") %>%
ms_2000_nces <- read_csv("UROC/bcps_nces_codes/middle_school/ms_2000.csv")
hs_2000_nces <- read_csv("UROC/bcps_nces_codes/high_school/hs_2000.csv")

names(es_2000_nces) <- colnames
names(ms_2000_nces) <- colnames
names(hs_2000_nces) <- colnames

es_2000_shp <- st_read("UROC/school_boundary_files/ES2000/ES2000.shp") %>%
  mutate(SchoolName = str_to_upper(SchoolName)) %>%
  mutate(SchoolName = gsub(" ES", " ELEMENTARY", SchoolName))
ms_2000_shp <- st_read("UROC/school_boundary_files/MS2000/MS2000.shp") %>%
  mutate(SchoolName = str_to_upper(SchoolName)) %>%
  mutate(SchoolName = gsub(" MS", " MIDDLE", SchoolName))
hs_2000_shp <- st_read("UROC/school_boundary_files/HS2000/HS2000.shp")  %>%
  mutate(SchoolName = str_to_upper(SchoolName)) %>%
  mutate(SchoolName = gsub(" HS", " HIGH", SchoolName))

### Merging elementary school files

es_2000_shp$SchoolName <- mgsub(es_2000_shp$SchoolName, 
                                c("FEATHERBED LANE INTERMEDIATE", "FEATHERBED LANE PRIMARY",
                                  "LUTHERVILLE ELEMENTARY", "MARS ELEMENTARYTATES ELEMENTARY",
                                  "PADONIA ELEMENTARY", "WELLWOOD ELEMENTARY"),
                                c("FEATHERBED LANE ELEMENTARY/INTERMEDIATE", "FEATHERBED LANE ELEMENTARY",
                                  "LUTHERVILLE LABORATORY", "MARS ESTATES ELEMENTARY",
                                  "PADONIA INTERNATIONAL ELEMENTARY", "WELLWOOD INTERNATIONAL SCHOOL"))

es_2000 <- merge(es_2000_nces, es_2000_shp, by.x = "school_name", by.y = "SchoolName", all = TRUE) %>%
  mutate(nces_school_id = as.character(nces_school_id)) %>%
  st_as_sf() %>%
  mutate("has_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"))

es_2000_missing_nces <- es_2000 %>%
  filter(has_nces_key == FALSE) %>%
  pull(school_name)
es_2000_missing_geometry <- es_2000 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name)

### Merging middle school files

ms_2000_shp$SchoolName <- mgsub(ms_2000_shp$SchoolName,
                                c("DEER PARK MIDDLE", "LOCH RAVEN ACADEMY"),
                                c("DEER PARK MIDDLE MAGNET SCHOOL", "LOCH RAVEN TECHNICAL ACADEMY"))

ms_2000 <- merge(ms_2000_nces, ms_2000_shp, by.x = "school_name", by.y = "SchoolName", all = TRUE) %>%
  mutate(nces_school_id = as.character(nces_school_id)) %>%
  st_as_sf() %>%
  mutate("has_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"))

ms_2000_missing_nces <- ms_2000 %>%
  filter(has_nces_key == FALSE) %>%
  pull(school_name)
ms_2000_missing_geometry <- ms_2000 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name)

### Merging high school files

hs_2000_shp$SchoolName <- mgsub(hs_2000_shp$SchoolName,
                                c("PATAPSCO HIGH"),
                                c("PATAPSCO HIGH AND CENTER FOR ARTS"))

hs_2000 <- merge(hs_2000_nces, hs_2000_shp, by.x = "school_name", by.y = "SchoolName", all = TRUE) %>%
  mutate(nces_school_id = as.character(nces_school_id)) %>%
  st_as_sf() %>%
  mutate("has_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"))

hs_2000_missing_nces <- hs_2000 %>%
  filter(has_nces_key == FALSE) %>%
  pull(school_name)
hs_2000_missing_geometry <- hs_2000 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name)
