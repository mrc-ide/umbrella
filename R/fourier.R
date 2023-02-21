#' Estimate the fourier coefficients
#'
#' @inheritParams objective
#' @export
fourier_predict <- function(coef, t, floor){
  if(any(t > 365) | any (t < 1)){
    stop("t must be between 1 and 365")
  }
  t <- t / 365
  coef <- unname(coef)
  prediction <- data.frame(
    g0 = coef[1],
    g1 = coef[2] * basecos(level = 1, t = t),
    g2 = coef[3] * basecos(level = 2, t = t),
    g3 = coef[4] * basecos(level = 3, t = t),
    h1 = coef[5] * basesin(level = 1, t = t),
    h2 = coef[6] * basesin(level = 2, t = t),
    h3 = coef[7] * basesin(level = 3, t = t))
  prediction <- rowSums(prediction)
  prediction <- pmax(floor, prediction)
  out <- data.frame(t = t * 365, profile = prediction)
  return(out)
}

#' Objective function for fitting
#'
#' @param coef Fourier coefficients
#' @inheritParams fit_fourier
#'
#' @return Sum of squared differences between profile and rainfall data
objective <- function(coef, t, floor, rainfall){
  sum((umbrella::fourier_predict(coef = c(mean(rainfall), coef), t = t, floor = floor)$profile - rainfall)^2)
}

#' Fit fourier parameters
#'
#' Note without the floor functionality parameters can be more efficiently estimated
#' with `lm()`.
#'
#' @param rainfall Vector of rainfall
#' @param t Vector of days (between 1 and 365)
#' @param floor Lower bound on rainfall fit
#'
#' @return Model fit
#' @export
fit_fourier <- function(rainfall, t, floor = 0.001){
  if(length(rainfall) != length(t)){
    stop("rainfall and t must be of equal length")
  }
  if(floor < 0){
    stop("floor must be >= 0")
  }

  if(floor == 0){
    fit <- fit_lm(rainfall, t)
    out <- list(coefficients = fit$coef)
  } else {
    fit <- stats::optim(par = rep(0, 6), fn = objective,
                 method = "L-BFGS-B",
                 lower = rep(-10, 7), upper = rep(10, 7),
                 t = t, floor = floor, rainfall = rainfall)
    out <- list(coefficients = c(mean(rainfall), fit$par))
  }

  names(out$coefficients) <- c("g0", "g1", "g2", "g3", "h1", "h2", "h3")
  out$floor <- floor
  return(out)
}

#' Linear model fit
#'
#' @inheritParams fit_fourier
#' @export
fit_lm <- function(rainfall, t){
  if(any(t > 365) | any (t < 1)){
    stop("t must be between 1 and 365")
  }
  t <- t / 365
  model_data <- data.frame(
    rainfall = rainfall,
    g1 = basecos(level = 1, t = t),
    g2 = basecos(level = 2, t = t),
    g3 = basecos(level = 3, t = t),
    h1 = basesin(level = 1, t = t),
    h2 = basesin(level = 2, t = t),
    h3 = basesin(level = 3, t = t))

  model <- stats::lm(rainfall ~ g1 + g2 + g3 + h1 + h2 + h3, data = model_data)
  return(model)
}

#' Cos component of fourier series
#'
#' @param level level: 1, 2, or 3
#' @param t time
basecos <- function(level, t){
  cos(2 * pi * t * level)
}

#' Sin component of fourier series
#'
#' @param level level: 1, 2, or 3
#' @param t time
basesin <- function(level, t){
  sin(2 * pi * t * level)
}
