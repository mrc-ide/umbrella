#' Estimate the fourier coefficients
#'
#' @inheritParams objective
#' @export
fourier_predict <- function(coef, t, floor){
  prediction <- data.frame(
    g0 = coef[1],
    g1 = coef[2] * basecos(level = 1, t = t),
    g2 = coef[3] * basecos(level = 2, t = t),
    g3 = coef[4] * basecos(level = 3, t = t),
    h1 = coef[5] * basesin(level = 1, t = t),
    h2 = coef[6] * basesin(level = 2, t = t),
    h3 = coef[7] * basesin(level = 3, t = t)) %>%
    rowSums()
  prediction <- pmax(floor, prediction)
  out <- data.frame(t = t, profile = prediction)
  return(out)
}

#' Objective function for fitting
#'
#' @param coef Fourier coefficients
#' @inheritParams fit_fourier
#'
#' @return Sum of squared differences between profile and rainfall data
objective <- function(coef, t, floor, rainfall){
  sum((fourier_predict(coef = coef, t = t, floor = floor)$profile - rainfall)^2)
}

#' Fit fourier parameters
#'
#' Note without the floor functionality parameters can be more efficiently estimated
#' with `lm()`.
#'
#' @param rainfall Vector of rainfall
#' @param t Vector of timesteps (between 0 and 1)
#' @param floor Lower bound on rainfall fit
#'
#' @return Model fit
#' @export
fit_fourier <- function(rainfall, t, floor = 0.001){
  fit <- stats::nlm(f = objective, p = c(mean(rainfall), rep(0, 6)), t = t, rainfall = rainfall, floor = floor)
  coefficients <- fit$estimate
  names(coefficients) <- c("g0", "g1", "g2", "g3", "h1", "h2", "h3")
  fit$coefficients <- as.numeric((t(coefficients)))
  fit$floor <- floor
  return(fit)
}

#' Cos component of fourier series
#'
#' @param level level: 1, 2, or 3
#' @param t time
basecos <- function(level, t = 1:365 / 365){
  cos(2 * pi * t * level)
}

#' Sin component of fourier series
#'
#' @param level level: 1, 2, or 3
#' @param t time
basesin <- function(level, t = 1:365 / 365){
  sin(2 * pi * t * level)
}
