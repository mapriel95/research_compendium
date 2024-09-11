library(tidyr)
library(dplyr)

# Settings----
set.seed(25)

## Load data----
data <- read.csv(file = "data/cleaned_data/data.csv")

## Table
sum_table <- data |>
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
        data = data,
        xlab = "",
        ylab = "Body mass (g)",
        las = 2)

stripchart(body_mass ~ sex,
           data = data,
           vertical = TRUE,
           method = "jitter",
           jitter = 0.2,
           add = TRUE,
           pch = 1,
           cex = 0.8)

dev.off()
