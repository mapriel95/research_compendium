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
