
# title: "sourcefile analysis"
# author: ""
# date: "2 December 2019"


### Packages

for (pckg in
     c
     ("data.table",
       "tidyverse",
       "viridis",
       "scico",
       "ggeffects",
       "ggpubr",
       "ggspatial",
       "sf",
       "purr"
       ))
{
  if (!require(pckg, character.only = T))
    install.packages(pckg, dependencies = TRUE)
  require(pckg, character.only = T)
}
