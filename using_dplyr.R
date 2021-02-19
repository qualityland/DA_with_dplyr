library(dplyr)
library(gapminder)
library(ggplot2)

head(gapminder)

gapminder %>% 
  filter(continent == "Europe",
         country %in% c("Germany", "Switzerland"),
         year == 2007)
gm2007 <- gapminder %>% 
  filter(year == 2007)

ggplot(data = gm2007) +
  geom_point(mapping = aes(
    x = gdpPercap,
    y = lifeExp,
    color = continent,
    size = pop))
