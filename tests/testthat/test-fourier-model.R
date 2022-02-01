test_that("fourier model", {
  m1 <- fit_fourier(cos(2 * pi * 1:365 / 365), 1:365 / 365, floor = 0)
  expect_equal(class(m1), "list")
  expect_identical(round(m1$coefficients, 2), c(0, 1, 0, 0, 0, 0, 0))
  expect_identical(m1$floor, 0)

  m2 <- fit_fourier(sin(2 * pi * 1:365 / 365), 1:365 / 365, floor = 0)
  expect_equal(class(m2), "list")
  expect_identical(round(m2$coefficients, 2), c(0, 0, 0, 0, 1, 0, 0))
  expect_identical(m2$floor, 0)

  m3 <- fit_fourier(sin(2 * pi * 1:365 / 365), 1:365 / 365, floor = 10)
  expect_identical(m3$floor, 10)
  pred <- fourier_predict(m3$coefficients, t = 1:365 / 365, floor = m3$floor)
  expect_equal(min(pred$profile), 10)
})
