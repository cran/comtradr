## ----eval = FALSE-------------------------------------------------------------
# #### Previously
# q <- ct_search(reporters = "USA",
#                partners = c("Germany", "France", "Japan", "Mexico"),
#                trade_direction = "imports")
# 
# #### Now
# q <- ct_get_data(reporter = "USA",
#                partner = c("DEU", "FRA", "JPN", "MEX"),
#                flow_direction = "import",
#                start_date = 2020,
#                end_date = 2023)

## ----eval = FALSE-------------------------------------------------------------
# #### Previously
# # Get all monthly data for a single year (API max of 12 months per call).
# q <- ct_search(reporters = "USA",
#                partners = c("Germany", "France", "Japan", "Mexico"),
#                trade_direction = "imports",
#                start_date = 2012,
#                end_date = 2012,
#                freq = "monthly")
# 
# # monthly data for a specific span of months (API max of five months per call).
# q <- ct_search(reporters = "USA",
#                partners = c("Germany", "France", "Japan", "Mexico"),
#                trade_direction = "imports",
#                start_date = "2012-03",
#                end_date = "2012-07",
#                freq = "monthly")
# 
# 
# #### Now
# # Get all monthly data for a single year (API max of 12 months per call).
# q <- ct_get_data(reporter = "USA",
#                partner = c("DEU", "FRA", "JPN", "MEX"),
#                flow_direction = "import",
#                start_date = 2012,
#                end_date = 2012,
#                frequency = "M"
#                )
# 
# # monthly data for a specific span of months (API max of five months per call).
# q <- ct_get_data(reporter = "USA",
#                partner = c("DEU", "FRA", "JPN", "MEX"),
#                flow_direction = "import",
#                start_date = "2012-03",
#                end_date = "2012-07",
#                frequency = "M"
#                )

## ----eval = F-----------------------------------------------------------------
# ct_country_lookup("korea", "reporter")
# ct_country_lookup("bolivia", "partner")
# q <- ct_search(reporters = "Rep. of Korea",
#                partners = "Bolivia (Plurinational State of)",
#                trade_direction = "all")

## ----eval = F-----------------------------------------------------------------
# 
# asia <- countrycode::codelist |>
#   poorman::filter(un.region.name == "Asia") |>
#   poorman::pull(iso3c)
# 
# q <- ct_get_data(reporter = asia,
#                partner = c("DEU", "FRA", "JPN", "MEX"),
#                flow_direction = "import",
#                start_date = 2012,
#                end_date = 2012,
#                frequency = "M"
#                )

## ----eval = F-----------------------------------------------------------------
# ct_commodity_lookup("tomato")

## ----eval = FALSE-------------------------------------------------------------
# tomato_codes <- ct_commodity_lookup("tomato",
#                                     return_code = TRUE,
#                                     return_char = TRUE)

## ----echo = FALSE-------------------------------------------------------------
v_data_7 <- system.file("extdata", "vignette_data_7.rda", package = "comtradr")
if (!file.exists(v_data_7)) {
  stop("internal vignette data set '~/extdata/vignette_data_7.rda' not found", 
       call. = FALSE)
}
load(v_data_7)

## ----eval = F-----------------------------------------------------------------
# #### Previously
# # The url of the API call.
# attributes(q)$url
# # The date-time of the API call.
# attributes(q)$time_stamp
# # The total duration of the API call, in seconds.
# attributes(q)$req_duration

## -----------------------------------------------------------------------------
#### Now
# The url of the API call.
attributes(q)$url
# The date-time of the API call.
attributes(q)$time
# The total duration of the API call, in seconds is not returned anymore!

## ----eval = FALSE-------------------------------------------------------------
# ct_update_databases()
# 
# ct_commodity_db_type()

## ----eval = F-----------------------------------------------------------------
# ## to get the parameter values for the mode_of_transport argument
# ct_get_ref_table("mode_of_transport")
# 
# ## to get the parameter values for the partner argument
# ct_get_ref_table("partner")
# 
# ## to update the parameter reference for the partner argument
# ct_get_ref_table("partner", update = T)
# 
# ## to get any commodity classification scheme, just pass in the code
# ## you would use in commodity_classification
# ct_get_ref_table("HS")

## ----eval = F-----------------------------------------------------------------
# # Apply polished column headers
# q <- ct_use_pretty_cols(q)

