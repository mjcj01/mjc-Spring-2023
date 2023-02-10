library(tidyverse)
library(tidycensus)
library(sf)

census_api_key("afca60b1a2ed4a17447e9630ddf64b4fd1394758", install = TRUE)

load_variables(2010, dataset = c("sf1")) %>% View()

vars <- c("P005001", "P005003", "P005004", "P005005", "P005006", "P005007", "P005008",
          "P005009", "P005010")

get_decennial(
  geography = "block",
  state = "MD",
  county = "Baltimore County",
  variables = vars,
  year = 2010) %>% 
  group_by(GEOID, NAME) %>%
  summarise(
    "C_WHITE" = sum(value[variable == "P005003"]),
    "C_BLACK" = sum(value[variable == "P005004"]),
    "C_AIAM" = sum(value[variable == "P005005"]),
    "C_ASIAN" = sum(value[variable == "P005006"]),
    "C_NHPI" = sum(value[variable == "P005007"]),
    "C_OTHER" = sum(value[variable == "P005008"]),
    "C_TWOMORE" = sum(value[variable == "P005009"]),
    "C_HISPANIC" = sum(value[variable == "P005010"]),
    "C_TOTAL" = sum(value[variable == "P005001"])
  )
