## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE--------------------------------------------------------
library(comtradr)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("comtradr")

## -----------------------------------------------------------------------------
library(comtradr)

## ----eval = F-----------------------------------------------------------------
#  library(comtradr)
#  
#  set_primary_comtrade_key()

## ----eval = F-----------------------------------------------------------------
#  Sys.setenv('COMTRADE_PRIMARY' = 'xxxxxxxxxxxxxxxxx')

## ----eval = F-----------------------------------------------------------------
#  usethis::edit_r_environ(scope = 'project')

## ----echo = FALSE-------------------------------------------------------------
v_data_1 <- system.file("extdata", "vignette_data_1.rda", package = "comtradr")
if (!file.exists(v_data_1)) {
  stop("internal vignette data set '~/extdata/vignette_data_1.rda' not found",
       call. = FALSE)
}
load(v_data_1)

## ----eval = FALSE-------------------------------------------------------------
#  example_1 <- ct_get_data(
#    reporter = 'USA',
#    partner = c('DEU', 'FRA','JPN','MEX'),
#    commodity_code = 'TOTAL',
#    start_date = 2018,
#    end_date = 2023,
#    flow_direction = 'import'
#  )

## -----------------------------------------------------------------------------
str(example_1)

## ----eval = FALSE-------------------------------------------------------------
#  # all monthly data for a single year (API max of 12 months per call).
#  q <- ct_search(reporters = "USA",
#                 partners = c("Germany", "France", "Japan", "Mexico"),
#                 flow_direction = "import",
#                 start_date = 2012,
#                 end_date = 2012,
#                 freq = "monthly")
#  
#  # monthly data for specific span of months (API max of twelve months per call).
#  q <- ct_search(reporters = "USA",
#                 partners = c("Germany", "France", "Japan", "Mexico"),
#                 flow_direction = "import",
#                 start_date = "2012-03",
#                 end_date = "2012-07",
#                 freq = "monthly")

## -----------------------------------------------------------------------------
ct_commodity_lookup("tomato")

## ----eval = FALSE-------------------------------------------------------------
#  tomato_codes <- ct_commodity_lookup("tomato",
#                                      return_code = TRUE,
#                                      return_char = TRUE)
#  
#  q <- ct_get_data(
#    reporter = 'USA',
#    partner = c('DEU', 'FRA','JPN','MEX'),
#    commodity_code = tomato_codes,
#    start_date = "2012",
#    end_date = "2013",
#    flow_direction = 'import'
#  )

## ----eval = FALSE-------------------------------------------------------------
#  q <- ct_get_data(
#    reporter = 'USA',
#    partner = c('DEU', 'FRA','JPN','MEX'),
#    commodity_code  = c("0702", "070200", "2002", "200210", "200290"),
#    start_date = "2012",
#    end_date = "2013",
#    flow_direction = 'import'
#  )
#  

## -----------------------------------------------------------------------------
# The url of the API call.
attributes(q)$url
# The date-time of the API call.
attributes(q)$time

## -----------------------------------------------------------------------------
ct_commodity_lookup(c("tomato", "trout"), return_char = TRUE)

## -----------------------------------------------------------------------------
ct_commodity_lookup(c("tomato", "trout"), return_char = FALSE)

## -----------------------------------------------------------------------------
ct_commodity_lookup(c("tomato", "sldfkjkfdsklsd"), verbose = TRUE)

## ----eval = F-----------------------------------------------------------------
#  ct_commodity_lookup('tomato',update = T)

## ----echo = FALSE-------------------------------------------------------------
v_data_2 <- system.file("extdata", "vignette_data_2.rda", package = "comtradr")
if (!file.exists(v_data_2)) {
  stop("internal vignette data set '~/extdata/vignette_data_2.rda' not found",
       call. = FALSE)
}
load(v_data_2)

## ----eval = FALSE-------------------------------------------------------------
#  # Comtrade api query.
#  example_2 <- ct_get_data(
#    reporter = 'CHN',
#    partner = c('KOR', 'USA','MEX'),
#    commodity_code = 'TOTAL',
#    start_date = 2012,
#    end_date = 2023,
#    flow_direction = 'export'
#  )

## ----warning = FALSE, message = FALSE-----------------------------------------
library(ggplot2)

# Apply polished col headers.
# Create plot.
ggplot(example_2, aes(period, primary_value/1000000000, color = partner_desc, 
                      group = partner_desc)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  scale_color_manual( values = c("darkgreen","red","grey30"),
                      name = "Destination\nCountry") +
  ylab('Export Value in billions') +
  xlab('Year') +
  labs(title = "Total Value (USD) of Chinese Exports", subtitle = 'by year') +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  theme_minimal()

## ----echo = FALSE-------------------------------------------------------------
v_data_3 <- system.file("extdata", "vignette_data_3.rda", package = "comtradr")
if (!file.exists(v_data_3)) {
  stop("internal vignette data set '~/extdata/vignette_data_3.rda' not found", 
       call. = FALSE)
}
load(v_data_3)

## ----eval = FALSE-------------------------------------------------------------
#  # First, collect commodity codes related to shrimp.
#  shrimp_codes <- ct_commodity_lookup("shrimp",
#                                      return_code = TRUE,
#                                      return_char = TRUE)
#  
#  # Comtrade api query.
#  example_3 <- ct_get_data(reporter = "THA",
#                  partner = "all",
#                  trade_direction = "exports",
#                  start_date = 2007,
#                  end_date = 2011,
#                  commodity_code = shrimp_codes)

## ----warning = FALSE, message = FALSE-----------------------------------------
library(ggplot2)
library(dplyr)


# Create country specific "total weight per year" dataframe for plotting.
plotdf <- example_3 %>%
  group_by(partner_desc, period) %>%
  summarise(kg = as.numeric(sum(net_wgt, na.rm = TRUE))) 

# Get vector of the top 8 destination countries/areas by total weight shipped
# across all years, then subset plotdf to only include observations related
# to those countries/areas.
top8 <- plotdf |> 
  group_by(partner_desc) |> 
  summarise(kg = as.numeric(sum(kg, na.rm = TRUE))) |> 
  slice_max(n = 8, order_by = kg) |> 
  arrange(desc(kg)) |> 
  pull(partner_desc)
plotdf <- plotdf %>% filter(partner_desc %in% top8)

# Create plots (y-axis is NOT fixed across panels, this will allow us to ID
# trends over time within each country/area individually).
ggplot(plotdf,aes(period,kg/1000, group = partner_desc))+
  geom_line() + 
  geom_point() + 
  facet_wrap(.~partner_desc, nrow = 2, ncol = 4,scales = 'free_y')+
  labs(title = "Weight (KG in tons) of Thai Shrimp Exports", 
       subtitle ="by Destination Area, 2007 - 2011")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45,hjust = 1, vjust = 1))

## ----warning = FALSE, message = FALSE, eval = F-------------------------------
#  # Querying all commodities and flow directions for USA and Germany from
#  ## 2010 to 2011
#  data <- ct_get_data(
#    reporter = c('USA', 'DEU'),
#    commodity_code = 'everything',
#    flow_direction = 'everything',
#    start_date = '2010',
#    end_date = '2011'
#  )

