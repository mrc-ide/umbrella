test_that("URLs", {
  expect_type(urls(2010), "character")
  expect_length(urls(2010), 365)
  expect_length(urls(2004), 366)
})


test_that("Links", {
  expect_equal(links("a", 2000, 1, 1), "a2000/chirp.2000.1.1.tif")
})

test_that("Download", {
  expect_error(download(2015, -1, "t"))
  expect_error(download(2015, 368, "t"))
  expect_error(download(1979, 1, "t"))
  expect_error(download(3000, 1, "t"))
  expect_error(download(2015, 1, "bad_address"))
})

