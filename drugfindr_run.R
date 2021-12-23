# Run all datasets across all combinations

library(tidyverse)
library(drugfindR)

output_lib <- "CP"
filter_threshold <- 0.2
similarity_threshold <- 0.20
discordant <- c(TRUE)
gene_column <- "HGNC_Symbol"
logfc_column <- "LFC"
pval_column <- "p"


dataset <- read_csv("data/clean_data.csv") |>
  filter(!is.na(LFC)) |>
  group_by(dataset) |>
  nest() |>
  mutate(ranging = map(data, ~ range(.x$LFC))) |>
  unnest_wider(ranging)

parameters <- expand_grid(
  dataset,
  output_lib,
  filter_threshold,
  similarity_threshold,
  discordant,
  gene_column,
  logfc_column,
  pval_column
) |>
  rename(expr = data) |>
  select(-dataset)

results <- parameters |>
  pmap(investigate_signature) |>
  set_names(dataset$dataset) |>
  map_dfr(.id = "dataset")
