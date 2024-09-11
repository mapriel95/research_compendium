library(dplyr)
library(tidyr)
#### ADD HERE CALL TO LIBRARY **************************************************
library(ggplot2)
library(huxtable)

# Settings----
set.seed(25)

# Load data----
data <- read.csv(file = "data/cleaned_data/data.csv")

# Summary table----
sum_table <- data |>
  group_by(year, name, island, sex) |>
  count() |>
  pivot_wider(id_cols = NULL, names_from = c(name, sex), values_from = n) |>
  ungroup()

write.csv(sum_table,
          file = "output/tables/summary_table.csv",
          row.names = FALSE)

#### ADD HERE HUXTABLE SCRIPT **************************************************
## Formatted table----
cols <- sum_table |>
  select(-year) |>
  colnames()

form_table <- sum_table |>
  select(all_of(cols)) |>
  as_hux() |>
  set_na_string("-") |>
  insert_row(cols, after = 1) |>
  set_contents(row = 1, value = sub(cols,
                                    pattern = "_\\w+$",
                                    replacement = "")) |>
  set_contents(row = 2, value = sub(cols,
                                    pattern = "^\\w+_",
                                    replacement = "") |>
                 substring(1, 1)) |>
  set_contents(row = 2, col = 1, value = "") |>
  set_bottom_border(row = c(2, 5), col = everywhere) |>
  set_bold(row = 1, col = everywhere) |>
  set_align(row = 1:5, col = 2:7, value = "centre")

form_table |>
  quick_docx(file = "output/tables/summary_table.docx")

# Plot data----
png("output/figures/bodymass_sex_boxplot_old.png",
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

#### Add here GGPLOT SCRIPT*****************************************************

p <- ggplot(cleaned_data, mapping = aes(x = sex, y = body_mass, colour = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.2) +
  labs(x = "", y = "Body mass (g)") +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank())

ggsave(filename = "output/figures/bodymass_sex_boxplot.png",
       plot = p,
       device = "png",
       bg = "white")
