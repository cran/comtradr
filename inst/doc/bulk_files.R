## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE-----------------------------------------------------
library(comtradr)
library(dplyr)

## ----echo = FALSE-------------------------------------------------------------
hs0 <- system.file("extdata", "vignette_data_8.rda", package = "comtradr")
if (!file.exists(hs0)) {
  stop("internal vignette data set '~/extdata/vignette_data_8.rda' not found",
       call. = FALSE)
}
load(hs0)

## ----echo = FALSE-------------------------------------------------------------
hs5 <- system.file("extdata", "vignette_data_9.rda", package = "comtradr")
if (!file.exists(hs5)) {
  stop("internal vignette data set '~/extdata/vignette_data_9.rda' not found",
       call. = FALSE)
}
load(hs5)

## ----free_api, eval = F-------------------------------------------------------
#  hs0 <- comtradr::ct_get_data(
#    reporter = c("DEU","FRA"), # only some examples here,
#    commodity_classification = 'HS',
#    commodity_code = '0306',
#    start_date = 1990, # only one year here
#    end_date = 1990)
#  
#  hs5 <- comtradr::ct_get_data(
#    reporter = c("DEU","FRA"), # only some examples here,
#    commodity_classification = 'HS',
#    commodity_code = '0306',
#    start_date = 2020, # only one year here
#    end_date = 2020)

## ----cmd_desc_differences-----------------------------------------------------
print(unique(c(hs0$cmd_desc,hs5$cmd_desc)))

## ----eval = FALSE-------------------------------------------------------------
#  hs0_all <- comtradr::ct_get_bulk(
#    reporter = c("DEU","FRA"), # only some examples here,
#    commodity_classification = 'H0',
#    frequency = 'A',
#    verbose = T,
#    start_date = 1990, # only one year here
#    end_date = 2020)

## ----echo = FALSE-------------------------------------------------------------
hs0_all <- system.file("extdata", "vignette_data_10.rda", package = "comtradr")
if (!file.exists(hs0_all)) {
  stop("internal vignette data set '~/extdata/vignette_data_10.rda' not found",
       call. = FALSE)
}
load(hs0_all)

## -----------------------------------------------------------------------------
reporter <- comtradr::ct_get_ref_table("reporter") |>
  dplyr::transmute(
    reporter_code = as.character(id),
    reporter_iso = iso_3,
    reporter_desc = country
  )

partner <- comtradr::ct_get_ref_table("partner") |>
  dplyr::transmute(
    partner_code = as.character(id),
    partner_iso = iso_3,
    partner_desc = country
  )

flow <- comtradr::ct_get_ref_table("flow_direction") |>
  dplyr::transmute(flow_code = as.character(id), flow_desc = tolower(text))

clean_data <- hs0_all |>
  dplyr::filter(customs_code == "C00" &
                  mot_code == "0" & partner2code == "0")  |>
  dplyr::left_join(reporter) |>
  dplyr::left_join(partner) |>
  dplyr::left_join(flow) |>
  dplyr::transmute(
    frequency = freq_code,
    reporter_desc,
    reporter_iso,
    partner_desc,
    partner_iso,
    classification_code,
    cmd_code,
    flow_desc = tolower(flow_desc),
    time = period,
    customs_code,
    mot_code,
    mos_code,
    partner2code,
    primary_value
  ) 

