library(tidyverse)
library(sf)
library(ggthemes)
library(formattable)

ggplot() + 
  geom_sf(data = shapefile, aes(fill = TOTSTUD)) +
  theme_map() +
  ggtitle(label = "Baltimore County Public Schools",
          subtitle = "Data from 2020") +
  theme(
    plot.title = element_text(family = "Lexend", size = 15),
    plot.subtitle = element_text(family = "Lexend", size = 12.5),
    legend.title = element_text(family = "Lexend", size = 10),
    legend.text = element_text(family = "Lexend", size = 8),
    legend.position = "right",
    panel.background = element_blank()
  )

table <- as.data.frame(shapefile) %>%
  select(schnam, TOTSTUD, S_WHITE, S_BLACK, S_HISP, S_ASIAN, S_AMIN, S_NHPI, S_2MORE) %>%
  rename(
    "Total Students" = TOTSTUD,
    "White Students" = S_WHITE,
    "Black Students" = S_BLACK,
    "Hispanic Students" = S_HISP,
    "Asian Students" = S_ASIAN,
    "American Indian Students" = S_AMIN,
    "Native Hawaiian & Pacific Islander Students" = S_NHPI,
    "Students with 2 or More Races" = S_2MORE
  ) %>%
  data.table::setorder(., cols = - "Total Students")

row.names(table) <- NULL
formattable(table, list(`White Students`= formatter("span", 
                                                         style = x ~ style(display = "block",
                                                                           "border-radius" = "4px",
                                                                           "padding-right" = "4px",
                                                                           color = "white",
                                                                           "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `Black Students`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `Hispanic Students`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `Asian Students`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `American Indian Students`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `Native Hawaiian & Pacific Islander Students`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff")))),
                        `Students with 2 or More Races`= formatter("span", 
                                                    style = x ~ style(display = "block",
                                                                      "border-radius" = "4px",
                                                                      "padding-right" = "4px",
                                                                      color = "white",
                                                                      "background-color" = csscolor(gradient(as.numeric(x), "#323232", "#99e4ff"))))))

            