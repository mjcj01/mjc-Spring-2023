library(tidyverse)
library(sf)
library(stringr)
library(mgsub)

### Loading in files

colnames <- c("school_name", "state", "nces_school_id", "agency_name", "nces_agency_id", "school_level", "lowest_grade", "highest_grade")

es_2010_nces <- read_csv("UROC/bcps_nces_codes/elementary_school/es_2010.csv")
ms_2010_nces <- read_csv("UROC/bcps_nces_codes/middle_school/ms_2010.csv")
hs_2010_nces <- read_csv("UROC/bcps_nces_codes/high_school/hs_2010.csv")

names(es_2010_nces) <- colnames
names(ms_2010_nces) <- colnames
names(hs_2010_nces) <- colnames

es_2010_shp <- st_read("UROC/school_boundary_files/ES2010/Baltimore_County_2010_ES.shp")
ms_2010_shp <- st_read("UROC/school_boundary_files/MS2010/Baltimore_County_2010_MS.shp")
hs_2010_shp <- st_read("UROC/school_boundary_files/HS2010/Baltimore_County_2010_HS.shp")

### Merging elementary school files

es_2010_shp$schnam <- mgsub(es_2010_shp$schnam,
                            c("CHURCH LANE ELEMENTARY TECHNOLOGY", "WELLWOOD INTERNATIONAL ELEMENTARY"),
                            c("CHURCH LANE ELEMENTARY", "WELLWOOD INTERNATIONAL SCHOOL"))

es_2010 <- merge(es_2010_nces, es_2010_shp, by.x = "school_name", by.y = "schnam", all = TRUE) %>%
  st_as_sf() %>%
  mutate("on_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"),
         "nces_ids_same" = ifelse(is.na(nces_school_id), "No NCES Key ID",
                                  ifelse(is.na(NCES_ID), "No SHP ID",
                                  ifelse(NCES_ID == nces_school_id, "TRUE", "FALSE"))))

es_2010_missing_nces <- es_2010 %>%
  filter(on_nces_key == FALSE) %>%
  pull(school_name) %>%
  str_to_title()
es_2010_missing_geometry <- es_2010 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name) %>%
  str_to_title()

### Merging middle school files

ms_2010_shp$schnam <- mgsub(ms_2010_shp$schnam,
                            c("PARKVILLE MIDDLE & CENTER OF TECHNOLOGY"),
                            c("PARKVILLE MIDDLE"))

ms_2010 <- merge(ms_2010_nces, ms_2010_shp, by.x = "school_name", by.y = "schnam", all = TRUE) %>%
  st_as_sf() %>%
  mutate("on_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"),
         "nces_ids_same" = ifelse(is.na(nces_school_id), "No NCES Key ID",
                                  ifelse(is.na(NCES_ID), "No SHP ID",
                                         ifelse(NCES_ID == nces_school_id, "TRUE", "FALSE"))))

ms_2010_missing_nces <- ms_2010 %>%
  filter(on_nces_key == FALSE) %>%
  pull(school_name) %>%
  str_to_title()
ms_2010_missing_geometry <- ms_2010 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name) %>%
  str_to_title()

### Merging high school files

hs_2010_shp$schnam <- mgsub(hs_2010_shp$schnam,
                            c("KENWOOD HIGH IB AND SPORTS SCIENCE", "LANSDOWNE HIGH & ACADEMY OF FINANCE",
                              "OVERLEA HIGH & ACADEMY OF FINANCE", "PARKVILLE HIGH & CENTER FOR MATH/SCIENCE",
                              "PATAPSCO HIGH & CENTER FOR ARTS", "TOWSON HIGH LAW & PUBLIC POLICY",
                              "WOODLAWN HIGH CENTER FOR PRE-ENG. RES."),
                            c("KENWOOD HIGH", "LANSDOWNE HIGH", "OVERLEA HIGH", "PARKVILLE HIGH",
                              "PATAPSCO HIGH AND CENTER FOR ARTS", "TOWSON HIGH", "WOODLAWN HIGH"))

hs_2010 <- merge(hs_2010_nces, hs_2010_shp, by.x = "school_name", by.y = "schnam", all = TRUE) %>%
  st_as_sf() %>%
  mutate("on_nces_key" = ifelse(is.na(nces_school_id), "FALSE", "TRUE"),
         "has_geometry" = ifelse(is.na(st_dimension(geometry)), "FALSE", "TRUE"),
         "nces_ids_same" = ifelse(is.na(nces_school_id), "No NCES Key ID",
                                  ifelse(is.na(NCES_ID), "No SHP ID",
                                         ifelse(NCES_ID == nces_school_id, "TRUE", "FALSE"))))

hs_2010_missing_nces <- hs_2010 %>%
  filter(on_nces_key == FALSE) %>%
  pull(school_name) %>%
  str_to_title()
hs_2010_missing_geometry <- hs_2010 %>%
  filter(has_geometry == FALSE) %>%
  pull(school_name) %>%
  str_to_title()

### Exporting checks

es_2010 %>%
  as.data.frame() %>%
  select(school_name, on_nces_key, has_geometry, nces_ids_same) %>%
  write.csv(., "UROC/bcps_nces_codes/checks/es_2010_check.csv", row.names = FALSE)

ms_2010 %>%
  as.data.frame() %>%
  select(school_name, on_nces_key, has_geometry, nces_ids_same) %>%
  write.csv(., "UROC/bcps_nces_codes/checks/ms_2010_check.csv", row.names = FALSE)

hs_2010 %>%
  as.data.frame() %>%
  select(school_name, on_nces_key, has_geometry, nces_ids_same) %>%
  write.csv(., "UROC/bcps_nces_codes/checks/hs_2010_check.csv", row.names = FALSE)
