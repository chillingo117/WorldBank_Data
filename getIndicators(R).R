library(tidyverse)
library(magrittr)
library(glue)
library(rvest)
library(httr)

# using worlbanks api, request some indicators (recieves xml and stores as tree)
url = "http://api.worldbank.org/v2/indicator"
minitree <- read_xml(url)

# get the total amount of ids available
minitree %>% xml_attrs()
total <- minitree %>% xml_attr("total")

# requests the indicators again, except with a per_page value equal to the total amount of indicators
# available (effectively presenting all indicators in a single xml)
url = glue("http://api.worldbank.org/v2/indicator?per_page={total}")
tree <- read_xml(url)

# from all the children in the tree (each indicator), retrieve the id value and store as all_ids
children <- tree %>% xml_children()
all_ids <- xml_attr(children, "id")
all_ids %>% head()

# repeat above, except extract the names of each indicator
children <- tree %>% xml_children()
all_names <- xml_text(children)
all_names %>% head()

# bind the two vectors of ids and names together. Since they were from the same page, and the order
# the children will be the same, these two vectors will be bind the ids and names for each indicator
# correctly
available_indicators <- cbind(all_ids, all_names)

# convert matrix to tibble and save as indicators.csv
available_indicators %<>% as_tibble()
available_indicators %>% write_csv("indicators.csv")