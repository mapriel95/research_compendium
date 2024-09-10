
library(stringr)
library(tidyr)
library(dplyr)
set.seed(25)

# Download date----
# https://doi.org/10.6073/pasta/98b16d7d563f265cb52372c8ca99e60f
# https://doi.org/10.6073/pasta/9fc8f9b5a2fa28bdca96516649b6599b
# https://doi.org/10.6073/pasta/ce9b4713bb8c065a8fcfd7f50bf30dde
url <- "https://portal.edirepository.org/nis/dataviewer?"
q <- c("packageid=knb-lter-pal.219.5&entityid=002f3893385f710df69eeebe893144ff",
       "packageid=knb-lter-pal.220.7&entityid=e03b43c924f226486f2f0ab6709d2381",
       "packageid=knb-lter-pal.221.8&entityid=fe853aa8f7a59aa84cdd3197619ef462")

files <- c("data/raw_data/adelie.csv",
           "data/raw_data/gentoo.csv",
           "data/raw_data/chinstrap.csv")

download.file(paste0(url, q), files, "libcurl")

raw_data <- do.call(rbind,
                    lapply(files,
                           read.csv,
                           na.strings = c("NA", "", ".")))

# Clean data----
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

# Data analysis----
## Table----
sum_table <- cleaned_data |>
  group_by(year, name, island, sex) |>
  count() |>
  pivot_wider(names_from = c(name, sex), values_from = n) |>
  rename(Island = island)

write.csv(sum_table,
          file = "output/tables/summary_table.csv",
          row.names = FALSE)

## Graph----
png("output/figures/bodymass_sex_boxplot.png",
    width = 560,
    height = 560)

boxplot(body_mass ~ sex,
        data = cleaned_data,
        xlab = "",
        ylab = "Body mass (g)",
        las = 2)

stripchart(body_mass ~ sex,
           data = cleaned_data,
           vertical = TRUE,
           method = "jitter",
           jitter = 0.2,
           add = TRUE,
           pch = 1,
           cex = 0.8)

dev.off()
