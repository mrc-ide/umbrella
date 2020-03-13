test_that("fourier internal", {
  expect_equal(s_a(0, 0.5, 1), 0)
  expect_equal(s_a(0.5, 0.5, 1), -0.5)
  expect_equal(s_a(-0.5, 0.5, 1), 0.5)

  expect_equal(s_b(0, 0.5, 1), 0)
})

test_that("fourier", {
  expect_error(seasonality(rep(0,6)))
  expect_error(seasonality(rep(0,8)))
  expect_equal(seasonality(rep(0,7)), rep(0,365))
})
