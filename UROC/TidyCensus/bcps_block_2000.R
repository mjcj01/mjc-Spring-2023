library(tidyverse)
library(tigris)
library(tidycensus)
library(sf)

load_variables(2000, dataset = c("sf1")) %>% View()

vars_2000 <- c("P004001", "P004002", "P004005", "P004006", "P004007", "P004008",
          "P004009", "P004010", "P004011")

baltimore_county_block_data_all_2000 <- get_decennial(geography = "block",
                                                      state = "MD",
                                                      county = "Baltimore County",
                                                      variables = vars_2000,
                                                      year = 2000,
                                                      geometry = TRUE) %>% 
  group_by(GEOID, NAME, geometry) %>%
  summarise("C_WHITE" = sum(value[variable == "P004005"]),
            "C_BLACK" = sum(value[variable == "P004006"]),
            "C_AMIN" = sum(value[variable == "P004007"]),
            "C_ASIAN" = sum(value[variable == "P004008"]),
            "C_NHPI" = sum(value[variable == "P004009"]),
            "C_OTHER" = sum(value[variable == "P004010"]),
            "C_2MORE" = sum(value[variable == "P004011"]),
            "C_HISP" = sum(value[variable == "P004002"]),
            "C_TOTAL" = sum(value[variable == "P004001"])) %>%
  as.data.frame()

vars_18_2000 <- c("P006001", "P006002", "P006005", "P006006", "P006007", "P006008",
             "P006009", "P006010", "P006011")

baltimore_county_block_data_18_up_2000 <- get_decennial(geography = "block",
                                                        state = "MD",
                                                        county = "Baltimore County",
                                                        variables = vars_18_2000,
                                                        year = 2000,
                                                        geometry = TRUE) %>% 
  group_by(GEOID, NAME, geometry) %>%
  summarise("V_WHITE" = sum(value[variable == "P006005"]),
            "V_BLACK" = sum(value[variable == "P006006"]),
            "V_AMIN" = sum(value[variable == "P006007"]),
            "V_ASIAN" = sum(value[variable == "P006008"]),
            "V_NHPI" = sum(value[variable == "P006009"]),
            "V_OTHER" = sum(value[variable == "P006010"]),
            "V_2MORE" = sum(value[variable == "P006011"]),
            "V_HISP" = sum(value[variable == "P006002"]),
            "V_TOTAL" = sum(value[variable == "P006001"])) %>%
  as.data.frame()

baltimore_county_block_data_2000 <- merge(baltimore_county_block_data_18_up_2000, baltimore_county_block_data_all_2000,
                                          by = c("GEOID", "NAME", "geometry")) %>%
  mutate("Y_WHITE" = C_WHITE - V_WHITE,
         "Y_BLACK" = C_BLACK - V_BLACK,
         "Y_AMIN" = C_AMIN - V_AMIN,
         "Y_ASIAN" = C_ASIAN - V_ASIAN,
         "Y_NHPI" = C_NHPI - V_NHPI,
         "Y_OTHER" = C_OTHER - V_OTHER,
         "Y_2MORE" = C_2MORE - V_2MORE,
         "Y_HISP" = C_HISP - V_HISP,
         "Y_TOTAL" = C_TOTAL - V_TOTAL) %>%
  st_as_sf()

st_write(baltimore_county_block_data_2000, "UROC//TidyCensus//BCPS Block Data 2000//bcps_census_2000.shp", append = FALSE)    

st_read("UROC//TidyCensus//BCPS Block Data 2010//bcps_census_2010.shp") %>%
  names()
