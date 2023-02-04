library(tidyverse)
library(sf)

colnames <- c("school_name", "state", "nces_school_id", "agency_name", "nces_agency_id", "school_level", "lowest_grade", "highest_grade")

es_2000_nces <- read_csv("UROC/bcps_nces_codes/elementary_school/es_2000.csv")
ms_2000_nces <- read_csv("UROC/bcps_nces_codes/middle_school/ms_2000.csv")
hs_2000_nces <- read_csv("UROC/bcps_nces_codes/high_school/hs_2000.csv")

names(es_2000_nces) <- colnames
names(ms_2000_nces) <- colnames
names(hs_2000_nces) <- colnames

es_2000_shp <- st_read("UROC/school_boundary_files/ES2000/ES2000.shp")
ms_2000_shp <- st_read("UROC/school_boundary_files/MS2000/MS2000.shp")
hs_2000_shp <- st_read("UROC/school_boundary_files/HS2000/HS2000.shp")

