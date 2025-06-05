test_that("get days works", {
  expect_equal(get_days(2020), c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
})

test_that("get urls works", {
  year <- 2020

  n_days <- get_days(year)
  days <- unlist(sapply(n_days, function(x) 1:x))
  indexes <- data.frame(year = year,
                        month = stringr::str_pad(rep(1:12, n_days), 2, pad = "0"),
                        day = stringr::str_pad(days, 2, pad = "0"))
  indexes <- data.frame(year = year,
                        month = stringr::str_pad(rep(1:12, n_days), 2, pad = "0"),
                        day = stringr::str_pad(days, 2, pad = "0"))
  url_base_year <- paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_daily/tifs/p25/",
                          year, "/chirps-v2.0.")
  urls <- apply(indexes, 1, function(x){
    paste0(url_base_year, x[1], ".", x[2], ".", x[3], ".tif.gz")
  })

  expect_equal(get_urls(year), urls)
})

test_that("get urls requires past year", {
  next_year <- as.integer(format(Sys.Date(), "%Y")) + 1
  expect_error(get_urls(next_year), "Year must be in the past")
})

