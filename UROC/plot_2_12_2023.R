library(tidyverse)
library(sf)
library(ggthemes)
library(RColorBrewer)
library(showtext)
library(gridExtra)
library(grid)
library(formattable)

font_add_google("Lexend", "Lexend")
showtext_auto()

plot_table <- es_2020 %>%
  as.data.frame() %>%
  summarise("Enrolled White Students" = sum(S_WHITE),
            "Enrolled Black Students" = sum(S_BLACK),
            "Enrolled Asian Students" = sum(S_ASIAN),
            "Enrolled Hispanic Students" = sum(S_HISP),
            "Enrolled American Indian or 
            Alaskan Native Students" = sum(S_AMIN),
            "Enrolled Native Hawaiian or 
            Pacific Islander Students" = sum(S_NHPI),
            "Enrolled Students of Multiple Races" = sum(S_2MORE)) %>%
  t() %>%
  as.data.frame()

names(plot_table) <- c("Student Count")

plot_table <- plot_table  %>%
  mutate("Percentage" = paste(round(`Student Count` / sum(`Student Count`) * 100, digits = 2), "%", sep = "")

ggplot(data = es_2020, aes(fill = TOTSTUD)) +
  geom_sf(linewidth = 0.625) +
  scale_fill_fermenter(breaks = c(200, 400, 600, 800), palette = "Blues", direction = 1,
                       guide = guide_legend(title = "Student Count")) +
  theme_map() +
  labs(title = paste("Baltimore County Public Schools", "Elementary AZBs", sep = " ")) +
  theme(plot.title = element_text(family = "Lexend", size = 25),
        plot.subtitle = element_text(family = "Lexend", size = 22.5),
        legend.title = element_text(family = "Lexend", size = 16),
        legend.text = element_text(family = "Lexend", size = 14),
        legend.position = c(0.8, 0.175),
        #legend.position = "right",
        legend.key.size = unit(1.5, "cm"),
        #legend.margin = margin(t = 10, r = 0, b = 1, l = 0, unit = "cm"),
        legend.background = element_blank(),
        legend.box.just = "left",
        plot.margin = margin(t = 0, r = 0, b = 10, l = 0, unit = "cm"),
        text = element_text(family = "Lexend", color = "#000000")) +
  coord_sf(xlim = c(-76.8956, -76), ylim = c(39.15206, 39.72131), clip = "off") +
  theme(plot.margin = unit(c(1,3,1,1), "lines")) +
  annotation_custom(tableGrob(plot_table),
                    xmin = -76.3,
                    ymin = 39.4)
