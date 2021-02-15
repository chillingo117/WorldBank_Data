library(tidyverse)
library(magrittr)
library(readxl)
library(naniar)
library(glue)

compare = function(first, second){
  # read both csvs using input strings
  firstcsv <- read_csv(glue("{first}.csv"), col_type = "cnn")
  secondcsv <- read_csv(glue("{second}.csv"), col_type = "cnn")
  
  #full join the two csvs on countryCode and year
  joined <- firstcsv %>% full_join(secondcsv, by=c("countryCode", "year"))
  
  # get the variable names (as strings)
  x = names(joined)[3]
  y = names(joined)[4]
  
  # ensym converts string to symbol, !! removes the quotes. This allows for variable column names
  plot <- joined %>% ggplot(aes(x = !!ensym(x), y = !!ensym(y)))
  plot + geom_jitter() + geom_smooth()
}

# this can then be done for any variable names chosen by a user in processIndicator
compare("literacy", "gdp")