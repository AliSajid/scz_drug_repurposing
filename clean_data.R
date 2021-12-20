# Clean the data and process it
#

library(tidyverse)

d <- read_csv("raw/Lookup_Table_with_pvalues_2021-12-16 15_41_23.csv")

clean <- d |>
  pivot_longer(cols = -HGNC_Symbol, names_to = "dataset") |>
  separate(value, into = c("LFC", "p"), sep = ", p=") |>
  mutate(LFC = as.numeric(LFC),
         p = as.numeric(p)) |>
  write_csv("data/clean_data.csv")

separated <- clean |>
  group_by(dataset) |>
  group_map(~ write_csv(.x, str_glue("data/{.y}-signature.csv")))
