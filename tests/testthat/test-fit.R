test_that("Fit season", {
  o1 <- fit_season(rep(0, 365), t = seq(0, 1, length.out = 365))
  expect_equal(o1$par, rep(0, 7))
  set.seed(123)
  o2 <- fit_season(rep(1, 365), t = seq(0, 1, length.out = 365))
  expect_equal(round(o2$par), c(1, rep(0, 6)))
  expect_error(fit_season(rep(1, 365), 1:5))
})
