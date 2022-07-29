test_that("fourier model", {
  m1 <- fit_fourier(cos(2 * pi * 1:365 / 365), 1:365, floor = 0)
  expect_equal(class(m1), "list")
  expect_identical(round(m1$coefficients, 2), c(g0 = 0, g1 = 1, g2 = 0, g3 = 0, h1 = 0, h2 = 0, h3 = 0))
  expect_identical(m1$floor, 0)

  m2 <- fit_fourier(sin(2 * pi * 1:365 / 365), 1:365, floor = 0)
  expect_equal(class(m2), "list")
  expect_identical(round(m2$coefficients, 2), c(g0 = 0, g1 = 0, g2 = 0, g3 = 0, h1 = 1, h2 = 0, h3 = 0))
  expect_identical(m2$floor, 0)

  m3 <- fit_fourier(sin(2 * pi * 1:365 / 365), 1:365, floor = 10)
  expect_identical(m3$floor, 10)
  pred <- fourier_predict(m3$coefficients, t = 1:365, floor = m3$floor)
  expect_equal(min(pred$profile), 10)

  expect_error(fit_fourier(1:10, 1:9), "rainfall and t must be of equal length")
  expect_error(fit_fourier(1:10, 1:10, floor = -1), "floor must be >= 0")
  expect_error(fourier_predict(coef = rep(0, 7), t = 366, floor = 0), "t must be between 1 and 365")
})
