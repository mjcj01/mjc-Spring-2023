library(tidyverse)
library(tigris)
library(tidycensus)
library(sf)

census_api_key("afca60b1a2ed4a17447e9630ddf64b4fd1394758", install = TRUE)

load_variables(2010, dataset = c("sf1")) %>% View()

vars <- c("P005001", "P005003", "P005004", "P005005", "P005006", "P005007", "P005008",
          "P005009", "P005010")

baltimore_county_block_data_all <- get_decennial(geography = "block",
                                             state = "MD",
                                             county = "Baltimore County",
                                             variables = vars,
                                             year = 2010,
                                             geometry = TRUE) %>% 
  group_by(GEOID, NAME, geometry) %>%
  summarise("C_WHITE" = sum(value[variable == "P005003"]),
            "C_BLACK" = sum(value[variable == "P005004"]),
            "C_AIAN" = sum(value[variable == "P005005"]),
            "C_ASIAN" = sum(value[variable == "P005006"]),
            "C_NHPI" = sum(value[variable == "P005007"]),
            "C_OTHER" = sum(value[variable == "P005008"]),
            "C_2MORE" = sum(value[variable == "P005009"]),
            "C_HISP" = sum(value[variable == "P005010"]),
            "C_TOTAL" = sum(value[variable == "P005001"])) %>%
  as.data.frame()

vars_18 <- c("P011001", "P011002", "P011005", "P011006", "P011007", "P011008", "P011009",
             "P011010", "P011011")

baltimore_county_block_data_18_up <- get_decennial(geography = "block",
                                                 state = "MD",
                                                 county = "Baltimore County",
                                                 variables = vars_18,
                                                 year = 2010,
                                                 geometry = TRUE) %>% 
  group_by(GEOID, NAME, geometry) %>%
  summarise("V_WHITE" = sum(value[variable == "P011005"]),
            "V_BLACK" = sum(value[variable == "P011006"]),
            "V_AIAN" = sum(value[variable == "P011007"]),
            "V_ASIAN" = sum(value[variable == "P011008"]),
            "V_NHPI" = sum(value[variable == "P011009"]),
            "V_OTHER" = sum(value[variable == "P011010"]),
            "V_2MORE" = sum(value[variable == "P011011"]),
            "V_HISP" = sum(value[variable == "P011002"]),
            "V_TOTAL" = sum(value[variable == "P011001"])) %>%
  as.data.frame()

baltimore_county_block_data <- merge(baltimore_county_block_data_18_up, baltimore_county_block_data_all,
                                     by = c("GEOID", "NAME", "geometry")) %>%
  mutate("Y_WHITE" = C_WHITE - V_WHITE,
         "Y_BLACK" = C_BLACK - V_BLACK,
         "Y_AIAN" = C_AIAN - V_AIAN,
         "Y_ASIAN" = C_ASIAN - V_ASIAN,
         "Y_NHPI" = C_NHPI - V_NHPI,
         "Y_OTHER" = C_OTHER - V_OTHER,
         "Y_2MORE" = C_2MORE - V_2MORE,
         "Y_HISP" = C_HISP - V_HISP,
         "Y_TOTAL" = C_TOTAL - V_TOTAL) %>%
  st_as_sf()

st_write(baltimore_county_block_data, "UROC//TidyCensus//BCPS Block Data 2010//bcps_census_2010.shp", append = FALSE)    

st_read("UROC//TidyCensus//BCPS Block Data 2010//bcps_census_2010.shp") %>%
  names()
