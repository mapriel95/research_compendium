bib_file <- "manuscript/software.bib"

# List of package to cite
pkgs <- c("base",
          "dplyr",
          "ggplot2",
          "tidyr")

knitr::write_bib(pkgs,
                 file = bib_file,
                 width = 80,
                 prefix = "pkg_")

rstudio <- RStudio.Version()[["citation"]] |>
  print(style = "bibtex") |>
  capture.output()

bib <- readLines(bib_file) |>
  # Fix capitalisation of package name
  sub("dplyr:", "{dplyr}:", x = _) |>
  sub("ggplot2:", "{ggplot2}:", x = _) |>
  sub("tidyr:", "{tidyr}:", x = _) |>
  # Add RStudio
  c(rstudio) |>
  sub("@Manual{,", "@Manual{rstudio,", fixed = TRUE, x = _)

writeLines(bib, bib_file)
