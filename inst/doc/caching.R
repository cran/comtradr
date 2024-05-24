## ----eval = FALSE-------------------------------------------------------------
#  library(comtradr)
#  #### Now
#  q <- ct_get_data(reporter = "USA",
#                 partner = c("DEU", "FRA", "JPN", "MEX"),
#                 flow_direction = "import",
#                 start_date = 2020,
#                 end_date = 2023,
#                 cache = TRUE) # <----- set this argument to TRUE

## ----eval = FALSE-------------------------------------------------------------
#  ## to delete all files in your cache
#  tools::R_user_dir('comtradr', which = 'cache') |>
#    fs::dir_delete()

## ----eval = FALSE-------------------------------------------------------------
#  ## to delete all files in your cache
#  tools::R_user_dir('comtradr_bulk', which = 'cache') |>
#    fs::dir_delete()

