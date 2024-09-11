library(stringr)
library(dplyr)
set.seed(25)

files <- c("data/raw_data/adelie.csv",
           "data/raw_data/gentoo.csv",
           "data/raw_data/chinstrap.csv")

download.file(paste0(url, q), files, "libcurl")

raw_data <- do.call(rbind,
                    lapply(files,
                           read.csv,
                           na.strings = c("NA", "", ".")))

study_year <- 2008L

cleaned_data <- raw_data |>
  mutate(species = str_extract(string = Species, pattern = "(?<=\\().+(?=\\))"),
         name = word(string = Species, start = 1),
         year = as.integer(substring(Date.Egg, 1, 4)),
         id = row_number()) |>
  filter(year == study_year) |>
  rename(culmen_length = Culmen.Length..mm.,
         culmen_depth = Culmen.Depth..mm.,
         flipper_length = Flipper.Length..mm.,
         body_mass = Body.Mass..g.,
         island = Island,
         sex = Sex,
         individual_id = Individual.ID) |>
  select(id,
         individual_id,
         species,
         name,
         sex,
         year,
         island,
         culmen_length,
         culmen_depth,
         flipper_length,
         body_mass) |>
  na.omit()

write.csv(cleaned_data,
          "data/cleaned_data/data.csv",
          row.names = FALSE)
