test_that("extract", {
  expect_error(extract_rain(c("foo", "bar"), 1))
})
