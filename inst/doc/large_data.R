## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE, warning=FALSE------------------------------------
library(comtradr)
library(dplyr)
library(ggplot2)


## -----------------------------------------------------------------------------
wood <-
  c(
    "4401",
    "4402",
    "4403",
    "4404",
    "4405",
    "4406",
    "4407",
    "4408",
    "4409",
    "4410",
    "4411",
    "4412",
    "4413",
    "4414",
    "4415",
    "4416",
    "4417",
    "4418",
    "4419",
    "4420",
    "4421",
    "940330",
    "940340",
    "940350",
    "940360",
    "940391",
    "940610",
    "4701",
    "4702",
    "4703",
    "4704",
    "4705",
    "470610", 
    "470691", 
    "470692", 
    "470693",
    "48",
    "49",
    "9401"
  )
wood_df <- data.frame(cmd_code = wood, product_cat = "wood")


## ----echo = FALSE-------------------------------------------------------------
v_data_6 <- system.file("extdata", "vignette_data_6.rda", package = "comtradr")
if (!file.exists(v_data_6)) {
  stop("internal vignette data set '~/extdata/vignette_data_6.rda' not found", 
       call. = FALSE)
}
load(v_data_6)

## ----eval = F-----------------------------------------------------------------
# eu_countries <- giscoR::gisco_countrycode |>
#   filter(eu == T) |>
#   pull(ISO3_CODE)

## ----eval = F-----------------------------------------------------------------
# data_eu_imports <- ct_get_data(
#     commodity_code = wood,
#     reporter = eu_countries,
#     partner = "all_countries",
#     flow_direction = "import",
#     start_date = 2018,
#     end_date = 2022
#   )

## ----echo = FALSE-------------------------------------------------------------
v_data_4 <- system.file("extdata", "vignette_data_4.rda", package = "comtradr")
if (!file.exists(v_data_4)) {
  stop("internal vignette data set '~/extdata/vignette_data_4.rda' not found", 
       call. = FALSE)
}
load(v_data_4)

## ----echo = FALSE-------------------------------------------------------------
v_data_5 <- system.file("extdata", "vignette_data_5.rda", package = "comtradr")
if (!file.exists(v_data_5)) {
  stop("internal vignette data set '~/extdata/vignette_data_5.rda' not found", 
       call. = FALSE)
}
load(v_data_5)

## ----eval = F-----------------------------------------------------------------
# ## initiate a new instance of an empty tibble()
# data_eu_imports <- data.frame()
# 
# for(reporter in eu_countries){
#   ## for a simple status, print the country we are at
#   ## you can get a lot fancier with the library `progress` for progress bars
#   print(reporter)
# 
#   ## assign the result into a temporary object
#   temp <- ct_get_data(
#     commodity_code = wood,
#     reporter = reporter,
#     partner = "all_countries",
#     flow_direction = "import",
#     start_date = 2018,
#     end_date = 2022
#   )
# 
#   ## bind the subset to the complete data
#   data_eu_imports <- rbind(data_eu_imports, temp)
# 
#   ## note that I did not include any sleep() command here to make the requests
#   ## wait for a specified amount of time, the package keeps track of that for
#   ## you automatically and backs off when needed
# }
# 

## -----------------------------------------------------------------------------
nrow(data_eu_imports)

## ----eval = F-----------------------------------------------------------------
# data_eu_imports_world <- ct_get_data(
#     commodity_code = wood,
#     reporter = eu_countries,
#     partner = "World",
#     flow_direction = "import",
#     start_date = 2018,
#     end_date = 2022
#   )

## -----------------------------------------------------------------------------
nrow(data_eu_imports_world)

## ----echo = F-----------------------------------------------------------------

## we merge the product category as a variable and size down our data
data_eu_imports_clean <- data_eu_imports |>
  left_join(wood_df, by = "cmd_code") |>
  select(
    reporter_iso,
    reporter_desc,
    flow_desc,
    partner_iso,
    partner_desc,
    cmd_code,
    cmd_desc,
    product_cat,
    primary_value,
    ref_year
  ) |>
  ## we now aggregate the imports by the product category, year and partners
  group_by(partner_iso, partner_desc, flow_desc, product_cat, ref_year) |>
  summarise(eu_import_product_cat = sum(primary_value)) |>
  ungroup()

## -----------------------------------------------------------------------------
data_eu_imports_world_clean <- data_eu_imports_world |>
  left_join(wood_df, by = "cmd_code") |>
  select(
    reporter_iso,
    reporter_desc,
    flow_desc,
    partner_iso,
    partner_desc,
    cmd_code,
    cmd_desc,
    product_cat,
    primary_value,
    ref_year
  ) |>
    ## we now aggregate the imports by the product category and year 
    ## over all reporters, since we are interested 
    ## in the imports of the whole EU
  group_by(product_cat, ref_year) |>
  summarise(eu_import_product_cat_world = sum(primary_value)) |>
  ungroup()

## -----------------------------------------------------------------------------
#### relevance to EU
relevance <- data_eu_imports_clean |> 
  left_join(data_eu_imports_world_clean) |> 
  ## join the two datasets
  mutate(relevance_eu = eu_import_product_cat/
           eu_import_product_cat_world*100) |> 
  ## calculate the ratio between world imports and imports from one partner |> 
  select( -flow_desc) |> ungroup()  

## -----------------------------------------------------------------------------
top_10 <- relevance |> 
  filter(!partner_iso %in% eu_countries) |> 
  group_by(ref_year) |> 
  slice_max(order_by = relevance_eu, n = 10) |> 
  select(partner_desc, relevance_eu, ref_year) |> 
  arrange(desc(ref_year))

head(top_10, 10)

## -----------------------------------------------------------------------------
relevance |> ungroup() |> 
  group_by(ref_year) |> 
  summarise(sum = sum(relevance_eu))

## -----------------------------------------------------------------------------
average_share <- relevance |> 
  filter(!partner_iso %in% eu_countries) |> 
  group_by(partner_iso, partner_desc) |>
  summarise(mean_relevance_eu = mean(relevance_eu)) |> 
  ungroup() |> 
  slice_max(order_by = mean_relevance_eu, n = 10)

## ----fig.width=10-------------------------------------------------------------
ggplot(average_share) +
  geom_col(aes(reorder(partner_desc,mean_relevance_eu), mean_relevance_eu), 
           fill = 'brown') +
  coord_flip() + 
  theme_minimal() +
  labs(title = 'Share of EU imports', 
       subtitle = 'as average over last 4 years') +
  xlab('average relevance in %')+
  ylab('')

