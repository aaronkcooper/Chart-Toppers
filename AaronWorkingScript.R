library(tidyverse)
library(janitor)
economy <- read_csv("Global Economy Indicators.csv")
economy <- economy |> 
  clean_names()
economy <- economy |> 
  mutate(per_capita_gdp = gross_domestic_product_gdp/population)
medals <- read_csv("olympics/Olympic_Medal_Tally_History.csv")
#Filter for relevant economic data
medals <- filter(medals, year >= 1970)
#Filter for only Olympic years
economy <- filter(economy, year >= 1972 & year %% 2 == 0)
#Weighted medal total, Gold = 3, Silver = 2, Bronze = 1
medals <- medals |> 
  mutate(weighted_total = gold*3 + silver *2 + bronze)
#Can try to merge but some countries may have different names in each table.
merged <- merge(economy, medals, by = c("country", "year"))
unmatched <- anti_join(medals, economy, by = c("country", "year"))
#2022 economy data not here
countries <- economy |> 
  group_by(country) |> 
  summarise(count = n())
#No Taiwan
#Czechoslovakia (Former) = Czechoslovakia
#Democratic People's Republic of Korea = D.P.R. of Korea
#Germany is combined, in Olympics its east and west until unification
#Ethiopia (Former) = Ethiopia
#Great Britain = United Kingdom (i.e. Ireland is represented separately in Olympics)
#Hong Kong, China = China, Hong Kong SAR
#Iran (Islamic Republic of) = Islamic Republic of Iran
#Saudi Arabia = Kingdom of Saudi Arabia
#Former Netherlands Antilles = Netherlands Antilles
#China = People's Republic of China
#ROC = Russian Olympic Comittee 2018-2022
#Serbia and Montenegro are combined in olympics 1996-2004 following the breakup
#of Yugoslavia but separate in eco data
#Soviet Union = USSR (Former)
#The Bahamas = Bahamas
#Unified Team 1992, Former Soviet Union Countries
#U.R. of Tanzania: Mainland = United Republic of Tanzania 1980
#Venezuela (Bolivarian Republic of) = Venezuela
#Viet Nam = Vietnam
ranking <- merged |> 
  group_by(year) |> 
  mutate(gdp_rank = rank(-gross_domestic_product_gdp),
         medal_rank = rank(-total))
merged |> 
  arrange(desc(total))
