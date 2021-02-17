library(dplyr)
library(gapminder)

head(gapminder)

gapminder %>% 
  filter(continent == "Europe",
         country %in% c("Germany", "Switzerland"),
         year == 2007)
