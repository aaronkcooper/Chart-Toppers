library(tidyverse)
library(janitor)
economy <- read_csv("Global Economy Indicators.csv")
economy <- economy |> 
  clean_names()
economy <- economy |> 
  mutate(per_capita_gdp = gross_domestic_product_gdp/population)
countries <- read_csv("olympics/Olympic_Country_Profiles.csv")
medals <- read_csv("olympics/Olympic_Medal_Tally_History.csv")
#Filter for relevant economic data
medals <- filter(medals, year >= 1970)
#Filter for only Olympic years
economy <- filter(economy, year >= 1972 & year %% 2 == 0)
#Weighted medal total, Gold = 3, Silver = 2, Bronze = 1
medals <- medals |> 
  mutate(weighted_total = gold*3 + silver *2 + bronze)
#Can try to merge but some countries may have different names in each table.