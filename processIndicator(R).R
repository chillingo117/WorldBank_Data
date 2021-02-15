library(readxl)
library(httr)
library(tidyverse)
library(magrittr)
library(glue)

# inputs are the indicator id and the variable of interest, both as character strings.
processIndicator <- function(indicator, variable){
  #get the excel file from the url and save it in the tempfile "excel"
  url <- glue("http://api.worldbank.org/v2/en/indicator/{indicator}?downloadformat=excel")
  GET(url, write_disk(excel <- tempfile(fileext = ".xls")))
  
  # to ensure consistency, we manually state the column types to be used
  text = rep("text", 4) # 4 character columns
  nums = rep("numeric", 2021-1960) # numeric columns for the years
  types = c(text, nums) # join them together to form our types vector
  
  # the excels from worldbank api have three junk rows of data above the desired data. 
  # so we skip 3 rows when reading this csv
  data <- read_excel(excel, skip=3, col_types = types)
  
  # set column names.
  years <- seq(1960,2021)
  colnames(data) = c("countryName", "countryCode","indicatorName","indicatorCode", years) 
  
  # removing the indicator columns, then grouping by year
  data %<>% select(-indicatorName, -indicatorCode)
  data %<>% gather(key = year, value = variable, -c(countryName, countryCode))
  
  # years below 2016 are irrelevant, due to the gkg dataset only going back to 2016
  data %<>% filter(year >= 2016)
  
  # there are no 2020 observations, so we can remove that year
  data %<>% filter(year != 2020)
  
  # remove all rows with NA for data
  data %<>% select(countryCode, year, variable) %>% na.omit()
  
  #rename the variable column to the actual variable name
  data %<>% setNames(c("countryCode", "year", glue("{variable}")))
  
  # save our tidy table
  data %>% write_csv(glue("{variable}.csv"))
}


# process the three used in our deliverable. Literacy rates, gdp per capita, and populations
# per country. More indicators can be found using 
processIndicator("SE.ADT.LITR.ZS", "literacy")
processIndicator("NY.GDP.PCAP.CD", "gdp")
processIndicator("SP.POP.TOTL", "population")
