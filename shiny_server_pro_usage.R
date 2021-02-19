library(readxl)
library(lubridate)
library(dplyr)
library(ggplot2)

# what sheets do we have?
#readxl::excel_sheets(path = "data/DaVinci_ShinyApps.xlsx")

# load raw user data
user_raw <- readxl::read_xlsx(path = "data/DaVinci_ShinyApps.xlsx",
                              sheet = "Complete unique user list")

# user column names
colnames(user_raw) <- c("unique_id",
                        "user_org_l1",
                        "user_org_l2",
                        "user_org_l3")

# user data
user <- user_raw %>% 
  mutate(user_id = tolower(unique_id)) %>% 
  select(user_id, user_org_l1, user_org_l2, user_org_l3)

# load raw access data
access_raw <- readxl::read_xlsx(path = "data/DaVinci_ShinyApps.xlsx",
                  sheet = "ShinyApps-ServerPro",
                  col_types = replicate(8, "text"))

# sensible column names
colnames(access_raw) = c("r_version",
                         "developer_id",
                         "app_name",
                         "user_id",
                         "last_used_str",
                         "year",
                         "month",
                         "half_year")

# access data
access <- access_raw %>%
  mutate(last_used = ymd(last_used_str)) %>% 
  left_join(user, by = "user_id") %>% 
  select(app_name, last_used, developer_id, r_version, user_id, user_org_l1, user_org_l2, user_org_l3)

# cleanup memory
rm(access_raw, user_raw)

# what apps did Markus use?
access %>% 
  filter(user_id == "langema8")

# shiny apps
shiny_apps <- access %>% 
  select(app_name) %>% 
  arrange(app_name) %>% 
  distinct()

head(shiny_apps)
tail(shiny_apps)

# shiny apps with "test"
shiny_apps %>% 
  filter(grepl("test", ignore.case = TRUE, app_name))


# developers
access %>%
  select(developer_id) %>% 
  arrange(developer_id) %>% 
  distinct()


# users
access %>%
  select(user_id) %>% 
  arrange(user_id) %>% 
  distinct()


ggplot(data = access) +
  geom_histogram(mapping = aes(x = last_used))

access %>% 
  group_by(last_used) %>% 
  summarise(n = n())

ggplot(data = access) +
  geom_line(mapping = aes(x = last_used))
